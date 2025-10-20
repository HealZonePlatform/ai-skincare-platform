import { Router } from 'express';
import * as ctrl from '../controllers/me.controller';
import { validate } from '../middlewares/validation';
import { requireAuth } from '../middlewares/auth';
import { UpdateProfileSchema, UpdateRemindersSchema, UpdateLifestyleSchema, UpdateGoalsSchema } from '../validators/me.validators';

const router = Router();
router.use(requireAuth);

router.get('/profile', ctrl.getProfile);
router.put('/profile', validate(UpdateProfileSchema), ctrl.updateProfile);

router.get('/history', ctrl.getHistory);

router.get('/reminders', ctrl.getReminders);
router.put('/reminders', validate(UpdateRemindersSchema), ctrl.updateReminders);

router.get('/lifestyle', ctrl.getLifestyle);
router.put('/lifestyle', validate(UpdateLifestyleSchema), ctrl.updateLifestyle);

router.get('/goals', ctrl.getGoals);
router.put('/goals', validate(UpdateGoalsSchema), ctrl.setGoals);

export default router;
