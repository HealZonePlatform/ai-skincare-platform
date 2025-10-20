import { query } from '../config/database';

export async function getReminders(userId: string) {
  const res = await query('SELECT * FROM user_reminders WHERE user_id=$1', [userId]);
  return res.rows[0] || null;
}

export async function upsertReminders(userId: string, data: any) {
  const res = await query(`
    INSERT INTO user_reminders (user_id, daily_care_enabled, daily_care_time, periodic_scan_enabled, periodic_scan_frequency)
    VALUES ($1,$2,$3,$4,$5)
    ON CONFLICT (user_id) DO UPDATE SET
      daily_care_enabled = COALESCE(EXCLUDED.daily_care_enabled, user_reminders.daily_care_enabled),
      daily_care_time = COALESCE(EXCLUDED.daily_care_time, user_reminders.daily_care_time),
      periodic_scan_enabled = COALESCE(EXCLUDED.periodic_scan_enabled, user_reminders.periodic_scan_enabled),
      periodic_scan_frequency = COALESCE(EXCLUDED.periodic_scan_frequency, user_reminders.periodic_scan_frequency),
      updated_at=now()
    RETURNING *
  `, [userId, data.daily_care_enabled, data.daily_care_time, data.periodic_scan_enabled, data.periodic_scan_frequency]);
  return res.rows[0];
}
