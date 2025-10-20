import { Pool } from 'pg';

export function pgPool(config: { host:string; port:number; database:string; user:string; password:string; max?:number }) {
  const pool = new Pool(config);
  async function healthCheck() {
    try {
      const r = await pool.query('SELECT 1 as ok');
      return r.rows[0].ok === 1;
    } catch {
      return false;
    }
  }
  return { pool, healthCheck };
}
