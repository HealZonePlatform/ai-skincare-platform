from datetime import datetime, timezone

from app.schemas import (
    AnalysisRecord,
    AnalysisResult,
    CarePlanStep,
    ConcernInsight,
    ProductSuggestion,
    RecommendationHints,
    SkinProfile,
)
from app.services.analysis import GeminiAnalysisService
from app.services.rate_limiter import RateLimiter


def _sample_result(confidence: float = 0.8, severity: str = "moderate") -> AnalysisResult:
    return AnalysisResult(
        summary="Sample summary",
        skin_profile=SkinProfile(
            skin_type="combination",
            hydration="Balanced",
            oiliness="Moderate",
            sensitivity="Low",
            texture="Smooth",
        ),
        concern_assessment=[
            ConcernInsight(
                concern="acne",
                severity=severity,
                confidence=confidence,
                summary="Mild congestion",
            )
        ],
        care_plan=[
            CarePlanStep(
                step="cleanse",
                goal="Remove impurities",
                instructions="Use a gentle cleanser twice daily",
                suggested_ingredients=["salicylic acid"],
            )
        ],
        product_suggestions=[
            ProductSuggestion(
                product_id=None,
                category="cleanser",
                recommendation_reason="Balances oil production",
            )
        ],
        lifestyle_tips=["Stay hydrated"],
        recommendation_hints=RecommendationHints(product_ids=[], tags=["acne"]),
    )


def test_aggregate_confidence_handles_multiple_entries():
    result = _sample_result(confidence=0.9)
    value = GeminiAnalysisService._aggregate_confidence(result)
    assert value == 0.9


def test_derive_severity_maps_levels():
    result = _sample_result(severity="severe")
    severity = GeminiAnalysisService._derive_severity(result)
    assert severity == "critical"


def test_collect_concerns_returns_non_empty_list():
    result = _sample_result()
    concerns = GeminiAnalysisService._collect_concerns(result)
    assert concerns == ["acne"]


def test_cache_round_trip():
    from app.services.cache import AnalysisCache

    cache = AnalysisCache(ttl_seconds=60)
    record = AnalysisRecord(
        analysis_id="11111111-1111-1111-1111-111111111111",
        user_id="22222222-2222-2222-2222-222222222222",
        model="gemini-test",
        created_at=datetime.now(timezone.utc),
        locale="en",
        data=_sample_result(),
    )

    cache.set("key", record)
    cached = cache.get("key")
    assert cached is not None
    assert cached.analysis_id == record.analysis_id


def test_rate_limiter_blocks_user_after_threshold():
    limiter = RateLimiter(per_user=2, per_ip=5, window_seconds=60)
    assert limiter.allow(user_id="user-1", ip="1.1.1.1")
    assert limiter.allow(user_id="user-1", ip="1.1.1.1")
    assert not limiter.allow(user_id="user-1", ip="1.1.1.1")


def test_rate_limiter_blocks_ip_after_threshold():
    limiter = RateLimiter(per_user=5, per_ip=2, window_seconds=60)
    assert limiter.allow(user_id="user-a", ip="2.2.2.2")
    assert limiter.allow(user_id="user-b", ip="2.2.2.2")
    assert not limiter.allow(user_id="user-c", ip="2.2.2.2")
