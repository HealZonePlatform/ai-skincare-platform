import { query } from '../config/database';

export async function getHistory(userId: string, limit=30, offset=0) {
  const res = await query(`
    SELECT id, captured_at, overall, acne, dark_spots, hydration, oil, summary, photos
    FROM skin_analyses
    WHERE user_id=$1
    ORDER BY captured_at DESC
    LIMIT $2 OFFSET $3
  `, [userId, limit, offset]);
  return res.rows;
}
