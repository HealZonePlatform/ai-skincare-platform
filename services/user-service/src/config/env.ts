import { z } from 'zod';
import dotenv from 'dotenv';
dotenv.config();

const EnvSchema = z.object({
  PORT: z.string().default('3004'),
  NODE_ENV: z.string().default('development'),
  DB_HOST: z.string(),
  DB_PORT: z.string().default('5432'),
  DB_NAME: z.string(),
  DB_USER: z.string(),
  DB_PASSWORD: z.string(),
  JWT_ACCESS_SECRET: z.string(),
  ALLOWED_ORIGINS: z.string().optional(),
});

export const env = EnvSchema.parse(process.env);
