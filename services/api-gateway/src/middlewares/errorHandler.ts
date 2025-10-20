import { Request, Response, NextFunction } from 'express';
import { errors } from 'hz-shared';
import { config } from '../config';

const isProduction = config.nodeEnv === 'production';

export function errorHandler(
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction
) {
  if (res.headersSent) {
    return;
  }

  if (err instanceof errors.ApiError) {
    return res.status(err.status).json({ error: err.message });
  }

  const message =
    err instanceof Error ? err.message : 'Unexpected error occurred';
  if (!isProduction) {
    if (err instanceof Error) {
      console.error('[api-gateway] error:', err);
    } else {
      console.error('[api-gateway] error:', String(err));
    }
  }

  res.status(500).json({ error: message });
}
