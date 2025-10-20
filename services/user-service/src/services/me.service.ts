import * as meRepo from '../repositories/me.repo';
import * as historyRepo from '../repositories/history.repo';
import * as remindersRepo from '../repositories/reminders.repo';
import * as lifestyleRepo from '../repositories/lifestyle.repo';
import * as goalsRepo from '../repositories/goals.repo';

export const getProfile = (userId: string) => meRepo.getProfile(userId);
export const updateProfile = (userId: string, data: any) => meRepo.upsertProfile(userId, data);
export const getHistory = (userId: string, limit?: number, offset?: number) => historyRepo.getHistory(userId, limit, offset);
export const getReminders = (userId: string) => remindersRepo.getReminders(userId);
export const updateReminders = (userId: string, data: any) => remindersRepo.upsertReminders(userId, data);
export const getLifestyle = (userId: string) => lifestyleRepo.getLifestyle(userId);
export const updateLifestyle = (userId: string, data: any) => lifestyleRepo.upsertLifestyle(userId, data);
export const getGoals = (userId: string) => goalsRepo.getGoals(userId);
export const setGoals = (userId: string, goals: string[]) => goalsRepo.setGoals(userId, goals);
