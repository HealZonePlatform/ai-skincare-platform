import { Request, Response, NextFunction } from 'express';
import { errors } from 'hz-shared';

export function notFound(_req: Request, _res: Response, next: NextFunction) {
  next(errors.notFound());
}

export function errorHandler(
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction
) {
  if (err instanceof errors.ApiError) {
    return res.status(err.status).json({ message: err.message });
  }

  if (err instanceof Error) {
    console.error('[user-service] Unhandled error:', err);
    return res.status(500).json({ message: 'Internal Server Error' });
  }

  console.error('[user-service] Non-error thrown:', err);
  return res.status(500).json({ message: 'Internal Server Error' });
}
