// src/utils/jwt.util.ts
import jwt from 'jsonwebtoken';
import { IUser } from '../interfaces/user.interface';
import { ITokenPayload } from '../interfaces/auth.interface';

/**
 * Generate access token for user
 */
const generateAccessToken = (user: IUser): string => {
  const accessTokenSecret = process.env.JWT_ACCESS_SECRET;
  const accessTokenExpiresIn = process.env.JWT_ACCESS_EXPIRY; // Sử dụng EXPIRY thay vì EXPIRES_IN để consistent

  if (!accessTokenSecret || !accessTokenExpiresIn) {
    throw new Error('JWT access token secret or expiration is not defined in environment variables.');
  }

  const payload = {
    userId: user.id, // Sử dụng userId để consistent với ITokenPayload
    email: user.email,
    type: 'access'
  };

  return jwt.sign(payload, accessTokenSecret, {
    expiresIn: accessTokenExpiresIn,
    issuer: 'auth-service',
    audience: 'ai-skincare-platform'
  });
};

/**
 * Generate refresh token for user
 */
const generateRefreshToken = (user: IUser): string => {
  const refreshTokenSecret = process.env.JWT_REFRESH_SECRET;
  const refreshTokenExpiresIn = process.env.JWT_REFRESH_EXPIRY; // Sử dụng EXPIRY thay vì EXPIRES_IN

  if (!refreshTokenSecret || !refreshTokenExpiresIn) {
    throw new Error('JWT refresh token secret or expiration is not defined in environment variables.');
  }

  const payload = {
    userId: user.id, // Sử dụng userId để consistent
    email: user.email,
    type: 'refresh'
  };

  return jwt.sign(payload, refreshTokenSecret, {
    expiresIn: refreshTokenExpiresIn,
    issuer: 'auth-service',
    audience: 'ai-skincare-platform'
  });
};

/**
 * Verify JWT token
 */
const verifyToken = (token: string, secret: string) => {
  try {
    const decoded = jwt.verify(token, secret) as ITokenPayload;
    return {
      valid: true,
      expired: false,
      decoded,
    };
  } catch (error: any) {
    return {
      valid: false,
      expired: error.message === 'jwt expired' || error.name === 'TokenExpiredError',
      decoded: null,
    };
  }
};

/**
 * Verify access token specifically
 */
const verifyAccessToken = (token: string): { valid: boolean; expired: boolean; decoded: ITokenPayload | null } => {
  const accessTokenSecret = process.env.JWT_ACCESS_SECRET;
  
  if (!accessTokenSecret) {
    throw new Error('JWT access token secret is not defined in environment variables.');
  }

  const result = verifyToken(token, accessTokenSecret);
  
  // Additional validation for access token type
  if (result.valid && result.decoded && result.decoded.type !== 'access') {
    return {
      valid: false,
      expired: false,
      decoded: null
    };
  }

  return result;
};

/**
 * Verify refresh token specifically
 */
const verifyRefreshToken = (token: string): { valid: boolean; expired: boolean; decoded: ITokenPayload | null } => {
  const refreshTokenSecret = process.env.JWT_REFRESH_SECRET;
  
  if (!refreshTokenSecret) {
    throw new Error('JWT refresh token secret is not defined in environment variables.');
  }

  const result = verifyToken(token, refreshTokenSecret);
  
  // Additional validation for refresh token type
  if (result.valid && result.decoded && result.decoded.type !== 'refresh') {
    return {
      valid: false,
      expired: false,
      decoded: null
    };
  }

  return result;
};

/**
 * Extract token from Authorization header
 */
const extractTokenFromHeader = (authHeader: string | undefined): string | null => {
  if (!authHeader) {
    return null;
  }

  // Check if header starts with "Bearer "
  if (!authHeader.startsWith('Bearer ')) {
    return null;
  }

  // Extract token part after "Bearer "
  const token = authHeader.substring(7).trim();
  
  // Validate token is not empty
  if (!token) {
    return null;
  }

  return token;
};

/**
 * Decode token without verification (for debugging purposes)
 */
const decodeToken = (token: string): ITokenPayload | null => {
  try {
    const decoded = jwt.decode(token) as ITokenPayload;
    
    if (!decoded || typeof decoded === 'string') {
      return null;
    }

    return decoded;
  } catch (error) {
    console.error('Token decode failed:', error);
    return null;
  }
};

/**
 * Generate both access and refresh tokens
 */
const generateTokens = (user: IUser): { accessToken: string; refreshToken: string } => {
  return {
    accessToken: generateAccessToken(user),
    refreshToken: generateRefreshToken(user)
  };
};

export {
  generateAccessToken,
  generateRefreshToken,
  generateTokens,
  verifyToken,
  verifyAccessToken,
  verifyRefreshToken,
  extractTokenFromHeader,
  decodeToken
};
