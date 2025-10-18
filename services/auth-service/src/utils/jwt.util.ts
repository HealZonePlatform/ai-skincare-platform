// src/utils/jwt.util.ts
import jwt, { JwtPayload } from 'jsonwebtoken';
import { IUser } from '../interfaces/user.interface';
import { ITokenPayload } from '../interfaces/auth.interface';

/**
 * Get environment variable with validation
 */
const getEnvVariable = (key: string, fallback?: string): string => {
  const value = process.env[key];
  if (!value) {
    if (fallback) {
      console.warn(`⚠️ Environment variable ${key} not found, using fallback`);
      return fallback;
    }
    throw new Error(`❌ Environment variable ${key} is required but not defined`);
  }
  return value;
};

/**
 * JWT Configuration
 */
const JWT_CONFIG = {
  ACCESS_SECRET: getEnvVariable('JWT_ACCESS_SECRET', 'fallback-access-secret-key-for-development-only-minimum-32-characters-long'),
  REFRESH_SECRET: getEnvVariable('JWT_REFRESH_SECRET', 'fallback-refresh-secret-key-for-development-only-minimum-32-characters-long'),
  ACCESS_EXPIRY: getEnvVariable('JWT_ACCESS_EXPIRY', '15m'),
  REFRESH_EXPIRY: getEnvVariable('JWT_REFRESH_EXPIRY', '7d'),
  ISSUER: 'auth-service',
  AUDIENCE: 'ai-skincare-platform'
} as const;

/**
 * Generate access token for user
 */
const generateAccessToken = (user: IUser): string => {
  const payload = {
    userId: user.id,
    email: user.email,
    type: 'access'
  };

  try {
    // ✅ GIẢI PHÁP CUỐI CÙNG: Direct function call với type assertion
    return jwt.sign(
      payload, 
      JWT_CONFIG.ACCESS_SECRET,
      {
        expiresIn: JWT_CONFIG.ACCESS_EXPIRY as any, // ✅ Type assertion triệt để
        issuer: JWT_CONFIG.ISSUER,
        audience: JWT_CONFIG.AUDIENCE,
        algorithm: 'HS256'
      }
    );
  } catch (error) {
    console.error('❌ Error generating access token:', error);
    throw new Error('Failed to generate access token');
  }
};

/**
 * Generate refresh token for user
 */
const generateRefreshToken = (user: IUser): string => {
  const payload = {
    userId: user.id,
    email: user.email,
    type: 'refresh'
  };

  try {
    // ✅ GIẢI PHÁP CUỐI CÙNG: Direct function call với type assertion
    return jwt.sign(
      payload, 
      JWT_CONFIG.REFRESH_SECRET,
      {
        expiresIn: JWT_CONFIG.REFRESH_EXPIRY as any, // ✅ Type assertion triệt để
        issuer: JWT_CONFIG.ISSUER,
        audience: JWT_CONFIG.AUDIENCE,
        algorithm: 'HS256'
      }
    );
  } catch (error) {
    console.error('❌ Error generating refresh token:', error);
    throw new Error('Failed to generate refresh token');
  }
};

/**
 * Verify JWT token with proper error handling
 */
const verifyToken = (token: string, secret: string) => {
  try {
    const decoded = jwt.verify(token, secret, {
      algorithms: ['HS256'],
      issuer: JWT_CONFIG.ISSUER,
      audience: JWT_CONFIG.AUDIENCE
    }) as JwtPayload & ITokenPayload;

    return {
      valid: true,
      expired: false,
      decoded: decoded as ITokenPayload,
    };
  } catch (error: any) {
    const isExpired = error.name === 'TokenExpiredError' || 
                     error.message === 'jwt expired';
    
    return {
      valid: false,
      expired: isExpired,
      decoded: null,
    };
  }
};

/**
 * Verify access token specifically
 */
const verifyAccessToken = (token: string) => {
  const result = verifyToken(token, JWT_CONFIG.ACCESS_SECRET);
  
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
const verifyRefreshToken = (token: string) => {
  const result = verifyToken(token, JWT_CONFIG.REFRESH_SECRET);
  
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

  if (!authHeader.startsWith('Bearer ')) {
    return null;
  }

  const token = authHeader.substring(7).trim();
  
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
    const decoded = jwt.decode(token) as JwtPayload & ITokenPayload;
    
    if (!decoded || typeof decoded === 'string') {
      return null;
    }

    return decoded;
  } catch (error) {
    console.error('❌ Token decode failed:', error);
    return null;
  }
};

/**
 * Generate both access and refresh tokens
 */
const generateTokens = (user: IUser): { accessToken: string; refreshToken: string } => {
  try {
    return {
      accessToken: generateAccessToken(user),
      refreshToken: generateRefreshToken(user)
    };
  } catch (error) {
    console.error('❌ Error generating tokens:', error);
    throw new Error('Failed to generate authentication tokens');
  }
};

/**
 * Parse expiry string to number of seconds (for Redis TTL)
 */
const parseExpiryToSeconds = (expiry: string): number => {
  const units: Record<string, number> = {
    's': 1,
    'm': 60,
    'h': 3600,
    'd': 86400,
    'w': 604800,
    'y': 31536000
  };

  const match = expiry.match(/^(\d+)([smhdwy]?)$/);
  if (!match) {
    const parsed = parseInt(expiry, 10);
    return isNaN(parsed) ? 3600 : parsed;
  }

  const [, value, unit] = match;
  const multiplier = units[unit] || 1;
  return parseInt(value, 10) * multiplier;
};

/**
 * Get token TTL in seconds
 */
const getAccessTokenTTL = (): number => {
  return parseExpiryToSeconds(JWT_CONFIG.ACCESS_EXPIRY);
};

const getRefreshTokenTTL = (): number => {
  return parseExpiryToSeconds(JWT_CONFIG.REFRESH_EXPIRY);
};

/**
 * Validate JWT expiry format
 */
const validateExpiryFormat = (expiry: string): boolean => {
  const validFormats = /^(\d+)([smhdwy]?)$/;
  return validFormats.test(expiry) || !isNaN(Number(expiry));
};

/**
 * Check if JWT configuration is valid
 */
const validateJWTConfig = (): boolean => {
  try {
    const requiredConfigs = [
      JWT_CONFIG.ACCESS_SECRET,
      JWT_CONFIG.REFRESH_SECRET,
      JWT_CONFIG.ACCESS_EXPIRY,
      JWT_CONFIG.REFRESH_EXPIRY
    ];

    const isValid = requiredConfigs.every(config => 
      config && config.length > 0
    );

    const expiryValid = validateExpiryFormat(JWT_CONFIG.ACCESS_EXPIRY) && 
                       validateExpiryFormat(JWT_CONFIG.REFRESH_EXPIRY);

    if (!isValid || !expiryValid) {
      console.error('❌ JWT configuration validation failed');
      return false;
    }

    console.log('✅ JWT configuration is valid');
    return true;
  } catch (error) {
    console.error('❌ JWT configuration validation error:', error);
    return false;
  }
};

// Validate configuration on module load
validateJWTConfig();

export {
  generateAccessToken,
  generateRefreshToken,
  generateTokens,
  verifyToken,
  verifyAccessToken,
  verifyRefreshToken,
  extractTokenFromHeader,
  decodeToken,
  validateJWTConfig,
  validateExpiryFormat,
  parseExpiryToSeconds,
  getAccessTokenTTL,
  getRefreshTokenTTL
};
