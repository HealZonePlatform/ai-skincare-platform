-- database/init.sql
-- Database initialization script for AI Skincare Platform
-- This script creates the database schema for Auth Service and related tables

-- ================================
-- EXTENSIONS
-- ================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For text search optimization

-- ================================
-- DROP EXISTING TABLES (for clean reinstall)
-- ================================
DROP TABLE IF EXISTS skin_analyses CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ================================
-- USERS TABLE
-- ================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    skin_type VARCHAR(50) CHECK (skin_type IN ('oily', 'dry', 'combination', 'sensitive', 'normal', 'mature')),
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    email_verified_at TIMESTAMP WITH TIME ZONE,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ================================
-- SKIN ANALYSES TABLE
-- ================================
CREATE TABLE skin_analyses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    analysis_result JSONB NOT NULL,
    confidence_score DECIMAL(5,4) CHECK (confidence_score >= 0 AND confidence_score <= 1),
    ai_model_version VARCHAR(50) NOT NULL,
    recommendations JSONB,
    severity_level VARCHAR(20) CHECK (severity_level IN ('mild', 'moderate', 'severe', 'critical')),
    skin_concerns TEXT[],
    analysis_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_by VARCHAR(100),
    processing_time_ms INTEGER,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ================================
-- REFRESH TOKENS TABLE (for JWT management)
-- ================================
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT false,
    device_info JSONB,
    ip_address INET,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ================================
-- INDEXES FOR PERFORMANCE
-- ================================
-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_verified ON users(is_verified);
CREATE INDEX IF NOT EXISTS idx_users_skin_type ON users(skin_type);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Skin analyses table indexes
CREATE INDEX IF NOT EXISTS idx_skin_analyses_user_id ON skin_analyses(user_id);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_date ON skin_analyses(analysis_date);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_severity ON skin_analyses(severity_level);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_model_version ON skin_analyses(ai_model_version);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_created_at ON skin_analyses(created_at);

-- GIN indexes for JSONB columns
CREATE INDEX IF NOT EXISTS idx_skin_analyses_result_gin ON skin_analyses USING GIN (analysis_result);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_recommendations_gin ON skin_analyses USING GIN (recommendations);
CREATE INDEX IF NOT EXISTS idx_skin_analyses_concerns_gin ON skin_analyses USING GIN (skin_concerns);

-- Refresh tokens table indexes
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_revoked ON refresh_tokens(is_revoked);

-- ================================
-- TRIGGERS AND FUNCTIONS
-- ================================

-- Function to automatically update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for auto-updating updated_at
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_skin_analyses_updated_at ON skin_analyses;
CREATE TRIGGER update_skin_analyses_updated_at 
    BEFORE UPDATE ON skin_analyses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_refresh_tokens_updated_at ON refresh_tokens;
CREATE TRIGGER update_refresh_tokens_updated_at 
    BEFORE UPDATE ON refresh_tokens 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- SAMPLE DATA (Optional - for testing)
-- ================================

-- Insert sample admin user
INSERT INTO users (
    email, 
    password, 
    first_name, 
    last_name, 
    phone, 
    skin_type,
    is_active, 
    is_verified,
    email_verified_at
) VALUES (
    'admin@aiskincare.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfCgCuKYAnyg2b.', -- password: 'admin123'
    'Admin',
    'User',
    '+1234567890',
    'normal',
    true,
    true,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO NOTHING;

-- Insert sample demo user
INSERT INTO users (
    email, 
    password, 
    first_name, 
    last_name, 
    phone, 
    skin_type,
    is_active, 
    is_verified
) VALUES (
    'demo@example.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfCgCuKYAnyg2b.', -- password: 'demo123'
    'Demo',
    'User',
    '+0987654321',
    'combination',
    true,
    false
) ON CONFLICT (email) DO NOTHING;

-- ================================
-- VIEWS (Optional - for reporting)
-- ================================

-- View for user statistics
CREATE OR REPLACE VIEW user_stats AS
SELECT 
    COUNT(*) as total_users,
    COUNT(*) FILTER (WHERE is_active = true) as active_users,
    COUNT(*) FILTER (WHERE is_verified = true) as verified_users,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as new_users_last_30_days,
    COUNT(*) FILTER (WHERE skin_type = 'oily') as oily_skin_users,
    COUNT(*) FILTER (WHERE skin_type = 'dry') as dry_skin_users,
    COUNT(*) FILTER (WHERE skin_type = 'combination') as combination_skin_users,
    COUNT(*) FILTER (WHERE skin_type = 'sensitive') as sensitive_skin_users,
    COUNT(*) FILTER (WHERE skin_type = 'normal') as normal_skin_users,
    COUNT(*) FILTER (WHERE skin_type = 'mature') as mature_skin_users
FROM users;

-- View for analysis statistics
CREATE OR REPLACE VIEW analysis_stats AS
SELECT 
    COUNT(*) as total_analyses,
    COUNT(DISTINCT user_id) as users_with_analyses,
    AVG(confidence_score) as avg_confidence_score,
    COUNT(*) FILTER (WHERE severity_level = 'mild') as mild_cases,
    COUNT(*) FILTER (WHERE severity_level = 'moderate') as moderate_cases,
    COUNT(*) FILTER (WHERE severity_level = 'severe') as severe_cases,
    COUNT(*) FILTER (WHERE severity_level = 'critical') as critical_cases,
    COUNT(*) FILTER (WHERE analysis_date >= CURRENT_DATE - INTERVAL '7 days') as analyses_last_7_days,
    COUNT(*) FILTER (WHERE analysis_date >= CURRENT_DATE - INTERVAL '30 days') as analyses_last_30_days
FROM skin_analyses;

-- ================================
-- SECURITY & PERMISSIONS
-- ================================

-- Create application role (optional - for production)
-- DO $$
-- BEGIN
--     IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'app_user') THEN
--         CREATE ROLE app_user LOGIN PASSWORD 'secure_app_password';
--         GRANT CONNECT ON DATABASE ai_skincare TO app_user;
--         GRANT USAGE ON SCHEMA public TO app_user;
--         GRANT SELECT, INSERT, UPDATE, DELETE ON users, skin_analyses, refresh_tokens TO app_user;
--         GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;
--     END IF;
-- END
-- $$;

-- ================================
-- COMPLETION LOG
-- ================================
DO $$
BEGIN
    RAISE NOTICE '🎉 AI Skincare Database initialized successfully at %', NOW();
    RAISE NOTICE '📊 Users table: % sample records', (SELECT COUNT(*) FROM users);
    RAISE NOTICE '📈 Total tables created: %', (
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    );
    RAISE NOTICE '📋 Total indexes created: %', (
        SELECT COUNT(*) 
        FROM pg_indexes 
        WHERE schemaname = 'public'
    );
    RAISE NOTICE '✅ Database ready for AI Skincare Platform!';
END $$;
