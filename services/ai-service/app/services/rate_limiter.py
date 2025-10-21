"""Simple in-memory rate limiter for analysis requests."""

from __future__ import annotations

import time
from collections import defaultdict, deque
from typing import Deque, Dict, Optional


class RateLimiter:
    """Token bucket style limiter keyed by user and IP."""

    def __init__(
        self,
        *,
        per_user: int,
        per_ip: int,
        window_seconds: int,
    ) -> None:
        self._per_user = max(1, per_user)
        self._per_ip = max(1, per_ip)
        self._window = max(1, window_seconds)
        self._user_buckets: Dict[str, Deque[float]] = defaultdict(deque)
        self._ip_buckets: Dict[str, Deque[float]] = defaultdict(deque)

    def allow(self, *, user_id: str, ip: Optional[str]) -> bool:
        """Return True when the caller is within rate limits."""
        now = time.monotonic()
        cutoff = now - self._window

        user_bucket = self._user_buckets[user_id]
        self._prune(user_bucket, cutoff)
        if len(user_bucket) >= self._per_user:
            return False

        if ip:
            ip_bucket = self._ip_buckets[ip]
            self._prune(ip_bucket, cutoff)
            if len(ip_bucket) >= self._per_ip:
                return False
            ip_bucket.append(now)

        user_bucket.append(now)
        return True

    @staticmethod
    def _prune(bucket: Deque[float], cutoff: float) -> None:
        while bucket and bucket[0] < cutoff:
            bucket.popleft()
