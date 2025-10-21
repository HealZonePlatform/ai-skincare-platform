"""Database utilities for the AI service."""

from __future__ import annotations

import asyncpg

from app.config import Settings


async def create_pool(settings: Settings) -> asyncpg.Pool:
    """Initialise a connection pool using service settings."""

    async def _setup_connection(connection: asyncpg.Connection) -> None:
        await connection.execute(
            "SET statement_timeout = $1", settings.db_statement_timeout_ms
        )

    pool = await asyncpg.create_pool(
        dsn=settings.database_url,
        min_size=max(1, settings.db_pool_min_size),
        max_size=max(settings.db_pool_min_size + 1, settings.db_pool_max_size),
        statement_cache_size=0,
        init=_setup_connection,
    )

    return pool


async def close_pool(pool: asyncpg.Pool) -> None:
    """Gracefully close the connection pool."""

    await pool.close()
