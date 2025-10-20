import { ZodSchema } from 'zod';
import { Request, Response, NextFunction } from 'express';

export function validate(schema: ZodSchema<any>, source: 'body'|'query'|'params' = 'body') {
  return (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse((req as any)[source]);
    if (!result.success) {
      return res.status(400).json({ message: 'Validation failed', errors: result.error.flatten() });
    }
    (req as any)[source] = result.data;
    next();
  };
}
