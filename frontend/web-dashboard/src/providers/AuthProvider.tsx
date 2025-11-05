'use client';

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState
} from 'react';
import { authApi, type AuthUser } from '@/services/auth/authApi';
import { httpClient } from '@/lib/httpClient';

type Credentials = {
  email: string;
  password: string;
};

type AuthContextValue = {
  user: AuthUser | null;
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  isInitializing: boolean;
  isSubmitting: boolean;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => Promise<void>;
};

type AuthState = {
  user: AuthUser | null;
  accessToken: string | null;
  refreshToken: string | null;
};

const ACCESS_TOKEN_STORAGE_KEY = 'hz_dashboard_access_token';
const REFRESH_TOKEN_STORAGE_KEY = 'hz_dashboard_refresh_token';
const USER_STORAGE_KEY = 'hz_dashboard_user';

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

const loadStoredUser = (): AuthUser | null => {
  if (typeof window === 'undefined') {
    return null;
  }
  const rawUser = window.localStorage.getItem(USER_STORAGE_KEY);
  if (!rawUser) {
    return null;
  }
  try {
    return JSON.parse(rawUser) as AuthUser;
  } catch (error) {
    console.warn('[AuthProvider] Failed to parse stored user, clearing localStorage entry.', error);
    window.localStorage.removeItem(USER_STORAGE_KEY);
    return null;
  }
};

const loadStoredTokens = (): Pick<AuthState, 'accessToken' | 'refreshToken'> => {
  if (typeof window === 'undefined') {
    return { accessToken: null, refreshToken: null };
  }
  return {
    accessToken: window.localStorage.getItem(ACCESS_TOKEN_STORAGE_KEY),
    refreshToken: window.localStorage.getItem(REFRESH_TOKEN_STORAGE_KEY)
  };
};

const persistAuthState = (state: AuthState) => {
  if (typeof window === 'undefined') {
    return;
  }
  if (state.accessToken) {
    window.localStorage.setItem(ACCESS_TOKEN_STORAGE_KEY, state.accessToken);
  } else {
    window.localStorage.removeItem(ACCESS_TOKEN_STORAGE_KEY);
  }
  if (state.refreshToken) {
    window.localStorage.setItem(REFRESH_TOKEN_STORAGE_KEY, state.refreshToken);
  } else {
    window.localStorage.removeItem(REFRESH_TOKEN_STORAGE_KEY);
  }
  if (state.user) {
    window.localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(state.user));
  } else {
    window.localStorage.removeItem(USER_STORAGE_KEY);
  }
};

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [state, setState] = useState<AuthState>({
    user: null,
    accessToken: null,
    refreshToken: null
  });
  const [isInitializing, setIsInitializing] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const accessTokenRef = useRef<string | null>(null);
  const refreshTokenRef = useRef<string | null>(null);

  const applyAuthState = useCallback((updater: (prev: AuthState) => AuthState) => {
    setState((prev) => {
      const nextState = updater(prev);
      accessTokenRef.current = nextState.accessToken;
      refreshTokenRef.current = nextState.refreshToken;
      persistAuthState(nextState);
      return nextState;
    });
  }, []);

  const resetAuthState = useCallback(() => {
    applyAuthState(() => ({ user: null, accessToken: null, refreshToken: null }));
  }, [applyAuthState]);

  const refreshTokens = useCallback(async () => {
    const refreshToken = refreshTokenRef.current;
    if (!refreshToken) {
      throw new Error('Refresh token is missing');
    }
    const tokens = await authApi.refresh(refreshToken);
    applyAuthState((prev) => ({
      user: prev.user,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken
    }));
    return tokens.accessToken;
  }, [applyAuthState]);

  const handleRefreshFailure = useCallback(() => {
    resetAuthState();
  }, [resetAuthState]);

  useEffect(() => {
    accessTokenRef.current = state.accessToken;
    refreshTokenRef.current = state.refreshToken;
  }, [state.accessToken, state.refreshToken]);

  useEffect(() => {
    httpClient.setTokenManager({
      getAccessToken: () => accessTokenRef.current,
      getRefreshToken: () => refreshTokenRef.current,
      refreshTokens,
      onRefreshFailure: handleRefreshFailure
    });
    return () => {
      httpClient.setTokenManager(null);
    };
  }, [handleRefreshFailure, refreshTokens]);

  useEffect(() => {
    const initialize = async () => {
      if (typeof window === 'undefined') {
        return;
      }
      const storedTokens = loadStoredTokens();
      const storedUser = loadStoredUser();

      if (storedTokens.accessToken && storedTokens.refreshToken && storedUser) {
        applyAuthState(() => ({
          user: storedUser,
          accessToken: storedTokens.accessToken,
          refreshToken: storedTokens.refreshToken
        }));
        try {
          await authApi.profile();
        } catch (error) {
          console.warn('[AuthProvider] Failed to validate stored session, resetting.', error);
          resetAuthState();
        }
      } else {
        resetAuthState();
      }
    };

    void initialize().finally(() => setIsInitializing(false));
  }, [applyAuthState, resetAuthState]);

  const login = useCallback(
    async ({ email, password }: Credentials) => {
      setIsSubmitting(true);
      try {
        const { user, tokens } = await authApi.login(email, password);
        applyAuthState(() => ({
          user,
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken
        }));
      } finally {
        setIsSubmitting(false);
      }
    },
    [applyAuthState]
  );

  const logout = useCallback(async () => {
    const refreshToken = refreshTokenRef.current;
    try {
      if (refreshToken) {
        await authApi.logout(refreshToken);
      }
    } catch (error) {
      console.warn('[AuthProvider] Logout API call failed.', error);
    } finally {
      resetAuthState();
    }
  }, [resetAuthState]);

  const value = useMemo<AuthContextValue>(
    () => ({
      user: state.user,
      accessToken: state.accessToken,
      refreshToken: state.refreshToken,
      isAuthenticated: Boolean(state.accessToken && state.refreshToken && state.user),
      isInitializing,
      isSubmitting,
      login,
      logout
    }),
    [isInitializing, isSubmitting, login, logout, state]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return ctx;
};
