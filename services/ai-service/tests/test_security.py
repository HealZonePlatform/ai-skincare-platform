import asyncio
import base64
from io import BytesIO

from PIL import Image

from app.services.security import (
    ImageValidationError,
    validate_image_dimensions,
    scan_image_remote,
)


def _encode_image(width: int = 256, height: int = 256) -> bytes:
    image = Image.new("RGB", (width, height), color=(200, 150, 120))
    buffer = BytesIO()
    image.save(buffer, format="JPEG")
    return buffer.getvalue()


def test_validate_image_dimensions_accepts_valid_payload() -> None:
    data = _encode_image(512, 512)
    validate_image_dimensions(data, max_width=1024, max_height=1024)


def test_validate_image_dimensions_rejects_large_images() -> None:
    data = _encode_image(5000, 5000)
    try:
        validate_image_dimensions(data, max_width=2048, max_height=2048)
    except ImageValidationError:
        pass
    else:
        raise AssertionError("Expected validation error for oversize image")


async def _scan_image_clean() -> None:
    async def handler(request):
        class Response:
            status_code = 200

            @staticmethod
            def json():
                return {"clean": True}

            def raise_for_status(self):
                return None

        return Response()

    class FakeClient:
        def __init__(self, *args, **kwargs):
            pass

        async def __aenter__(self):
            return self

        async def __aexit__(self, exc_type, exc, tb):
            return False

        async def post(self, *_args, **_kwargs):
            return await handler(None)

    original = __import__("httpx").AsyncClient
    httpx = __import__("httpx")
    httpx.AsyncClient = FakeClient  # type: ignore[attr-defined]
    try:
        await scan_image_remote(
            endpoint="https://scanner.local/scan",
            data_base64=base64.b64encode(_encode_image()).decode("ascii"),
            mime_type="image/jpeg",
            timeout_seconds=5.0,
        )
    finally:
        httpx.AsyncClient = original  # type: ignore[attr-defined]


def test_scan_image_remote_accepts_clean_response() -> None:
    asyncio.run(_scan_image_clean())
