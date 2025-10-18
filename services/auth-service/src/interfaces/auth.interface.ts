// src/interfaces/auth.interface.ts
import { IUser } from './user.interface';

export interface IAuthTokens {
  accessToken: string;
  refreshToken: string;
}

export interface ITokenPayload {
  userId: string;
  email: string;
  type: 'access' | 'refresh';
  iat?: number; // issued at
  exp?: number; // expires at
  iss?: string; // issuer
  aud?: string; // audience
}

export interface IAuthResponse {
  user: Omit<IUser, 'password'>;
  tokens: IAuthTokens;
}

export interface IRefreshTokenRequest {
  refreshToken: string;
}

export interface ITokenVerificationResult {
  valid: boolean;
  expired: boolean;
  decoded: ITokenPayload | null;
}
