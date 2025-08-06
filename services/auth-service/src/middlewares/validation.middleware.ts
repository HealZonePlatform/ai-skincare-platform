// src/middlewares/validation.middleware.ts
import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import responseUtil from '../utils/response.util';

export const validateRequest = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const { error } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      const errorMessage = error.details
        .map(detail => detail.message)
        .join(', ');
      
      return responseUtil.error(res, 'Validation failed', errorMessage, 422);
    }

    next();
  };
};
