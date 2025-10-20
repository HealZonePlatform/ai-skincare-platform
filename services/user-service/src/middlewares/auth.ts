import { Request, Response, NextFunction } from 'express';
import { jwtUtil, errors } from 'hz-shared';
import { env } from '../config/env';

export function requireAuth(
  req: Request,
  _res: Response,
  next: NextFunction
) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return next(errors.unauthorized());
  }
  const token = header.substring('Bearer '.length);
  try {
    const payload = jwtUtil.verify(token, env.JWT_ACCESS_SECRET);
    req.user = payload;
    return next();
  } catch {
    return next(errors.unauthorized());
  }
}
