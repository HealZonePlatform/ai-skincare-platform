"""Domain logic for generating product recommendations."""

from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Optional, Sequence, Set, Tuple

import httpx

from app.config import Settings
from app.schemas import RecommendationItem, RecommendationRequest

logger = logging.getLogger(__name__)

_DEFAULT_FETCH_MULTIPLIER = 4
_MAX_FETCH_LIMIT = 60


def _normalise(value: str) -> str:
    return value.strip().lower()


def _coerce_product_id(product: Dict[str, Any]) -> Optional[str]:
    """Extract a stable product identifier from product-service payloads."""
    candidate = product.get("id") or product.get("_id")
    if isinstance(candidate, dict):
        # Handle MongoDB extended JSON payloads ({"$oid": "..."}).
        oid = candidate.get("$oid")
        return str(oid) if oid else None
    if candidate is not None:
        return str(candidate)
    return None


def _collect_product_tokens(product: Dict[str, Any]) -> List[str]:
    """Gather text tokens that represent the product taxonomy."""
    tokens: List[str] = []
    for key in ("tags", "skinConcerns", "skinTypes", "certifications"):
        values = product.get(key, [])
        if isinstance(values, list):
            tokens.extend(str(item) for item in values if isinstance(item, (str, int)))
    for key in ("category", "subCategory", "brand"):
        value = product.get(key)
        if isinstance(value, (str, int)):
            tokens.append(str(value))
    return [_normalise(token) for token in tokens]


def _safe_rating(product: Dict[str, Any]) -> Optional[float]:
    ratings = product.get("ratings")
    if isinstance(ratings, dict):
        average = ratings.get("average")
        if isinstance(average, (int, float)):
            return float(average)
    return None


@dataclass
class RecommendationService:
    """Facade around downstream services to build personalised recommendations."""

    client: httpx.AsyncClient
    settings: Settings

    async def get_recommendations(
        self, request: RecommendationRequest
    ) -> List[RecommendationItem]:
        """
        Derive recommendations for the given user/request context.

        Network failures will be logged and result in a graceful empty list.
        """
        limit = self._resolve_limit(request.limit)
        preferences = self._normalise_preferences(request.preferences)

        products = await self._fetch_products(limit, preferences)
        if not products:
            logger.info("No products retrieved from product-service; returning empty list.")
            return []

        boosted_ids: Set[str] = set()
        if request.analysis_id:
            ai_result = await self._fetch_analysis(request.analysis_id)
            if ai_result:
                boosted_ids = self._extract_boosted_ids(ai_result)

        return self._rank_products(products, preferences, limit, boosted_ids)

    async def _fetch_products(
        self, limit: int, preferences: Sequence[str]
    ) -> List[Dict[str, Any]]:
        """Retrieve products from product-service."""
        fetch_limit = min(max(limit * _DEFAULT_FETCH_MULTIPLIER, 10), _MAX_FETCH_LIMIT)
        params = {
            "limit": str(fetch_limit),
            "offset": "0",
            "isActive": "true",
        }
        # Send preferences as tags hint if available (best-effort filter server side)
        if preferences:
            params["tags"] = ",".join(preferences)

        url = f"{self.settings.product_service_url.rstrip('/')}/api/v1/products"
        try:
            response = await self.client.get(url, params=params)
            response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            logger.warning(
                "Product service returned %s while fetching recommendations: %s",
                exc.response.status_code,
                exc,
            )
            return []
        except httpx.HTTPError as exc:
            logger.warning("Failed to reach product service: %s", exc)
            return []

        try:
            payload = response.json()
        except ValueError:
            logger.warning("Product service returned invalid JSON payload.")
            return []

        data = payload.get("data")
        if isinstance(data, list):
            return data

        logger.warning("Unexpected response shape from product service: %s", payload)
        return []

    async def _fetch_analysis(self, analysis_id: str) -> Optional[Dict[str, Any]]:
        """Retrieve an analysis snapshot from the AI service."""
        url = f"{self.settings.ai_service_url.rstrip('/')}/api/v1/analysis/{analysis_id}"
        try:
            response = await self.client.get(url)
            response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            if exc.response.status_code == 404:
                logger.info("Analysis %s not found in AI service.", analysis_id)
            else:
                logger.warning(
                    "AI service returned %s fetching analysis %s: %s",
                    exc.response.status_code,
                    analysis_id,
                    exc,
                )
            return None
        except httpx.HTTPError as exc:
            logger.warning("Failed to reach AI service for analysis %s: %s", analysis_id, exc)
            return None

        try:
            payload = response.json()
        except ValueError:
            logger.warning("AI service returned invalid JSON for analysis %s.", analysis_id)
            return None

        data = payload.get("data")
        return data if isinstance(data, dict) else None

    def _extract_boosted_ids(self, analysis: Dict[str, Any]) -> Set[str]:
        """Extract product identifiers explicitly recommended by the AI service."""

        boosted: Set[str] = set()
        stack: List[Any] = [analysis]

        while stack:
            current = stack.pop()
            if isinstance(current, dict):
                for key, value in current.items():
                    lower_key = key.lower()
                    if "product" in lower_key and isinstance(value, list):
                        boosted.update(self._extract_ids_from_list(value))
                    elif isinstance(value, dict):
                        stack.append(value)
                    elif isinstance(value, list):
                        stack.append(value)
            elif isinstance(current, list):
                stack.extend(item for item in current if isinstance(item, (dict, list)))

        return boosted

    @staticmethod
    def _extract_ids_from_list(values: Sequence[Any]) -> Set[str]:
        ids: Set[str] = set()
        for item in values:
            if isinstance(item, (str, int)):
                ids.add(str(item))
            elif isinstance(item, dict):
                candidate = item.get("id") or item.get("productId") or item.get("_id")
                if candidate:
                    ids.add(str(candidate))
                ids.update(
                    RecommendationService._extract_ids_from_list(
                        list(item.values())
                    )
                )
        return ids

    def _rank_products(
        self,
        products: Sequence[Dict[str, Any]],
        preferences: Sequence[str],
        limit: int,
        boosted_ids: Set[str],
    ) -> List[RecommendationItem]:
        """Rank and annotate products with reasons."""
        ranked: List[Tuple[float, RecommendationItem]] = []
        seen: set[str] = set()

        for product in products:
            product_id = _coerce_product_id(product)
            if not product_id or product_id in seen:
                continue

            matches = self._match_preferences(product, preferences)
            rating = _safe_rating(product)
            analysis_match = product_id in boosted_ids
            reasons = self._build_reasons(matches, analysis_match, product, rating)
            score = self._compute_score(matches, analysis_match, rating, product)

            ranked.append(
                (
                    score,
                    RecommendationItem(product_id=product_id, reason="; ".join(reasons)),
                )
            )
            seen.add(product_id)

        ranked.sort(key=lambda item: item[0], reverse=True)
        return [item for _, item in ranked][:limit]

    def _match_preferences(
        self, product: Dict[str, Any], preferences: Sequence[str]
    ) -> List[str]:
        if not preferences:
            return []
        product_tokens = set(_collect_product_tokens(product))
        matches = [pref for pref in preferences if pref in product_tokens]
        return matches

    @staticmethod
    def _build_reasons(
        matches: Sequence[str],
        analysis_match: bool,
        product: Dict[str, Any],
        rating: Optional[float],
    ) -> List[str]:
        reasons: List[str] = []

        if matches:
            reasons.append(f"Aligns with your preferences: {', '.join(matches)}")
        if analysis_match:
            reasons.append("Recommended by your latest analysis results")
        if product.get("isRecommended"):
            reasons.append("Curated by HealZone experts")
        if rating is not None and rating >= 4.5:
            reasons.append(f"Highly rated ({rating:.1f}/5 average)")

        if not reasons:
            reasons.append("Popular with users similar to you")

        # Remove duplicates while preserving order.
        deduped: List[str] = []
        seen: set[str] = set()
        for reason in reasons:
            if reason not in seen:
                deduped.append(reason)
                seen.add(reason)
        return deduped

    @staticmethod
    def _compute_score(
        matches: Sequence[str],
        analysis_match: bool,
        rating: Optional[float],
        product: Dict[str, Any],
    ) -> float:
        score = 0.0
        score += len(matches) * 10
        if analysis_match:
            score += 15
        if rating is not None:
            score += rating * 2
        if product.get("isRecommended"):
            score += 5
        if product.get("isActive") is False:
            score -= 10
        return score

    def _resolve_limit(self, requested: Optional[int]) -> int:
        limit = requested or self.settings.recommendation_limit
        if limit < 1:
            limit = 1
        return min(limit, 50)

    @staticmethod
    def _normalise_preferences(preferences: Optional[Iterable[str]]) -> List[str]:
        if not preferences:
            return []
        return [
            _normalise(pref)
            for pref in preferences
            if isinstance(pref, str) and _normalise(pref)
        ]
