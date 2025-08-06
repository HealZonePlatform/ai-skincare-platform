// src/middlewares/auth.middleware.ts
import { Response, NextFunction } from 'express';
import { AuthenticatedRequest } from '../types';
import jwtUtil from '../utils/jwt.util';
import responseUtil from '../utils/response.util';
import redisConfig from '../config/redis.ts';

class AuthMiddleware {
  /**
   * Middleware để verify access token
   */
  async verifyToken(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const token = jwtUtil.extractTokenFromHeader(req.headers.authorization);
      
      if (!token) {
        responseUtil.unauthorized(res, 'Access token is required');
        return;
      }

      // Check if token is blacklisted
      const blacklisted = await redisConfig.get(`blacklist_${token}`);
      if (blacklisted) {
        responseUtil.unauthorized(res, 'Token has been revoked');
        return;
      }

      const decoded = jwtUtil.verifyAccessToken(token);
      if (!decoded) {
        responseUtil.unauthorized(res, 'Invalid or expired access token');
        return;
      }

      // Attach user info to request
      req.user = {
        userId: decoded.userId,
        email: decoded.email
      };

      next();
    } catch (error) {
      console.error('Auth middleware error:', error);
      responseUtil.serverError(res, 'Authentication failed');
    }
  }

  /**
   * Middleware để check refresh token
   */
  async verifyRefreshToken(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const { refreshToken } = req.body;
      
      if (!refreshToken) {
        responseUtil.error(res, 'Refresh token is required');
        return;
      }

      // Check if refresh token is blacklisted
      const blacklisted = await redisConfig.get(`blacklist_${refreshToken}`);
      if (blacklisted) {
        responseUtil.unauthorized(res, 'Refresh token has been revoked');
        return;
      }

      const decoded = jwtUtil.verifyRefreshToken(refreshToken);
      if (!decoded) {
        responseUtil.unauthorized(res, 'Invalid or expired refresh token');
        return;
      }

      req.user = {
        userId: decoded.userId,
        email: decoded.email
      };

      next();
    } catch (error) {
      console.error('Refresh token middleware error:', error);
      responseUtil.serverError(res, 'Token verification failed');
    }
  }
}

export default new AuthMiddleware();
