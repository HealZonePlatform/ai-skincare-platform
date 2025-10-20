import { query } from '../config/database';

export async function getLifestyle(userId: string) {
  const res = await query('SELECT * FROM user_lifestyle WHERE user_id=$1', [userId]);
  return res.rows[0] || null;
}

export async function upsertLifestyle(userId: string, data: any) {
  const res = await query(`
    INSERT INTO user_lifestyle (user_id, sleep_hours_range, water_cups_range, diet_tags, cycle_phase, stress_level, allergy_notes)
    VALUES ($1,$2,$3,$4,$5,$6,$7)
    ON CONFLICT (user_id) DO UPDATE SET
      sleep_hours_range = COALESCE(EXCLUDED.sleep_hours_range, user_lifestyle.sleep_hours_range),
      water_cups_range = COALESCE(EXCLUDED.water_cups_range, user_lifestyle.water_cups_range),
      diet_tags = COALESCE(EXCLUDED.diet_tags, user_lifestyle.diet_tags),
      cycle_phase = COALESCE(EXCLUDED.cycle_phase, user_lifestyle.cycle_phase),
      stress_level = COALESCE(EXCLUDED.stress_level, user_lifestyle.stress_level),
      allergy_notes = COALESCE(EXCLUDED.allergy_notes, user_lifestyle.allergy_notes),
      updated_at=now()
    RETURNING *
  `, [userId, data.sleep_hours_range, data.water_cups_range, data.diet_tags, data.cycle_phase, data.stress_level, data.allergy_notes]);
  return res.rows[0];
}
