import { query } from '../config/database';

export async function getGoals(userId: string) {
  const res = await query<{ goal: string }>(
    'SELECT goal FROM user_goals WHERE user_id=$1 ORDER BY goal ASC',
    [userId]
  );
  return res.rows.map(row => row.goal);
}

export async function setGoals(userId: string, goals: string[]) {
  await query('DELETE FROM user_goals WHERE user_id=$1', [userId]);
  if (goals.length) {
    const values = goals.map((g, i) => `($1, $${i+2})`).join(',');
    await query(`INSERT INTO user_goals (user_id, goal) VALUES ${values}`, [userId, ...goals]);
  }
  return getGoals(userId);
}
