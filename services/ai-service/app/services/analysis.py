"""Gemini-backed analysis service."""

from __future__ import annotations

import asyncio
import base64
import hashlib
import json
import logging
from datetime import datetime, timezone, timedelta
from time import perf_counter
from typing import Any, Dict, List, Optional, Tuple
from uuid import uuid4

import asyncpg
import google.generativeai as genai
from google.api_core import exceptions as google_exceptions
from google.generativeai import types as genai_types
import httpx

from app.config import Settings
from app.repositories import AnalysisFilters, AnalysisRepository
from app.schemas import AnalysisRecord, AnalysisRequest, AnalysisResponse, AnalysisResult, AnalysisTrendResponse
from app.services.cache import AnalysisCache
from app.services.security import (
    ImageValidationError,
    scan_image_remote,
    validate_image_dimensions,
)
from app.services.key_provider import ApiKeyProvider
from app.services.preprocess import preprocess_image
from app.services.metrics import (
    record_completion,
    record_duration,
    record_error,
    record_resources,
)


logger = logging.getLogger(__name__)


ANALYSIS_SCHEMA: Dict[str, Any] = {
    "type": "object",
    "properties": {
        "summary": {"type": "string"},
        "skin_profile": {
            "type": "object",
            "properties": {
                "skin_type": {"type": "string"},
                "hydration": {"type": "string"},
                "oiliness": {"type": "string"},
                "sensitivity": {"type": "string"},
                "texture": {"type": "string"},
            },
            "required": [
                "skin_type",
                "hydration",
                "oiliness",
                "sensitivity",
                "texture",
            ],
        },
        "concern_assessment": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "concern": {"type": "string"},
                    "severity": {
                        "type": "string",
                        "enum": ["low", "moderate", "high", "severe"],
                    },
                    "confidence": {"type": "number"},
                    "summary": {"type": "string"},
                },
                "required": ["concern", "severity", "confidence", "summary"],
            },
        },
        "care_plan": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "step": {"type": "string"},
                    "goal": {"type": "string"},
                    "instructions": {"type": "string"},
                    "suggested_ingredients": {
                        "type": "array",
                        "items": {"type": "string"},
                    },
                },
                "required": ["step", "goal", "instructions"],
            },
        },
        "product_suggestions": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "product_id": {"type": ["string", "null"]},
                    "category": {"type": "string"},
                    "recommendation_reason": {"type": "string"},
                },
                "required": ["category", "recommendation_reason"],
            },
        },
        "lifestyle_tips": {"type": "array", "items": {"type": "string"}},
        "recommendation_hints": {
            "type": "object",
            "properties": {
                "product_ids": {"type": "array", "items": {"type": "string"}},
                "tags": {"type": "array", "items": {"type": "string"}},
            },
        },
    },
    "required": [
        "summary",
        "skin_profile",
        "concern_assessment",
        "care_plan",
        "product_suggestions",
        "lifestyle_tips",
        "recommendation_hints",
    ],
}


class AnalysisError(Exception):
    """Base exception for analysis failures."""


class MissingApiKeyError(AnalysisError):
    """Raised when the Gemini API key is missing."""


class InvalidImageError(AnalysisError):
    """Raised when uploaded imagery does not meet validation criteria."""


class UserNotFoundError(AnalysisError):
    """Raised when associated user cannot be found in persistence layer."""


class GeminiAnalysisService:
    """Service orchestrating Gemini requests and result persistence."""

    _ALLOWED_MIME_TYPES = {"image/jpeg", "image/png"}

    def __init__(self, settings: Settings, repository: AnalysisRepository) -> None:
        self._settings = settings
        self._repository = repository
        self._cache = AnalysisCache(settings.cache_ttl_seconds)
        self._semaphore = asyncio.Semaphore(max(1, settings.max_concurrent_analyses))
        self._key_provider = ApiKeyProvider(
            settings.google_api_key,
            file_path=settings.google_api_key_file,
            refresh_interval_seconds=settings.google_api_key_refresh_seconds,
        )
        self._model_registry: Dict[str, Tuple[str, genai.GenerativeModel]] = {}
        self._allowed_models = set(settings.gemini_allowed_models)
        if settings.gemini_model not in self._allowed_models:
            self._allowed_models.add(settings.gemini_model)
        self._compare_models = tuple(
            model for model in settings.gemini_compare_models if model in self._allowed_models
        )
        self._default_model = settings.gemini_model
        self._system_instruction = (
            "You are a board-certified dermatologist assistant. Analyse the provided "
            "facial skin imagery and contextual notes to produce a structured report. "
            "Use concise language suitable for end users without jargon and follow the "
            "response schema exactly. Never include markdown or additional commentary."
        )

    async def run_analysis(self, payload: AnalysisRequest) -> AnalysisResponse:
        snapshot = self._key_provider.ensure_latest()
        if not snapshot.value:
            raise MissingApiKeyError(
                "Gemini API key is not configured. Set GOOGLE_AI_STUDIO_API_KEY or provide a key file."
            )

        try:
            await self._repository.ensure_user_exists(payload.user_id)
        except LookupError as exc:
            record_error("user_not_found")
            raise UserNotFoundError("Associated user does not exist or is inactive") from exc

        cache_key = self._make_cache_key(payload)
        cached = self._cache.get(cache_key)
        if cached:
            record_completion(cached.model)
            return AnalysisResponse(cached)

        model_name, comparison_models, fallback_models = self._select_models(payload)
        await self._ensure_model(model_name, snapshot)
        prompt_parts, image_source = await self._build_prompt_parts(payload)

        async with self._semaphore:
            cached = self._cache.get(cache_key)
            if cached:
                record_completion(cached.model)
                return AnalysisResponse(cached)

            try:
                record = await self._perform_analysis(
                    payload=payload,
                    model_name=model_name,
                    prompt_parts=prompt_parts,
                    image_source=image_source,
                    api_key_snapshot=snapshot,
                    comparison_models=comparison_models,
                    fallback_models=fallback_models,
                )
            except InvalidImageError:
                record_error("invalid_image")
                raise
            except AnalysisError:
                record_error("analysis_error")
                raise

            self._cache.set(cache_key, record)
            record_completion(record.model)
            return AnalysisResponse(record)

    async def fetch_analysis(self, analysis_id: str) -> Optional[AnalysisResponse]:
        record = await self._repository.get(analysis_id)
        if not record:
            return None
        return AnalysisResponse(record)

    async def list_for_user(
        self,
        user_id: str,
        *,
        limit: int,
        offset: int,
        filters: AnalysisFilters,
    ) -> List[AnalysisRecord]:
        return await self._repository.list_for_user(
            user_id, limit=limit, offset=offset, filters=filters
        )

    async def list_trends(
        self, user_id: str, *, window_days: int
    ) -> AnalysisTrendResponse:
        items = await self._repository.fetch_trends(user_id, window_days=window_days)
        return AnalysisTrendResponse(
            user_id=user_id,
            window_days=window_days,
            items=items,
        )

    async def _ensure_model(
        self, model_name: str, snapshot: "KeySnapshot"
    ) -> genai.GenerativeModel:
        cached = self._model_registry.get(model_name)
        key_id = snapshot.value
        if cached and cached[0] == key_id:
            return cached[1]

        genai.configure(api_key=key_id)
        generation_config = genai_types.GenerationConfig(
            temperature=self._settings.temperature,
            top_p=self._settings.top_p,
            top_k=self._settings.top_k,
            max_output_tokens=self._settings.max_output_tokens,
            response_mime_type="application/json",
        )
        if self._settings.enable_schema:
            generation_config.response_schema = ANALYSIS_SCHEMA

        model = genai.GenerativeModel(
            model_name=model_name,
            generation_config=generation_config,
            system_instruction=self._system_instruction,
        )
        self._model_registry[model_name] = (key_id, model)
        return model

    def _select_models(self, payload: AnalysisRequest) -> Tuple[str, Tuple[str, ...]]:
        preferred = payload.model_preference or self._default_model
        model_name = preferred if preferred in self._allowed_models else self._default_model
        comparison: Tuple[str, ...] = ()
        if payload.compare_models and self._compare_models:
            comparison = tuple(
                model for model in self._compare_models if model != model_name
            )
        return model_name, comparison

    async def _perform_analysis(
        self,
        *,
        payload: AnalysisRequest,
        model_name: str,
        prompt_parts: List[Dict[str, Any] | str],
        image_source: str,
        api_key_snapshot: "KeySnapshot",
        comparison_models: Tuple[str, ...],
    ) -> AnalysisRecord:
        started = perf_counter()
        model = await self._ensure_model(model_name, api_key_snapshot)
        response = await self._generate_content(model, prompt_parts)
        duration_seconds = perf_counter() - started
        duration_ms = int(duration_seconds * 1000)
        record_duration(model_name, cached=False, seconds=duration_seconds)

        data = self._parse_response(response)
        result = AnalysisResult.model_validate(data)
        self._validate_result_quality(result)

        record = AnalysisRecord(
            analysis_id=str(uuid4()),
            user_id=payload.user_id,
            model=model_name,
            created_at=datetime.now(timezone.utc),
            locale=payload.locale,
            data=result,
        )

        analysis_dump = result.model_dump(mode="json")
        confidence = self._aggregate_confidence(result)
        severity = self._derive_severity(result)
        concerns = self._collect_concerns(result)
        recommendations = {
            "care_plan": analysis_dump.get("care_plan"),
            "product_suggestions": analysis_dump.get("product_suggestions"),
            "lifestyle_tips": analysis_dump.get("lifestyle_tips"),
            "recommendation_hints": analysis_dump.get("recommendation_hints"),
        }
        quality_score = self._compute_quality_score(result, confidence, severity)

        metadata: Dict[str, Any] = {
            "locale": payload.locale,
            "notes": payload.notes,
            "submitted_concerns": payload.concerns or [],
            "skin_type_hint": payload.skin_type_hint,
            "image_source": image_source,
            "detail_level": payload.detail_level,
            "quality_score": quality_score,
            "processing_time_ms": duration_ms,
            "confidence_score": confidence,
        }

        if payload.image_urls:
            metadata["image_urls"] = payload.image_urls
        if payload.video_url:
            metadata["video_url"] = str(payload.video_url)

        if comparison_models:
            metadata["comparison"] = []
            for compare_model in comparison_models:
                await self._ensure_model(compare_model, api_key_snapshot)
                try:
                    compare_response = await self._generate_content(
                        self._model_registry[compare_model][1], prompt_parts
                    )
                    compare_data = self._parse_response(compare_response)
                    metadata["comparison"].append(
                        {
                            "model": compare_model,
                            "result": compare_data,
                        }
                    )
                except AnalysisError as exc:
                    metadata.setdefault("comparison_errors", []).append(
                        {"model": compare_model, "error": str(exc)}
                    )

        try:
            await self._repository.insert(
                record,
                image_url=payload.image_url or f"inline://{record.analysis_id}",
                confidence_score=confidence,
                severity_level=severity,
                skin_concerns=concerns,
                recommendations=recommendations,
                metadata=metadata,
                processing_time_ms=duration_ms,
            )
        except asyncpg.ForeignKeyViolationError as exc:
            record_error("user_not_found")
            raise UserNotFoundError("Associated user does not exist") from exc

        await self._cleanup_old_records(payload.user_id)
        await self._dispatch_event(record, metadata)
        record_resources()
        self._maybe_log_slow(duration_ms, model_name, payload.user_id)
        return record

    async def _generate_content(
        self, model: genai.GenerativeModel, prompt_parts: List[Dict[str, Any] | str]
    ) -> genai_types.GenerateContentResponse:
        attempts = max(1, self._settings.gemini_retry_attempts)
        delay = max(0.1, self._settings.gemini_retry_initial_delay)
        for attempt in range(1, attempts + 1):
            try:
                return await asyncio.to_thread(model.generate_content, prompt_parts)
            except google_exceptions.GoogleAPIError as exc:
                if attempt == attempts:
                    record_error("gemini_api_error")
                    logger.error(
                        "Gemini API error after %s attempts: %s", attempt, exc, exc_info=True
                    )
                    raise AnalysisError("Gemini API error") from exc
                await asyncio.sleep(delay)
                delay *= max(1.0, self._settings.gemini_retry_backoff)
            except Exception as exc:  # pragma: no cover
                if attempt == attempts:
                    record_error("gemini_unexpected_error")
                    logger.exception("Unexpected error while calling Gemini")
                    raise AnalysisError("Unexpected error during analysis") from exc
                await asyncio.sleep(delay)
                delay *= max(1.0, self._settings.gemini_retry_backoff)
        raise AnalysisError("Failed to generate content after retries")

    async def _build_prompt_parts(
        self, payload: AnalysisRequest
    ) -> tuple[List[Dict[str, Any] | str], str]:
        parts: List[Dict[str, Any] | str] = []
        image_source = "none"

        if payload.image_base64:
            image_bytes, mime_type = await self._process_inline_image(
                payload.image_base64, payload.image_mime_type
            )
            parts.append({"mime_type": mime_type, "data": image_bytes})
            image_source = "inline"
        elif payload.image_url:
            image_bytes, mime_type = await self._download_image(str(payload.image_url))
            parts.append({"mime_type": mime_type, "data": image_bytes})
            image_source = "url"

        if payload.image_urls:
            for extra_url in payload.image_urls[:3]:
                try:
                    extra_bytes, extra_mime = await self._download_image(str(extra_url))
                    parts.append({"mime_type": extra_mime, "data": extra_bytes})
                except InvalidImageError as exc:
                    logger.warning("Skipping supplemental image %s: %s", extra_url, exc)

        bullet_points: List[str] = []
        if payload.notes:
            bullet_points.append(f"Additional observations: {payload.notes}")
        if payload.concerns:
            bullet_points.append(
                "Prioritise the following concerns: "
                + ", ".join(sorted(payload.concerns))
            )
        if payload.skin_type_hint:
            bullet_points.append(f"Known skin type hint: {payload.skin_type_hint}")
        if payload.image_urls:
            bullet_points.append(
                f"{len(payload.image_urls[:3])} supplemental reference images provided."
            )
        if payload.video_url:
            bullet_points.append(
                f"Consider motion/video context from: {payload.video_url} (use for temporal notes)."
            )
        bullet_points.append(f"Respond in locale: {payload.locale}")
        bullet_points.append(f"Detail level: {payload.detail_level}")

        guidance = (
            "Generate a comprehensive skin analysis for the submitted user. "
            "Highlight the most important findings, prioritise actionable care "
            "steps, and maintain empathetic tone."
        )

        if payload.detail_level == "low":
            guidance += " Provide a concise summary with 3 actionable steps."
        elif payload.detail_level == "high":
            guidance += " Provide an in-depth report with nuanced ingredient insights and lifestyle adjustments."

        prompt_text = guidance
        if bullet_points:
            prompt_text += "\nContext:\n- " + "\n- ".join(bullet_points)

        parts.append(prompt_text)
        return [{"role": "user", "parts": parts}], image_source

    async def _process_inline_image(
        self, base64_data: str, mime_hint: Optional[str]
    ) -> tuple[bytes, str]:
        try:
            image_bytes = base64.b64decode(base64_data, validate=True)
        except (ValueError, TypeError) as exc:
            raise InvalidImageError("image_base64 is not valid base64 data") from exc

        if len(image_bytes) > self._settings.image_max_bytes:
            raise InvalidImageError("Image payload exceeds maximum allowed size")

        mime_type = (mime_hint or "image/jpeg").lower()
        self._validate_mime_type(mime_type)
        self._validate_image_bytes(image_bytes)
        await self._scan_image(image_bytes, mime_type)
        optimised = self._optimise_image(image_bytes)
        return optimised, "image/jpeg"

    async def _download_image(self, url: str) -> tuple[bytes, str]:
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(url)
                response.raise_for_status()
        except httpx.HTTPError as exc:
            logger.warning("Failed to download image from %s: %s", url, exc)
            raise InvalidImageError("Unable to download image from provided URL") from exc

        mime_type = (response.headers.get("Content-Type") or "image/jpeg").split(";")[0].strip().lower()
        self._validate_mime_type(mime_type)

        data = response.content
        if len(data) > self._settings.image_max_bytes:
            raise InvalidImageError("Downloaded image exceeds maximum allowed size")

        self._validate_image_bytes(data)
        await self._scan_image(data, mime_type)
        optimised = self._optimise_image(data)
        return optimised, "image/jpeg"

    @staticmethod
    def _parse_response(response: genai_types.GenerateContentResponse) -> Dict[str, Any]:
        raw_payload: Optional[str] = None

        if hasattr(response, "text") and response.text:
            raw_payload = response.text
        else:
            for candidate in getattr(response, "candidates", []) or []:
                for part in getattr(candidate.content, "parts", []) or []:
                    text = getattr(part, "text", None)
                    if text:
                        raw_payload = text
                        break
                if raw_payload:
                    break

        if not raw_payload:
            raise AnalysisError("Gemini response did not contain text output")

        cleaned = raw_payload.strip()
        if cleaned.startswith("```"):
            cleaned = cleaned.strip("`")
            cleaned = cleaned.replace("json", "", 1).strip()

        try:
            return json.loads(cleaned)
        except json.JSONDecodeError as exc:
            logger.error("Failed to decode Gemini JSON response: %s", cleaned)
            raise AnalysisError("Unable to parse Gemini response as JSON") from exc

    @staticmethod
    def _aggregate_confidence(result: AnalysisResult) -> Optional[float]:
        values = [
            insight.confidence
            for insight in result.concern_assessment
            if insight.confidence is not None
        ]
        if not values:
            return None
        average = sum(values) / len(values)
        return round(average, 4)

    @staticmethod
    def _derive_severity(result: AnalysisResult) -> Optional[str]:
        order = {"low": 0, "moderate": 1, "high": 2, "severe": 3}
        mapping = {0: "mild", 1: "moderate", 2: "severe", 3: "critical"}
        levels = [
            order.get(insight.severity, -1) for insight in result.concern_assessment
        ]
        levels = [value for value in levels if value >= 0]
        if not levels:
            return None
        highest = max(levels)
        return mapping.get(highest)

    @staticmethod
    def _collect_concerns(result: AnalysisResult) -> List[str]:
        return [
            insight.concern
            for insight in result.concern_assessment
            if insight.concern
        ]

    def _validate_mime_type(self, mime: str) -> None:
        if mime not in self._ALLOWED_MIME_TYPES:
            raise InvalidImageError("Unsupported image MIME type")

    def _make_cache_key(self, payload: AnalysisRequest) -> str:
        parts: List[str] = [
            payload.user_id,
            payload.locale,
            payload.notes or '',
            ','.join(sorted(payload.concerns or [])),
            payload.skin_type_hint or '',
            payload.model_preference or self._default_model,
            ','.join(payload.fallback_models or []),
            payload.detail_level,
            str(payload.compare_models),
        ]
        if payload.image_url:
            parts.append(f"url:{payload.image_url}")
        elif payload.image_base64:
            digest = hashlib.sha256(payload.image_base64.encode('utf-8')).hexdigest()
            parts.append(f"inline:{digest}")
        if payload.image_urls:
            parts.append('urls:' + ','.join(sorted(str(url) for url in payload.image_urls[:3])))
        if payload.video_url:
            parts.append(f"video:{payload.video_url}")
        return '|'.join(parts)

    def _optimise_image(self, data: bytes) -> bytes:
        try:
            return preprocess_image(
                data,
                max_width=self._settings.image_max_width,
                max_height=self._settings.image_max_height,
            )
        except ValueError:
            return data

    async def _cleanup_old_records(self, user_id: str) -> None:
        if self._settings.analysis_retention_days <= 0:
            return
        cutoff = datetime.now(timezone.utc) - timedelta(days=self._settings.analysis_retention_days)
        removed = await self._repository.prune_before(
            user_id,
            cutoff,
            batch_size=self._settings.analysis_retention_batch_size,
        )
        if removed:
            logger.debug('Pruned %s historical analyses for user %s', removed, user_id)

    async def _dispatch_event(self, record: AnalysisRecord, metadata: Dict[str, Any]) -> None:
        if not self._settings.analysis_event_webhook:
            return

        payload = {
            'analysis_id': record.analysis_id,
            'user_id': record.user_id,
            'model': record.model,
            'created_at': record.created_at.isoformat(),
            'quality_score': metadata.get('quality_score'),
            'severity': self._derive_severity(record.data),
        }

        async def _send() -> None:
            try:
                async with httpx.AsyncClient(timeout=self._settings.analysis_event_timeout_seconds) as client:
                    await client.post(self._settings.analysis_event_webhook, json=payload)
            except httpx.HTTPError as exc:
                logger.warning('Failed to dispatch analysis event: %s', exc)

        asyncio.create_task(_send())

    def _validate_result_quality(self, result: AnalysisResult) -> None:
        if not result.summary or not result.summary.strip():
            record_error('quality_missing_summary')
            raise AnalysisError('Analysis summary is empty')
        if not result.concern_assessment:
            record_error('quality_missing_concerns')
            raise AnalysisError('Analysis concerns are missing')
        for insight in result.concern_assessment:
            if insight.confidence is None:
                record_error('quality_missing_confidence')
                raise AnalysisError('Insight confidence values missing')

    def _compute_quality_score(
        self,
        result: AnalysisResult,
        confidence: Optional[float],
        severity: Optional[str],
    ) -> float:
        base = confidence or 0.6
        adjustment = 0.0
        if severity in {'severe', 'critical'}:
            adjustment += 0.05
        if len(result.concern_assessment) > 1:
            adjustment += 0.05
        return round(min(1.0, base + adjustment), 4)

    def _maybe_log_slow(self, duration_ms: int, model_name: str, user_id: str) -> None:
        if duration_ms > self._settings.analysis_slow_threshold_ms:
            logger.warning(
                'Slow analysis detected (model=%s, user=%s, duration_ms=%s)',
                model_name,
                user_id,
                duration_ms,
            )
    def _validate_image_bytes(self, data: bytes) -> None:
        try:
            validate_image_dimensions(
                data,
                max_width=self._settings.image_max_width,
                max_height=self._settings.image_max_height,
            )
        except ImageValidationError as exc:
            raise InvalidImageError(str(exc)) from exc

    async def _scan_image(self, data: bytes, mime_type: str) -> None:
        if not self._settings.scan_endpoint:
            return

        encoded = base64.b64encode(data).decode("ascii")
        try:
            await scan_image_remote(
                endpoint=self._settings.scan_endpoint,
                data_base64=encoded,
                mime_type=mime_type,
                timeout_seconds=self._settings.scan_timeout_seconds,
            )
        except ImageValidationError as exc:
            raise InvalidImageError(str(exc)) from exc





