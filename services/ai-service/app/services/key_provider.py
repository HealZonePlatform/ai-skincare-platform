"""Google AI Studio API key provider with optional file-based rotation."""

from __future__ import annotations

import os
import threading
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class KeySnapshot:
    value: str
    loaded_at: float
    source: str


class ApiKeyProvider:
    """Loads the Gemini API key from env or file with periodic refresh."""

    def __init__(
        self,
        env_key: str,
        *,
        file_path: Optional[str] = None,
        refresh_interval_seconds: int = 300,
    ) -> None:
        self._env_key = env_key
        self._file_path = Path(file_path) if file_path else None
        self._refresh_interval = max(30, refresh_interval_seconds)
        self._lock = threading.Lock()
        self._snapshot = self._load()

    def ensure_latest(self) -> KeySnapshot:
        with self._lock:
            now = time.monotonic()
            if now - self._snapshot.loaded_at < self._refresh_interval:
                return self._snapshot
            self._snapshot = self._load()
            return self._snapshot

    def _load(self) -> KeySnapshot:
        if self._file_path:
            try:
                value = self._file_path.read_text(encoding="utf-8").strip()
                if value:
                    return KeySnapshot(
                        value=value,
                        loaded_at=time.monotonic(),
                        source=str(self._file_path),
                    )
            except FileNotFoundError:
                pass

        if self._env_key:
            return KeySnapshot(
                value=self._env_key,
                loaded_at=time.monotonic(),
                source="env",
            )

        value = os.getenv("GOOGLE_AI_STUDIO_API_KEY", "")
        if not value:
            raise RuntimeError(
                "GOOGLE_AI_STUDIO_API_KEY is not set and no API key file is available."
            )
        return KeySnapshot(
            value=value,
            loaded_at=time.monotonic(),
            source="env",
        )
