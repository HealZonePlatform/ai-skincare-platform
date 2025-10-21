"""Configuration helpers for the AI service."""

from __future__ import annotations

import os
from dataclasses import dataclass
from functools import lru_cache
from typing import Optional, Tuple, List


def _to_int(value: Optional[str], default: int) -> int:
    if value is None:
        return default
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _to_float(value: Optional[str], default: float) -> float:
    if value is None:
        return default
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def _to_list(value: Optional[str]) -> Tuple[str, ...]:
    if not value:
        return ()
    parts: List[str] = []
    for item in value.split(","):
        token = item.strip()
        if token:
            parts.append(token)
    return tuple(parts)


@dataclass(frozen=True)
class Settings:
    """Immutable container with runtime configuration."""

    google_api_key: str
    gemini_model: str
    temperature: float
    top_p: float
    top_k: int
    max_output_tokens: int
    enable_schema: bool
    database_url: str
    db_pool_min_size: int
    db_pool_max_size: int
    db_statement_timeout_ms: int
    image_max_bytes: int
    image_max_width: int
    image_max_height: int
    cache_ttl_seconds: int
    max_concurrent_analyses: int
    gemini_retry_attempts: int
    gemini_retry_initial_delay: float
    gemini_retry_backoff: float
    scan_endpoint: Optional[str]
    scan_timeout_seconds: float
    rate_limit_per_user: int
    rate_limit_per_ip: int
    rate_limit_window_seconds: int
    analysis_retention_days: int
    analysis_retention_batch_size: int
    gemini_allowed_models: Tuple[str, ...]
    gemini_compare_models: Tuple[str, ...]
    default_detail_level: str
    analysis_slow_threshold_ms: int
    analysis_event_webhook: Optional[str]
    analysis_event_timeout_seconds: float
    google_api_key_file: Optional[str]
    google_api_key_refresh_seconds: int


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Build settings from environment variables."""

    return Settings(
        google_api_key=os.getenv("GOOGLE_AI_STUDIO_API_KEY", ""),
        gemini_model=os.getenv("GEMINI_MODEL_NAME", "gemini-1.5-flash-latest"),
        temperature=_to_float(os.getenv("GEMINI_TEMPERATURE"), 0.2),
        top_p=_to_float(os.getenv("GEMINI_TOP_P"), 0.9),
        top_k=_to_int(os.getenv("GEMINI_TOP_K"), 32),
        max_output_tokens=_to_int(os.getenv("GEMINI_MAX_OUTPUT_TOKENS"), 2048),
        enable_schema=os.getenv("GEMINI_USE_SCHEMA", "true").lower() == "true",
        database_url=os.getenv(
            "AI_SERVICE_DATABASE_URL",
            "postgresql://postgres:postgres@postgres:5432/ai_skincare",
        ),
        db_pool_min_size=_to_int(os.getenv("AI_SERVICE_DB_POOL_MIN_SIZE"), 1),
        db_pool_max_size=_to_int(os.getenv("AI_SERVICE_DB_POOL_MAX_SIZE"), 5),
        db_statement_timeout_ms=_to_int(
            os.getenv("AI_SERVICE_DB_STATEMENT_TIMEOUT_MS"), 10_000
        ),
        image_max_bytes=_to_int(os.getenv("AI_SERVICE_IMAGE_MAX_BYTES"), 4 * 1024 * 1024),
        image_max_width=_to_int(os.getenv("AI_SERVICE_IMAGE_MAX_WIDTH"), 4096),
        image_max_height=_to_int(os.getenv("AI_SERVICE_IMAGE_MAX_HEIGHT"), 4096),
        cache_ttl_seconds=_to_int(os.getenv("AI_SERVICE_CACHE_TTL_SECONDS"), 15 * 60),
        max_concurrent_analyses=_to_int(os.getenv("AI_SERVICE_MAX_CONCURRENT"), 4),
        gemini_retry_attempts=_to_int(os.getenv("GEMINI_RETRY_ATTEMPTS"), 3),
        gemini_retry_initial_delay=_to_float(os.getenv("GEMINI_RETRY_INITIAL_DELAY"), 1.0),
        gemini_retry_backoff=_to_float(os.getenv("GEMINI_RETRY_BACKOFF"), 2.0),
        scan_endpoint=os.getenv("AI_SERVICE_SCAN_ENDPOINT"),
        scan_timeout_seconds=_to_float(os.getenv("AI_SERVICE_SCAN_TIMEOUT_SECONDS"), 10.0),
        rate_limit_per_user=_to_int(os.getenv("AI_SERVICE_RATE_LIMIT_PER_USER"), 5),
        rate_limit_per_ip=_to_int(os.getenv("AI_SERVICE_RATE_LIMIT_PER_IP"), 15),
        rate_limit_window_seconds=_to_int(
            os.getenv("AI_SERVICE_RATE_LIMIT_WINDOW_SECONDS"), 60
        ),
        analysis_retention_days=_to_int(os.getenv("AI_SERVICE_RETENTION_DAYS"), 180),
        analysis_retention_batch_size=_to_int(
            os.getenv("AI_SERVICE_RETENTION_BATCH_SIZE"), 200
        ),
        gemini_allowed_models=_to_list(os.getenv("GEMINI_ALLOWED_MODELS")) or (os.getenv("GEMINI_MODEL_NAME", "gemini-1.5-flash-latest"),),
        gemini_compare_models=_to_list(os.getenv("GEMINI_COMPARE_MODELS")),
        default_detail_level=os.getenv("ANALYSIS_DEFAULT_DETAIL_LEVEL", "medium"),
        analysis_slow_threshold_ms=_to_int(
            os.getenv("ANALYSIS_SLOW_THRESHOLD_MS"), 8000
        ),
        analysis_event_webhook=os.getenv("ANALYSIS_EVENT_WEBHOOK"),
        analysis_event_timeout_seconds=_to_float(
            os.getenv("ANALYSIS_EVENT_TIMEOUT_SECONDS"), 5.0
        ),
        google_api_key_file=os.getenv("GOOGLE_AI_STUDIO_API_KEY_FILE"),
        google_api_key_refresh_seconds=_to_int(
            os.getenv("GOOGLE_AI_API_KEY_REFRESH_SECONDS"), 300
        ),
    )


__all__ = ["Settings", "get_settings"]
