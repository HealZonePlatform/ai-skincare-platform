import { Request, type Response, NextFunction } from 'express';
import { errors, jwtUtil } from 'hz-shared';
import { config } from '../config';

export function requireAuth(req: Request, _res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return next(errors.unauthorized());
  }

  const token = header.substring('Bearer '.length);
  try {
    const payload = jwtUtil.verify(token, config.jwtSecret);
    const id = payload.id ?? payload.sub;
    if (!id || typeof id !== 'string') {
      return next(errors.unauthorized());
    }
    req.user = {
      ...payload,
      id
    };
    return next();
  } catch {
    return next(errors.unauthorized());
  }
}
