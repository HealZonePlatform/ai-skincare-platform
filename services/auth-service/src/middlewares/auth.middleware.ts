// src/middlewares/auth.middleware.ts
import { Response, NextFunction } from 'express';
import { AuthenticatedRequest } from '../types';
import { verifyAccessToken, verifyRefreshToken, extractTokenFromHeader } from '../utils/jwt.util';
import responseUtil from '../utils/response.util';
import redisConfig from '../config/redis';

class AuthMiddleware {
  /**
   * Middleware để verify access token
   */
  async verifyToken(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
    try {
      const token = extractTokenFromHeader(req.headers.authorization);
      
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

      const result = verifyAccessToken(token);
      if (!result.valid) {
        const message = result.expired ? 'Access token has expired' : 'Invalid access token';
        responseUtil.unauthorized(res, message);
        return;
      }

      if (!result.decoded) {
        responseUtil.unauthorized(res, 'Invalid token payload');
        return;
      }

      // Attach user info to request
      req.user = {
        userId: result.decoded.userId,
        email: result.decoded.email
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
  async verifyRefreshTokenMiddleware(req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> {
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

      const result = verifyRefreshToken(refreshToken);
      if (!result.valid) {
        const message = result.expired ? 'Refresh token has expired' : 'Invalid refresh token';
        responseUtil.unauthorized(res, message);
        return;
      }

      if (!result.decoded) {
        responseUtil.unauthorized(res, 'Invalid refresh token payload');
        return;
      }

      req.user = {
        userId: result.decoded.userId,
        email: result.decoded.email
      };

      next();
    } catch (error) {
      console.error('Refresh token middleware error:', error);
      responseUtil.serverError(res, 'Token verification failed');
    }
  }
}

export default new AuthMiddleware();
