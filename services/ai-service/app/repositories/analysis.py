"""Persistence layer for analysis records."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Iterable, List, Optional, Sequence
from uuid import UUID

import asyncpg

from app.schemas import AnalysisRecord, AnalysisResult, AnalysisTrendPoint


@dataclass(frozen=True)
class AnalysisFilters:
    severity: Optional[str] = None
    model_version: Optional[str] = None
    from_date: Optional[datetime] = None
    to_date: Optional[datetime] = None


class AnalysisRepository:
    """Repository encapsulating Postgres persistence for analyses."""

    def __init__(self, pool: asyncpg.Pool) -> None:
        self._pool = pool

    async def ensure_user_exists(self, user_id: str) -> None:
        query = """
            SELECT 1
            FROM users
            WHERE id = $1
              AND (is_active IS NULL OR is_active = TRUE)
            LIMIT 1
        """
        async with self._pool.acquire() as connection:
            row = await connection.fetchrow(query, UUID(user_id))
            if row is None:
                raise LookupError("User not found or inactive")

    async def insert(
        self,
        record: AnalysisRecord,
        *,
        image_url: str,
        confidence_score: Optional[float],
        severity_level: Optional[str],
        skin_concerns: Sequence[str],
        recommendations: dict,
        metadata: dict,
        processing_time_ms: Optional[int],
    ) -> None:
        query = """
            INSERT INTO skin_analyses (
                id,
                user_id,
                image_url,
                analysis_result,
                confidence_score,
                ai_model_version,
                recommendations,
                severity_level,
                skin_concerns,
                analysis_date,
                processed_by,
                processing_time_ms,
                metadata,
                created_at,
                updated_at
            ) VALUES (
                $1, $2, $3, $4, $5,
                $6, $7, $8, $9, $10,
                $11, $12, $13, $14, $15
            )
        """

        payload = record.data.model_dump(mode="json")
        now = datetime.now(timezone.utc)

        async with self._pool.acquire() as connection:
            await connection.execute(
                query,
                UUID(record.analysis_id),
                UUID(record.user_id),
                image_url,
                payload,
                confidence_score,
                record.model,
                recommendations,
                severity_level,
                list(skin_concerns) if skin_concerns else None,
                record.created_at,
                "gemini",
                processing_time_ms,
                metadata,
                now,
                now,
            )

    async def get(self, analysis_id: str) -> Optional[AnalysisRecord]:
        query = """
            SELECT
                id,
                user_id,
                analysis_result,
                ai_model_version,
                analysis_date,
                metadata
            FROM skin_analyses
            WHERE id = $1
        """
        async with self._pool.acquire() as connection:
            row = await connection.fetchrow(query, UUID(analysis_id))
            if not row:
                return None
            return self._row_to_record(row)

    async def list_for_user(
        self,
        user_id: str,
        *,
        limit: int,
        offset: int,
        filters: AnalysisFilters,
    ) -> List[AnalysisRecord]:
        clauses = ["user_id = $1"]
        params: List[object] = [UUID(user_id)]

        def add_param(value: object) -> str:
            params.append(value)
            return f"${len(params)}"

        if filters.severity:
            clauses.append(f"severity_level = {add_param(filters.severity)}")
        if filters.model_version:
            clauses.append(f"ai_model_version = {add_param(filters.model_version)}")
        if filters.from_date:
            clauses.append(f"analysis_date >= {add_param(filters.from_date)}")
        if filters.to_date:
            clauses.append(f"analysis_date <= {add_param(filters.to_date)}")

        clauses_sql = " AND ".join(clauses)

        query = f"""
            SELECT
                id,
                user_id,
                analysis_result,
                ai_model_version,
                analysis_date,
                metadata
            FROM skin_analyses
            WHERE {clauses_sql}
            ORDER BY analysis_date DESC
            LIMIT {add_param(limit)}
            OFFSET {add_param(offset)}
        """

        async with self._pool.acquire() as connection:
            rows = await connection.fetch(query, *params)
            return [self._row_to_record(row) for row in rows]

    async def prune_before(
        self,
        user_id: str,
        before: datetime,
        *,
        batch_size: int,
    ) -> int:
        query = """
            DELETE FROM skin_analyses
            WHERE ctid IN (
                SELECT ctid
                FROM skin_analyses
                WHERE user_id = $1
                  AND analysis_date < $2
                ORDER BY analysis_date ASC
                LIMIT $3
            )
        """
        async with self._pool.acquire() as connection:
            result = await connection.execute(query, UUID(user_id), before, batch_size)
        # result format "DELETE <n>"
        return int(result.split(" ")[-1])

    async def fetch_trends(
        self, user_id: str, *, window_days: int
    ) -> List[AnalysisTrendPoint]:
        query = """
            SELECT
                to_char(date_trunc('month', analysis_date), 'YYYY-MM') AS bucket,
                COUNT(*) AS total,
                SUM(CASE WHEN severity_level IN ('severe', 'critical') THEN 1 ELSE 0 END) AS severe_cases,
                COALESCE(AVG(confidence_score), 0) AS average_confidence
            FROM skin_analyses
            WHERE user_id = $1
              AND analysis_date >= (NOW() AT TIME ZONE 'utc') - ($2::interval)
            GROUP BY 1
            ORDER BY 1 DESC
            LIMIT 12
        """
        interval = f"{max(1, window_days)} days"
        async with self._pool.acquire() as connection:
            rows = await connection.fetch(query, UUID(user_id), interval)

        return [
            AnalysisTrendPoint(
                bucket=row["bucket"],
                total=row["total"],
                severe_cases=row["severe_cases"] or 0,
                average_confidence=float(row["average_confidence"] or 0),
            )
            for row in rows
        ]

    @staticmethod
    def _row_to_record(row: asyncpg.Record) -> AnalysisRecord:
        payload = row["analysis_result"]
        metadata = row.get("metadata") or {}

        return AnalysisRecord(
            analysis_id=str(row["id"]),
            user_id=str(row["user_id"]),
            model=row["ai_model_version"],
            created_at=row["analysis_date"],
            locale=metadata.get("locale", "en"),
            data=AnalysisResult.model_validate(payload),
        )
