// src/types/index.ts
import { Request, Response, NextFunction } from 'express'; // ✅ Thêm import NextFunction

export interface AuthenticatedRequest extends Request {
  user?: {
    userId: string;
    email: string;
  };
}

export interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}

export interface DatabaseUser {
  id: string;
  email: string;
  password: string;
  first_name: string;
  last_name: string;
  phone?: string;
  date_of_birth?: Date;
  skin_type?: string;
  is_active: boolean;
  is_verified: boolean;
  created_at: Date;
  updated_at: Date;
}

// Export additional types for route handlers
export type AuthenticatedRouteHandler = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => void | Promise<void>;

// Additional useful types
export type StandardRouteHandler = (
  req: Request,
  res: Response,
  next: NextFunction
) => void | Promise<void>;

export type AsyncRouteHandler = (
  req: Request,
  res: Response,
  next: NextFunction
) => Promise<void>;

export type AuthenticatedAsyncRouteHandler = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => Promise<void>;

// Error handling types
export interface CustomError extends Error {
  statusCode?: number;
  code?: string;
  details?: any;
}

// JWT related types
export interface TokenVerificationResult {
  valid: boolean;
  expired: boolean;
  decoded: any | null;
}

// Pagination types
export interface PaginationQuery {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}
