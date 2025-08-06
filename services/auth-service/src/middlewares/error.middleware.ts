// src/middlewares/error.middleware.ts
import { Request, Response, NextFunction } from 'express';
import responseUtil from '../utils/response.util';

interface CustomError extends Error {
  statusCode?: number;
  code?: string;
}

export const errorHandler = (
  error: CustomError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  console.error('Error:', {
    message: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });

  // Duplicate email error (PostgreSQL)
  if (error.code === '23505') {
    responseUtil.error(res, 'Email already exists', 'This email is already registered', 409);
    return;
  }

  // Validation error
  if (error.name === 'ValidationError') {
    responseUtil.error(res, 'Validation failed', error.message, 422);
    return;
  }

  // JWT errors
  if (error.name === 'JsonWebTokenError') {
    responseUtil.unauthorized(res, 'Invalid token');
    return;
  }

  if (error.name === 'TokenExpiredError') {
    responseUtil.unauthorized(res, 'Token has expired');
    return;
  }

  // Database connection error
  if (error.code === 'ECONNREFUSED') {
    responseUtil.serverError(res, 'Database connection failed');
    return;
  }

  // Default server error
  const statusCode = error.statusCode || 500;
  const message = statusCode === 500 ? 'Internal server error' : error.message;
  
  responseUtil.error(res, message, process.env.NODE_ENV === 'development' ? error.message : undefined, statusCode);
};
