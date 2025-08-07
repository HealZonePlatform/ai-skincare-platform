// src/controllers/auth.controller.ts
import { Request, Response, NextFunction } from 'express';
import { AuthenticatedRequest } from '../types';
import authService from '../services/auth.service';
import responseUtil from '../utils/response.util';
import { extractTokenFromHeader } from '../utils/jwt.util';

class AuthController {
  /**
   * Đăng ký user mới
   * POST /api/v1/auth/register
   */
  async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userData = req.body;
      
      const result = await authService.register(userData);
      
      responseUtil.success(
        res, 
        'User registered successfully', 
        result, 
        201
      );
    } catch (error: any) {
      if (error.message === 'Email already exists') {
        responseUtil.error(res, 'Email already exists', 'This email is already registered', 409);
        return;
      }
      next(error);
    }
  }

  /**
   * Đăng nhập user
   * POST /api/v1/auth/login
   */
  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const loginData = req.body;
      
      const result = await authService.login(loginData);
      
      responseUtil.success(
        res, 
        'User logged in successfully', 
        result
      );
    } catch (error: any) {
      // Don't expose detailed error for security
      if (error.message.includes('Invalid email or password')) {
        responseUtil.unauthorized(res, 'Invalid email or password');
        return;
      }
      if (error.message === 'Account is deactivated') {
        responseUtil.forbidden(res, 'Account is deactivated. Please contact support.');
        return;
      }
      next(error);
    }
  }

  /**
   * Refresh access token
   * POST /api/v1/auth/refresh
   */
  async refreshToken(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { refreshToken } = req.body;
      const user = req.user!; // Guaranteed by middleware

      const newTokens = await authService.refreshToken(user.userId, user.email, refreshToken);
      
      responseUtil.success(
        res, 
        'Tokens refreshed successfully', 
        { tokens: newTokens }
      );
    } catch (error: any) {
      if (error.message.includes('Invalid refresh token') || error.message.includes('User not found')) {
        responseUtil.unauthorized(res, 'Invalid or expired refresh token');
        return;
      }
      next(error);
    }
  }

  /**
   * Logout user
   * POST /api/v1/auth/logout
   */
  async logout(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { refreshToken } = req.body;
      const user = req.user!;
      
      // Get access token from header
      const accessToken = extractTokenFromHeader(req.headers.authorization);
      if (!accessToken) {
        responseUtil.error(res, 'Access token is required');
        return;
      }

      if (!refreshToken) {
        responseUtil.error(res, 'Refresh token is required');
        return;
      }

      await authService.logout(user.userId, accessToken, refreshToken);
      
      responseUtil.success(res, 'User logged out successfully');
    } catch (error: any) {
      next(error);
    }
  }

  /**
   * Get current user profile
   * GET /api/v1/auth/profile
   */
  async getProfile(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = req.user!;
      
      responseUtil.success(res, 'Profile retrieved successfully', {
        userId: user.userId,
        email: user.email
      });
    } catch (error: any) {
      next(error);
    }
  }

  /**
   * Health check endpoint
   * GET /api/v1/auth/health
   */
  async healthCheck(req: Request, res: Response): Promise<void> {
    responseUtil.success(res, 'Auth service is healthy', {
      timestamp: new Date().toISOString(),
      service: 'auth-service',
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime()
    });
  }
}

export default new AuthController();
