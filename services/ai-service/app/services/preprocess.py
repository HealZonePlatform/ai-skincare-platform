"""Image preprocessing utilities for inference."""

from __future__ import annotations

from io import BytesIO

from PIL import Image, UnidentifiedImageError


def preprocess_image(
    data: bytes,
    *,
    max_width: int,
    max_height: int,
    convert_mode: str = "RGB",
    quality: int = 90,
) -> bytes:
    """Clamp size and color space to improve downstream processing."""
    try:
        with Image.open(BytesIO(data)) as image:
            if convert_mode:
                image = image.convert(convert_mode)
            width, height = image.size
            ratio = min(1.0, max_width / max(width, 1), max_height / max(height, 1))
            if ratio < 1.0:
                new_size = (int(width * ratio), int(height * ratio))
                image = image.resize(new_size, Image.Resampling.LANCZOS)

            buffer = BytesIO()
            image.save(buffer, format="JPEG", quality=quality, optimize=True)
            return buffer.getvalue()
    except (UnidentifiedImageError, OSError) as exc:
        raise ValueError("Unable to preprocess image") from exc
