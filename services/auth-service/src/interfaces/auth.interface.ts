// src/interfaces/auth.interface.ts
export interface IAuthTokens {
  accessToken: string;
  refreshToken: string;
}

export interface ITokenPayload {
  userId: string;
  email: string;
  type: 'access' | 'refresh';
}

export interface IAuthResponse {
  user: Omit<IUser, 'password'>;
  tokens: IAuthTokens;
}
