"""Runtime configuration helpers for the recommendation service."""

from __future__ import annotations

import os
from dataclasses import dataclass
from functools import lru_cache
from typing import Optional


def _parse_int(value: Optional[str], default: int) -> int:
    """Best-effort conversion of string values to integers."""
    if value is None:
        return default
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _parse_float(value: Optional[str], default: float) -> float:
    """Best-effort conversion of string values to floats."""
    if value is None:
        return default
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


@dataclass(frozen=True)
class Settings:
    """Immutable configuration container."""

    product_service_url: str
    ai_service_url: str
    recommendation_limit: int
    http_timeout_seconds: float


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return cached settings built from environment variables."""
    return Settings(
        product_service_url=os.getenv(
            "PRODUCT_SERVICE_URL", "http://product-service:3003"
        ),
        ai_service_url=os.getenv("AI_SERVICE_URL", "http://ai-service:3006"),
        recommendation_limit=_parse_int(os.getenv("RECOMMENDATION_LIMIT"), 5),
        http_timeout_seconds=_parse_float(os.getenv("HTTP_TIMEOUT_SECONDS"), 5.0),
    )


__all__ = ["Settings", "get_settings"]
