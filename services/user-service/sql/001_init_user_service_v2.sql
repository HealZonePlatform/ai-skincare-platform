-- 001_init_user_service_v2.sql
-- No FK to auth DB; user_id is a UUID from JWT.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS user_profiles (
  user_id UUID PRIMARY KEY,
  full_name TEXT,
  phone TEXT,
  gender TEXT CHECK (gender IN ('male','female','other') OR gender IS NULL),
  dob DATE,
  preferences JSONB DEFAULT '{}'::jsonb,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_lifestyle (
  user_id UUID PRIMARY KEY,
  sleep_hours_range TEXT,
  water_cups_range TEXT,
  diet_tags TEXT[],
  cycle_phase TEXT,
  stress_level INT,
  allergy_notes TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_reminders (
  user_id UUID PRIMARY KEY,
  daily_care_enabled BOOLEAN DEFAULT FALSE,
  daily_care_time TIME,
  periodic_scan_enabled BOOLEAN DEFAULT FALSE,
  periodic_scan_frequency TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_goals (
  user_id UUID NOT NULL,
  goal TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, goal)
);

-- Optional read-model for history if not provided elsewhere
CREATE TABLE IF NOT EXISTS skin_analyses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  captured_at TIMESTAMPTZ DEFAULT now(),
  overall NUMERIC,
  acne NUMERIC,
  dark_spots NUMERIC,
  hydration NUMERIC,
  oil NUMERIC,
  summary TEXT,
  photos JSONB
);

CREATE INDEX IF NOT EXISTS idx_skin_analyses_user ON skin_analyses(user_id);
