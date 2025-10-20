import { query } from '../config/database';

export async function getProfile(userId: string) {
  const res = await query(`
    SELECT full_name, phone, gender, dob, preferences, avatar_url
    FROM user_profiles WHERE user_id=$1
  `, [userId]);
  return res.rows[0] || null;
}

export async function upsertProfile(userId: string, data: any) {
  const res = await query(`
    INSERT INTO user_profiles (user_id, full_name, phone, gender, dob, preferences, avatar_url)
    VALUES ($1,$2,$3,$4,$5,$6,$7)
    ON CONFLICT (user_id) DO UPDATE SET
      full_name=COALESCE(EXCLUDED.full_name, user_profiles.full_name),
      phone=COALESCE(EXCLUDED.phone, user_profiles.phone),
      gender=COALESCE(EXCLUDED.gender, user_profiles.gender),
      dob=COALESCE(EXCLUDED.dob, user_profiles.dob),
      preferences=COALESCE(EXCLUDED.preferences, user_profiles.preferences),
      avatar_url=COALESCE(EXCLUDED.avatar_url, user_profiles.avatar_url),
      updated_at=now()
    RETURNING *
  `, [userId, data.full_name, data.phone, data.gender, data.dob, data.preferences, data.avatar_url]);
  return res.rows[0];
}
