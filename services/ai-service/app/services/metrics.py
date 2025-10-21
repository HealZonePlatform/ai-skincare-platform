"""Prometheus metrics helpers."""

from __future__ import annotations

from typing import Optional

from prometheus_client import Counter, Gauge, Histogram

try:
    import psutil  # type: ignore
except ImportError:  # pragma: no cover
    psutil = None  # type: ignore

_ANALYSIS_DURATION = Histogram(
    "ai_service_analysis_duration_seconds",
    "Latency for analysis processing",
    ["model", "cached"],
)
_ANALYSIS_ERRORS = Counter(
    "ai_service_analysis_errors_total",
    "Total analysis failures",
    ["reason"],
)
_ANALYSIS_COMPLETED = Counter(
    "ai_service_analysis_completed_total",
    "Total completed analyses",
    ["model"],
)
_RESOURCE_MEMORY = Gauge(
    "ai_service_memory_rss_bytes",
    "Resident set size used by the AI service process",
)
_RESOURCE_CPU = Gauge(
    "ai_service_cpu_percent",
    "CPU utilisation percent reported by psutil",
)


def record_duration(model: str, cached: bool, seconds: float) -> None:
    _ANALYSIS_DURATION.labels(model=model, cached=str(cached).lower()).observe(seconds)


def record_completion(model: str) -> None:
    _ANALYSIS_COMPLETED.labels(model=model).inc()


def record_error(reason: str) -> None:
    _ANALYSIS_ERRORS.labels(reason=reason).inc()


def record_resources() -> None:
    if psutil is None:  # pragma: no cover
        return
    process = psutil.Process()
    with process.oneshot():
        memory = process.memory_info().rss
        cpu = process.cpu_percent(interval=None)
    _RESOURCE_MEMORY.set(memory)
    _RESOURCE_CPU.set(cpu)
