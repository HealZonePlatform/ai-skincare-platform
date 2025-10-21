"""Helpers for validating and scanning image payloads."""

from __future__ import annotations

from io import BytesIO
from typing import Optional

import httpx
from PIL import Image, UnidentifiedImageError


class ImageValidationError(ValueError):
    """Raised when an image fails validation or scanning."""


def validate_image_dimensions(
    data: bytes, *, max_width: int, max_height: int
) -> None:
    """Ensure the image bytes decode and respect configured dimensions."""
    try:
        with Image.open(BytesIO(data)) as image:
            image.verify()
            width, height = image.size
    except (UnidentifiedImageError, OSError) as exc:
        raise ImageValidationError("Unable to decode image content") from exc

    if width > max_width or height > max_height:
        raise ImageValidationError("Image dimensions exceed allowed limits")


async def scan_image_remote(
    *,
    endpoint: str,
    data_base64: str,
    mime_type: str,
    timeout_seconds: float,
) -> None:
    """Send image bytes to a remote malware scanning endpoint."""
    payload = {"content": data_base64, "mime_type": mime_type}

    try:
        async with httpx.AsyncClient(timeout=timeout_seconds) as client:
            response = await client.post(endpoint, json=payload)
            response.raise_for_status()
    except httpx.HTTPError as exc:
        raise ImageValidationError("Unable to verify image safety") from exc

    body = response.json()
    if not body.get("clean", False):
        raise ImageValidationError("Image flagged by malware scanner")
