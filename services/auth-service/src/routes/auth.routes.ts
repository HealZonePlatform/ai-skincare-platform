// src/routes/auth.routes.ts
import { Router, Response } from 'express';
import { AuthenticatedRequest } from '../types'; // Import AuthenticatedRequest type
import authController from '../controllers/auth.controller';
import authMiddleware from '../middlewares/auth.middleware';
import { validateRequest } from '../middlewares/validation.middleware';
import authValidator from '../validators/auth.validator';

const router = Router();

// Health check route
router.get('/health', authController.healthCheck);

// Public routes
router.post('/register', 
  validateRequest(authValidator.validateRegister),
  authController.register
);

router.post('/login', 
  validateRequest(authValidator.validateLogin),
  authController.login
);

// Protected routes - refresh token
router.post('/refresh', 
  validateRequest(authValidator.validateRefreshToken),
  authMiddleware.verifyRefreshTokenMiddleware,
  authController.refreshToken
);

// Protected routes - access token required
router.post('/logout', 
  validateRequest(authValidator.validateLogout), // Thêm validator cho logout
  authMiddleware.verifyToken,
  authController.logout
);

router.get('/profile', 
  authMiddleware.verifyToken,
  authController.getProfile
);

// Additional utility routes với đúng type
router.get('/verify-token',
  authMiddleware.verifyToken,
  (req: AuthenticatedRequest, res: Response) => { // ✅ Sửa type ở đây
    res.json({
      success: true,
      message: 'Token is valid',
      data: {
        user: req.user, // ✅ Bây giờ req.user đã được định nghĩa
        timestamp: new Date().toISOString()
      }
    });
  }
);

// Route để check token expiration
router.get('/token-info',
  authMiddleware.verifyToken,
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      success: true,
      message: 'Token information retrieved',
      data: {
        user: req.user,
        tokenValid: true,
        timestamp: new Date().toISOString()
      }
    });
  }
);

export default router;
