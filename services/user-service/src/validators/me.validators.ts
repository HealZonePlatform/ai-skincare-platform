import { z } from 'zod';

export const UpdateProfileSchema = z.object({
  full_name: z.string().min(1).max(200).optional(),
  phone: z.string().min(5).max(30).optional(),
  gender: z.enum(['male','female','other']).optional(),
  dob: z.string().optional(),
  preferences: z.object({ categories: z.array(z.string()).default([]) }).partial().optional(),
  avatar_url: z.string().url().optional()
});

export const UpdateRemindersSchema = z.object({
  daily_care_enabled: z.boolean().optional(),
  daily_care_time: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  periodic_scan_enabled: z.boolean().optional(),
  periodic_scan_frequency: z.enum(['weekly','biweekly','monthly']).optional()
});

export const UpdateLifestyleSchema = z.object({
  sleep_hours_range: z.enum(['<5','5-7','7-9','>9']).optional(),
  water_cups_range: z.enum(['1','3-5','5-7','7-9']).optional(),
  diet_tags: z.array(z.string()).optional(),
  cycle_phase: z.enum(['pre','during','post','none','male']).optional(),
  stress_level: z.number().int().min(1).max(3).optional(),
  allergy_notes: z.string().max(2000).optional()
});

export const UpdateGoalsSchema = z.object({
  goals: z.array(z.string()).max(20)
});
