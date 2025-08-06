// src/utils/jwt.util.ts
import jwt from 'jsonwebtoken';
import { ITokenPayload } from '../interfaces/auth.interface';

class JWTUtil {
  private accessTokenSecret: string;
  private refreshTokenSecret: string;
  private accessTokenExpiry: string;
  private refreshTokenExpiry: string;

  constructor() {
    this.accessTokenSecret = process.env.JWT_ACCESS_SECRET || 'access-secret';
    this.refreshTokenSecret = process.env.JWT_REFRESH_SECRET || 'refresh-secret';
    this.accessTokenExpiry = process.env.JWT_ACCESS_EXPIRY || '15m';
    this.refreshTokenExpiry = process.env.JWT_REFRESH_EXPIRY || '7d';
  }

  /**
   * Tạo access token
   */
  generateAccessToken(userId: string, email: string): string {
    const payload: ITokenPayload = {
      userId,
      email,
      type: 'access'
    };

    return jwt.sign(payload, this.accessTokenSecret, {
      expiresIn: this.accessTokenExpiry,
      issuer: 'auth-service',
      audience: 'ai-skincare-platform'
    });
  }

  /**
   * Tạo refresh token
   */
  generateRefreshToken(userId: string, email: string): string {
    const payload: ITokenPayload = {
      userId,
      email,
      type: 'refresh'
    };

    return jwt.sign(payload, this.refreshTokenSecret, {
      expiresIn: this.refreshTokenExpiry,
      issuer: 'auth-service',
      audience: 'ai-skincare-platform'
    });
  }

  /**
   * Verify access token
   */
  verifyAccessToken(token: string): ITokenPayload | null {
    try {
      const decoded = jwt.verify(token, this.accessTokenSecret) as ITokenPayload;
      if (decoded.type !== 'access') {
        return null;
      }
      return decoded;
    } catch (error) {
      return null;
    }
  }

  /**
   * Verify refresh token
   */
  verifyRefreshToken(token: string): ITokenPayload | null {
    try {
      const decoded = jwt.verify(token, this.refreshTokenSecret) as ITokenPayload;
      if (decoded.type !== 'refresh') {
        return null;
      }
      return decoded;
    } catch (error) {
      return null;
    }
  }

  /**
   * Lấy token từ header Authorization
   */
  extractTokenFromHeader(authHeader: string | undefined): string | null {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return null;
    }
    return authHeader.substring(7);
  }
}

export default new JWTUtil();
