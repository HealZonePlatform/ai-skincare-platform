// src/utils/response.util.ts
import { Response } from 'express';
import { ApiResponse } from '../types';

class ResponseUtil {
  /**
   * Gửi response thành công
   */
  success<T>(res: Response, message: string, data?: T, statusCode: number = 200): Response {
    const response: ApiResponse<T> = {
      success: true,
      message,
      data
    };
    return res.status(statusCode).json(response);
  }

  /**
   * Gửi response lỗi
   */
  error(res: Response, message: string, error?: string, statusCode: number = 400): Response {
    const response: ApiResponse = {
      success: false,
      message,
      error
    };
    return res.status(statusCode).json(response);
  }

  /**
   * Gửi response lỗi server
   */
  serverError(res: Response, message: string = 'Internal server error', error?: string): Response {
    return this.error(res, message, error, 500);
  }

  /**
   * Gửi response không tìm thấy
   */
  notFound(res: Response, message: string = 'Resource not found'): Response {
    return this.error(res, message, undefined, 404);
  }

  /**
   * Gửi response không được phép
   */
  unauthorized(res: Response, message: string = 'Unauthorized'): Response {
    return this.error(res, message, undefined, 401);
  }

  /**
   * Gửi response cấm truy cập
   */
  forbidden(res: Response, message: string = 'Forbidden'): Response {
    return this.error(res, message, undefined, 403);
  }
}

export default new ResponseUtil();
