from pathlib import Path
import time

from app.services.key_provider import ApiKeyProvider


def test_key_provider_reads_file(tmp_path: Path) -> None:
    key_file = tmp_path / "api.key"
    key_file.write_text("secret-key", encoding="utf-8")

    provider = ApiKeyProvider("", file_path=str(key_file), refresh_interval_seconds=1)
    snapshot = provider.ensure_latest()
    assert snapshot.value == "secret-key"

    key_file.write_text("rotated-key", encoding="utf-8")
    time.sleep(1.1)
    snapshot = provider.ensure_latest()
    assert snapshot.value == "rotated-key"


def test_key_provider_env_fallback(monkeypatch) -> None:
    monkeypatch.setenv("GOOGLE_AI_STUDIO_API_KEY", "env-secret")
    provider = ApiKeyProvider("env-secret", refresh_interval_seconds=1)
    assert provider.ensure_latest().value == "env-secret"
