"""FastAPI application exposing AI analysis endpoints."""

from __future__ import annotations

import logging
from contextlib import asynccontextmanager
from datetime import datetime
from typing import Literal, Optional

from fastapi import Depends, FastAPI, HTTPException, Query, Request, status

from app.config import get_settings
from app.db import close_pool, create_pool
from app.repositories import AnalysisFilters, AnalysisRepository
from app.schemas import (
    AnalysisListResponse,
    AnalysisRequest,
    AnalysisResponse, AnalysisTrendResponse,
    FeedbackRequest,
)
from app.services import (
    AnalysisError,
    GeminiAnalysisService,
    InvalidImageError,
    MissingApiKeyError,
    UserNotFoundError,
)
from app.services.rate_limiter import RateLimiter

logger = logging.getLogger("ai-service")

SeverityFilter = Literal["mild", "moderate", "severe", "critical"]


@asynccontextmanager
async def lifespan(app: FastAPI):
    settings = get_settings()
    pool = await create_pool(settings)
    repository = AnalysisRepository(pool)
    service = GeminiAnalysisService(settings=settings, repository=repository)
    limiter = RateLimiter(
        per_user=settings.rate_limit_per_user,
        per_ip=settings.rate_limit_per_ip,
        window_seconds=settings.rate_limit_window_seconds,
    )

    app.state.settings = settings
    app.state.db_pool = pool
    app.state.analysis_service = service
    app.state.rate_limiter = limiter

    try:
        yield
    finally:
        await close_pool(pool)


app = FastAPI(
    title="HealZone AI Service",
    version="1.0.0",
    lifespan=lifespan,
)


def get_service(request: Request) -> GeminiAnalysisService:
    service = getattr(request.app.state, "analysis_service", None)
    if service is None:
        raise RuntimeError("Analysis service is not initialised")
    return service


def get_rate_limiter(request: Request) -> RateLimiter:
    limiter = getattr(request.app.state, "rate_limiter", None)
    if limiter is None:
        raise RuntimeError("Rate limiter is not initialised")
    return limiter


@app.get("/healthz", summary="Health check", tags=["health"])
async def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post(
    "/api/v1/analysis",
    response_model=AnalysisResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["analysis"],
    summary="Run a new AI skin analysis",
)
async def create_analysis(
    payload: AnalysisRequest,
    request: Request,
    service: GeminiAnalysisService = Depends(get_service),
    limiter: RateLimiter = Depends(get_rate_limiter),
) -> AnalysisResponse:
    client_ip = request.client.host if request.client else None
    if not limiter.allow(user_id=payload.user_id, ip=client_ip):
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Analysis rate limit exceeded. Please wait before retrying.",
        )
    try:
        return await service.run_analysis(payload)
    except MissingApiKeyError as exc:
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail=str(exc))
    except InvalidImageError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc))
    except UserNotFoundError as exc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(exc))
    except AnalysisError as exc:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(exc))


@app.get(
    "/api/v1/analysis/{analysis_id}",
    response_model=AnalysisResponse,
    tags=["analysis"],
    summary="Fetch a previously generated analysis",
)
async def get_analysis(
    analysis_id: str,
    service: GeminiAnalysisService = Depends(get_service),
) -> AnalysisResponse:
    record = await service.fetch_analysis(analysis_id)
    if not record:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Analysis not found")
    return record


@app.get(
    "/api/v1/analysis",
    response_model=AnalysisListResponse,
    tags=["analysis"],
    summary="List stored analyses for a user",
)
async def list_analyses(
    user_id: str = Query(..., description="User identifier", min_length=1),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    severity: Optional[SeverityFilter] = Query(None, description="Filter by severity level"),
    model_version: Optional[str] = Query(None, min_length=1, max_length=100),
    from_date: Optional[datetime] = Query(None, description="Filter analyses created after this timestamp"),
    to_date: Optional[datetime] = Query(None, description="Filter analyses created before this timestamp"),
    service: GeminiAnalysisService = Depends(get_service),
) -> AnalysisListResponse:
    filters = AnalysisFilters(
        severity=severity,
        model_version=model_version,
        from_date=from_date,
        to_date=to_date,
    )

    items = await service.list_for_user(
        user_id, limit=limit, offset=offset, filters=filters
    )
    return AnalysisListResponse(items=items)


@app.get(
    "/api/v1/analysis/trends",
    response_model=AnalysisTrendResponse,
    tags=["analysis"],
    summary="Trend analysis metrics",
)
async def analysis_trends(
    user_id: str = Query(..., description="User identifier", min_length=1),
    window_days: int = Query(90, ge=7, le=365, description="Number of days to aggregate"),
    service: GeminiAnalysisService = Depends(get_service),
) -> AnalysisTrendResponse:
    return await service.list_trends(user_id=user_id, window_days=window_days)

@app.post(
    "/api/v1/analysis/{analysis_id}/feedback",
    status_code=status.HTTP_202_ACCEPTED,
    tags=["analysis"],
    summary="Collect feedback for a generated analysis",
)
async def submit_feedback(
    analysis_id: str,
    feedback: FeedbackRequest,
    service: GeminiAnalysisService = Depends(get_service),
) -> dict[str, str]:
    record = await service.fetch_analysis(analysis_id)
    if not record:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Analysis not found")

    logger.info(
        "Feedback received for analysis %s (helpful=%s): %s",
        analysis_id,
        feedback.helpful,
        feedback.comments,
    )
    return {"status": "accepted"}


