import dotenv from 'dotenv';
import path from 'path';
import { z } from 'zod';

const envPath = path.resolve(process.cwd(), '.env');
dotenv.config({ path: envPath });

const EnvSchema = z.object({
  PORT: z.coerce.number().default(3000),
  NODE_ENV: z.string().default('development'),
  JWT_ACCESS_SECRET: z
    .string()
    .min(1, 'JWT_ACCESS_SECRET must be provided for API Gateway to validate tokens'),
  ALLOWED_ORIGINS: z.string().optional(),
  RATE_LIMIT_WINDOW_MS: z.coerce.number().optional(),
  RATE_LIMIT_MAX: z.coerce.number().optional(),
  PROXY_TIMEOUT_MS: z.coerce.number().optional(),
  AUTH_SERVICE_URL: z.string().url().default('http://localhost:3001'),
  USER_SERVICE_URL: z.string().url().default('http://localhost:3004'),
  PRODUCT_SERVICE_URL: z.string().url().default('http://localhost:3003'),
  AI_SERVICE_URL: z.string().url().default('http://localhost:3006'),
  RECOMMENDATION_SERVICE_URL: z.string().url().default('http://localhost:3005'),
  EXPERT_SERVICE_URL: z.string().url().default('http://localhost:3002')
});

const parsed = EnvSchema.parse(process.env);

const allowedOrigins =
  parsed.ALLOWED_ORIGINS?.split(',')
    .map((origin: string) => origin.trim())
    .filter(Boolean) ?? ['*'];

export const config = {
  port: parsed.PORT,
  nodeEnv: parsed.NODE_ENV,
  jwtSecret: parsed.JWT_ACCESS_SECRET,
  cors: {
    allowedOrigins
  },
  rateLimit: {
    windowMs: parsed.RATE_LIMIT_WINDOW_MS ?? 15 * 60 * 1000,
    max: parsed.RATE_LIMIT_MAX ?? 300
  },
  proxy: {
    timeout: parsed.PROXY_TIMEOUT_MS ?? 15_000
  },
  services: {
    auth: parsed.AUTH_SERVICE_URL,
    user: parsed.USER_SERVICE_URL,
    product: parsed.PRODUCT_SERVICE_URL,
    ai: parsed.AI_SERVICE_URL,
    recommendation: parsed.RECOMMENDATION_SERVICE_URL,
    expert: parsed.EXPERT_SERVICE_URL
  }
};

export type AppConfig = typeof config;
