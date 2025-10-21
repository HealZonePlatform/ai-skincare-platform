"""Simple in-memory cache with TTL support for analysis responses."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from threading import Lock
from typing import Dict, Optional

from app.schemas import AnalysisRecord


@dataclass
class CachedItem:
    record: AnalysisRecord
    expires_at: datetime


class AnalysisCache:
    """Thread-safe TTL cache for analysis records."""

    def __init__(self, ttl_seconds: int) -> None:
        self._ttl = max(1, ttl_seconds)
        self._store: Dict[str, CachedItem] = {}
        self._lock = Lock()

    def get(self, key: str) -> Optional[AnalysisRecord]:
        now = datetime.now(timezone.utc)
        with self._lock:
            item = self._store.get(key)
            if not item:
                return None
            if item.expires_at <= now:
                self._store.pop(key, None)
                return None
            # Return a copy to avoid accidental mutation.
            return AnalysisRecord.model_validate(item.record.model_dump())

    def set(self, key: str, record: AnalysisRecord) -> None:
        expires_at = datetime.now(timezone.utc) + timedelta(seconds=self._ttl)
        with self._lock:
            self._store[key] = CachedItem(
                record=AnalysisRecord.model_validate(record.model_dump()),
                expires_at=expires_at,
            )
