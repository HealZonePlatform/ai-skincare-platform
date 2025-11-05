import axios, {
  type AxiosError,
  type AxiosInstance,
  type AxiosRequestConfig,
  type AxiosResponse
} from 'axios';
import { API_BASE_URL, REQUEST_TIMEOUT_MS } from '@/config/env';

type RetryableAxiosRequestConfig = AxiosRequestConfig & {
  _retry?: boolean;
};

type TokenManager = {
  getAccessToken: () => string | null;
  getRefreshToken: () => string | null;
  refreshTokens: () => Promise<string | null>;
  onRefreshFailure: () => void;
};

type PendingRequest = {
  resolve: (value: AxiosResponse) => void;
  reject: (reason?: unknown) => void;
  config: RetryableAxiosRequestConfig;
};

const isAuthUrl = (url?: string) =>
  typeof url === 'string' &&
  (url.includes('/auth/login') ||
    url.includes('/auth/refresh') ||
    url.includes('/auth/register'));

class HttpClient {
  private instance: AxiosInstance;
  private tokenManager: TokenManager | null = null;
  private pendingQueue: PendingRequest[] = [];
  private isRefreshing = false;

  constructor() {
    this.instance = axios.create({
      baseURL: API_BASE_URL,
      timeout: REQUEST_TIMEOUT_MS,
      withCredentials: true
    });

    this.instance.interceptors.request.use((config) => {
      if (!this.tokenManager) {
        return config;
      }
      const token = this.tokenManager.getAccessToken();
      if (token && config && config.headers && !isAuthUrl(config.url)) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    });

    this.instance.interceptors.response.use(
      (response) => response,
      async (error: AxiosError) => this.handleResponseError(error)
    );
  }

  setTokenManager(manager: TokenManager | null) {
    this.tokenManager = manager;
  }

  get axiosInstance() {
    return this.instance;
  }

  private async handleResponseError(error: AxiosError) {
    const status = error.response?.status;
    const originalRequest = error.config as RetryableAxiosRequestConfig | undefined;

    if (
      status !== 401 ||
      !originalRequest ||
      originalRequest._retry ||
      !this.tokenManager ||
      isAuthUrl(originalRequest.url)
    ) {
      return Promise.reject(error);
    }

    if (!this.tokenManager.getRefreshToken()) {
      this.tokenManager.onRefreshFailure();
      return Promise.reject(error);
    }

    if (this.isRefreshing) {
      return new Promise<AxiosResponse>((resolve, reject) => {
        this.pendingQueue.push({ resolve, reject, config: originalRequest });
      });
    }

    originalRequest._retry = true;
    this.isRefreshing = true;

    try {
      const newAccessToken = await this.tokenManager.refreshTokens();
      this.processQueue(null, newAccessToken);

      if (newAccessToken && originalRequest.headers) {
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
      }

      return this.instance(originalRequest);
    } catch (refreshError) {
      this.processQueue(refreshError, null);
      this.tokenManager.onRefreshFailure();
      return Promise.reject(refreshError);
    } finally {
      this.isRefreshing = false;
    }
  }

  private processQueue(error: unknown | null, accessToken: string | null) {
    this.pendingQueue.forEach(({ resolve, reject, config }) => {
      if (error) {
        reject(error);
        return;
      }

      if (accessToken && config.headers) {
        config.headers.Authorization = `Bearer ${accessToken}`;
      }

      this.instance(config)
        .then(resolve)
        .catch(reject);
    });
    this.pendingQueue = [];
  }
}

export const httpClient = new HttpClient();
export const apiClient = httpClient.axiosInstance;
