// src/routes/auth.routes.ts
import { Router } from 'express';
import authController from '../controllers/auth.controller';
import authMiddleware from '../middlewares/auth.middleware';
import { validateRequest } from '../middlewares/validation.middleware';
import authValidator from '../validators/auth.validator';

const router = Router();

// Public routes
router.post('/register', 
  validateRequest(authValidator.validateRegister),
  authController.register
);

router.post('/login', 
  validateRequest(authValidator.validateLogin),
  authController.login
);

// Protected routes
router.post('/refresh', 
  validateRequest(authValidator.validateRefreshToken),
  authMiddleware.verifyRefreshToken,
  authController.refreshToken
);

router.post('/logout', 
  authMiddleware.verifyToken,
  authController.logout
);

router.get('/profile', 
  authMiddleware.verifyToken,
  authController.getProfile
);

export default router;
