import { QueryResult, QueryResultRow } from 'pg';
import { db } from 'hz-shared';
import { env } from './env';

const { pool, healthCheck } = db.pgPool({
  host: env.DB_HOST,
  port: Number(env.DB_PORT),
  database: env.DB_NAME,
  user: env.DB_USER,
  password: env.DB_PASSWORD,
  max: 10
});

export { pool, healthCheck };

export async function query<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params?: unknown[]
): Promise<QueryResult<T>> {
  return pool.query<T>(text, params as any[]);
}
