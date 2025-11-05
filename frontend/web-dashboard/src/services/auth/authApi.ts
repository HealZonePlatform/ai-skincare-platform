import { AUTH_BASE_URL } from '@/config/env';
import { apiClient } from '@/lib/httpClient';
import type { ApiResponse } from '@/types/api';

type AuthApiUser = {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  phone?: string | null;
  date_of_birth?: string | null;
  skin_type?: string | null;
  is_active: boolean;
  is_verified: boolean;
  created_at: string;
  updated_at: string;
};

export type AuthUser = {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone?: string | null;
  dateOfBirth?: string | null;
  skinType?: string | null;
  isActive: boolean;
  isVerified: boolean;
  createdAt: string;
  updatedAt: string;
};

export type AuthTokens = {
  accessToken: string;
  refreshToken: string;
};

const mapUser = (user: AuthApiUser): AuthUser => ({
  id: user.id,
  email: user.email,
  firstName: user.first_name,
  lastName: user.last_name,
  phone: user.phone ?? null,
  dateOfBirth: user.date_of_birth ?? null,
  skinType: user.skin_type ?? null,
  isActive: user.is_active,
  isVerified: user.is_verified,
  createdAt: user.created_at,
  updatedAt: user.updated_at
});

type LoginResponse = {
  user: AuthApiUser;
  tokens: AuthTokens;
};

type RefreshResponse = {
  tokens: AuthTokens;
};

type ProfileResponse = {
  userId: string;
  email: string;
};

const ensureData = <T>(response: ApiResponse<T>) => {
  if (!response.success || !response.data) {
    const error = response.error ?? response.message ?? 'Unknown API error';
    throw new Error(error);
  }
  return response.data;
};

export const authApi = {
  async login(email: string, password: string) {
    const response = await apiClient.post<ApiResponse<LoginResponse>>(`${AUTH_BASE_URL}/login`, {
      email,
      password
    });
    const data = ensureData(response.data);
    return {
      user: mapUser(data.user),
      tokens: data.tokens
    };
  },

  async refresh(refreshToken: string) {
    const response = await apiClient.post<ApiResponse<RefreshResponse>>(`${AUTH_BASE_URL}/refresh`, {
      refreshToken
    });
    const data = ensureData(response.data);
    return data.tokens;
  },

  async logout(refreshToken: string) {
    await apiClient.post<ApiResponse<unknown>>(`${AUTH_BASE_URL}/logout`, { refreshToken });
  },

  async profile() {
    const response = await apiClient.get<ApiResponse<ProfileResponse>>(`${AUTH_BASE_URL}/profile`);
    return ensureData(response.data);
  }
};
