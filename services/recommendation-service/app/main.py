"""FastAPI application entrypoint for the recommendation service."""

from __future__ import annotations

import logging
from contextlib import asynccontextmanager

import httpx
from fastapi import Depends, FastAPI, HTTPException, Request

from app.config import Settings, get_settings
from app.schemas import RecommendationRequest, RecommendationResponse
from app.services import RecommendationService

logger = logging.getLogger("recommendation-service")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialise and tear down shared resources."""
    settings = get_settings()
    limits = httpx.Limits(max_connections=20, max_keepalive_connections=10)
    async with httpx.AsyncClient(
        timeout=settings.http_timeout_seconds,
        limits=limits,
        headers={"User-Agent": "healzone-recommendation-service/1.0"},
    ) as client:
        app.state.http_client = client
        yield


app = FastAPI(
    title="HealZone Recommendation Service",
    version="1.0.0",
    lifespan=lifespan,
)


def get_http_client(request: Request) -> httpx.AsyncClient:
    client = getattr(request.app.state, "http_client", None)
    if client is None:
        raise RuntimeError("HTTP client has not been initialised")
    return client


def get_recommendation_service(
    client: httpx.AsyncClient = Depends(get_http_client),
    settings: Settings = Depends(get_settings),
) -> RecommendationService:
    return RecommendationService(client=client, settings=settings)


@app.get("/healthz", summary="Service health check", tags=["health"])
async def health() -> dict[str, str]:
    """Report service liveness."""
    return {"status": "ok"}


@app.post(
    "/recommend",
    response_model=RecommendationResponse,
    summary="Generate personalised recommendations",
    tags=["recommendations"],
)
async def recommend(
    payload: RecommendationRequest,
    service: RecommendationService = Depends(get_recommendation_service),
) -> RecommendationResponse:
    """Return personalised product recommendations for the current user."""
    try:
        items = await service.get_recommendations(payload)
    except HTTPException:
        raise
    except Exception as exc:  # pragma: no cover - defensive guard
        logger.exception(
            "Failed to build recommendations for user %s", payload.user_id
        )
        raise HTTPException(
            status_code=500, detail="Failed to generate recommendations"
        ) from exc

    return RecommendationResponse(data=items)
