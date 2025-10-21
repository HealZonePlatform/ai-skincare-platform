"""Pydantic models for AI analysis requests and responses."""

from __future__ import annotations

from datetime import datetime
from typing import List, Literal, Optional
from uuid import UUID

from pydantic import (
    AnyHttpUrl,
    BaseModel,
    Field,
    RootModel,
    field_validator,
    model_validator,
)


SeverityLevel = Literal["low", "moderate", "high", "severe"]


class AnalysisRequest(BaseModel):
    """Incoming payload for a skin analysis run."""

    user_id: str = Field(..., description="User identifier requesting the analysis.")
    image_base64: Optional[str] = Field(
        None,
        description=(
            "Image provided as base64-encoded string. "
            "Only JPEG and PNG payloads are supported."
        ),
    )
    image_url: Optional[AnyHttpUrl] = Field(
        None,
        description="Optional publicly reachable URL for the image to analyse.",
    )
    image_mime_type: Optional[str] = Field(
        None,
        description="Explicit MIME type for the base64 payload, defaults to image/jpeg.",
    )
    notes: Optional[str] = Field(
        None,
        description="Optional free-form notes describing observable skin conditions.",
        max_length=2_048,
    )
    concerns: Optional[List[str]] = Field(
        default=None,
        description="List of concerns (e.g. acne, dryness) to prioritise during analysis.",
    )
    skin_type_hint: Optional[str] = Field(
        None,
        description="Optional hint about the user's known skin type.",
    )
    image_urls: Optional[List[AnyHttpUrl]] = Field(
        None,
        description="Optional list of additional image URLs to enrich the analysis.",
    )
    video_url: Optional[AnyHttpUrl] = Field(
        None,
        description="Optional video URL for future multi-frame analysis support.",
    )
    model_preference: Optional[str] = Field(
        None,
        description="Preferred Gemini model identifier if allowed by configuration.",
    )
    fallback_models: Optional[List[str]] = Field(
        default=None,
        description="Optional ordered list of fallback models if the preferred model fails.",
    )
    detail_level: Literal["low", "medium", "high"] = Field(
        default="medium",
        description="Desired level of detail for the generated analysis.",
    )
    compare_models: bool = Field(
        default=False,
        description="When true, run a secondary comparison model if configured.",
    )
    locale: str = Field(
        default="en",
        description="Preferred locale for textual output (ISO language code).",
        min_length=2,
        max_length=5,
    )

    @field_validator("user_id")
    @classmethod
    def validate_user_id(cls, value: str) -> str:
        try:
            UUID(value)
        except ValueError as exc:
            raise ValueError("user_id must be a valid UUID") from exc
        return value

    @field_validator("image_urls", "fallback_models")
    @classmethod
    def validate_non_empty_sequence(
        cls, value: Optional[List[str]]
    ) -> Optional[List[str]]:
        if value is None:
            return value
        cleaned = [item for item in (v.strip() if isinstance(v, str) else v for v in value) if item]
        return cleaned or None

    @model_validator(mode="after")
    def validate_sources(self) -> "AnalysisRequest":
        if not any(
            [
                self.image_base64,
                self.image_url,
                self.image_urls,
                self.video_url,
                self.notes,
                self.concerns,
            ]
        ):
            raise ValueError(
                "Provide at least one of image_base64, image_url, image_urls, video_url, notes, or concerns"
                " to generate a meaningful analysis."
            )
        return self


class SkinProfile(BaseModel):
    skin_type: str = Field(..., description="Overall skin type classification.")
    hydration: str = Field(..., description="Hydration assessment and advice.")
    oiliness: str = Field(..., description="Sebum activity observation.")
    sensitivity: str = Field(..., description="Sensitivity concerns and triggers.")
    texture: str = Field(..., description="Texture or pore visibility assessment.")


class ConcernInsight(BaseModel):
    concern: str = Field(..., description="Human-readable name of the concern.")
    severity: SeverityLevel = Field(..., description="Relative severity level.")
    confidence: float = Field(
        ..., ge=0.0, le=1.0, description="Model confidence between 0 and 1."
    )
    summary: str = Field(..., description="Short explanation of the finding.")


class CarePlanStep(BaseModel):
    step: str = Field(..., description="Routine step (e.g. cleanse, moisturise).")
    goal: str = Field(..., description="Goal or rationale for the step.")
    instructions: str = Field(..., description="Specific instructions for execution.")
    suggested_ingredients: List[str] = Field(
        default_factory=list,
        description="Active ingredients to seek in products for this step.",
    )


class ProductSuggestion(BaseModel):
    product_id: Optional[str] = Field(
        None,
        description="Optional product identifier if cross-linked with product catalogue.",
    )
    category: str = Field(..., description="Category or product type (e.g. serum).")
    recommendation_reason: str = Field(
        ..., description="Why this product category or item is recommended."
    )


class RecommendationHints(BaseModel):
    product_ids: List[str] = Field(
        default_factory=list,
        description="Product IDs to prioritise for downstream recommendation engine.",
    )
    tags: List[str] = Field(
        default_factory=list,
        description="Tags or ingredients to inform recommendation filtering.",
    )


class AnalysisResult(BaseModel):
    summary: str = Field(..., description="High-level summary of the skin analysis.")
    skin_profile: SkinProfile
    concern_assessment: List[ConcernInsight]
    care_plan: List[CarePlanStep]
    product_suggestions: List[ProductSuggestion]
    lifestyle_tips: List[str] = Field(
        default_factory=list, description="Lifestyle or habit recommendations."
    )
    recommendation_hints: RecommendationHints = Field(
        default_factory=RecommendationHints,
        description="Structured hints for other services.",
    )


class AnalysisRecord(BaseModel):
    analysis_id: str = Field(..., description="Unique identifier for this analysis run.")
    user_id: str = Field(..., description="User identifier tied to the analysis.")
    model: str = Field(..., description="Gemini model used to generate the analysis.")
    created_at: datetime = Field(..., description="UTC timestamp of the analysis.")
    locale: str = Field(..., description="Locale used for the generated content.")
    data: AnalysisResult


class AnalysisResponse(RootModel[AnalysisRecord]):
    """Wrapper to align FastAPI response serialisation with the record payload."""

    @property
    def analysis(self) -> AnalysisRecord:
        return self.root


class AnalysisListResponse(BaseModel):
    items: List[AnalysisRecord]


class FeedbackRequest(BaseModel):
    helpful: bool = Field(..., description="Whether the response was helpful.")
    comments: Optional[str] = Field(
        None, description="Optional user feedback to refine the model output."
    )


class AnalysisTrendPoint(BaseModel):
    bucket: str = Field(..., description="ISO 8601 period bucket label, e.g. 2024-10.")
    total: int = Field(..., ge=0, description="Number of analyses within the bucket.")
    severe_cases: int = Field(
        ..., ge=0, description="Number of analyses marked severe or critical."
    )
    average_confidence: float = Field(
        ..., ge=0.0, le=1.0, description="Average confidence score in the bucket."
    )


class AnalysisTrendResponse(BaseModel):
    user_id: str = Field(..., description="User identifier for the trend summary.")
    window_days: int = Field(..., description="Range of days evaluated.")
    items: List[AnalysisTrendPoint] = Field(
        default_factory=list, description="Trend buckets ordered from newest to oldest."
    )
