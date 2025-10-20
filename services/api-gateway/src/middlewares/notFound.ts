import { Request, Response, NextFunction } from 'express';
import { errors } from 'hz-shared';

export function notFound(_req: Request, _res: Response, next: NextFunction) {
  next(errors.notFound());
}
