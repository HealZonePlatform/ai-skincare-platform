// src/middlewares/validation.middleware.ts
import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import responseUtil from '../utils/response.util';

export const validateRequest = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => { // ✅ Thêm : void
    const { error } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      const errorMessage = error.details
        .map(detail => detail.message)
        .join(', ');
      
      responseUtil.error(res, 'Validation failed', errorMessage, 422);
      return; // ✅ Đảm bảo có return trong mọi code path
    }

    next();
    // ✅ Function luôn return void hoặc có explicit return
  };
};

// Alternative validation middleware with async support
export const validateRequestAsync = (schema: Joi.ObjectSchema) => {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { error } = schema.validate(req.body, {
        abortEarly: false,
        stripUnknown: true
      });

      if (error) {
        const errorMessage = error.details
          .map(detail => detail.message)
          .join(', ');
        
        responseUtil.error(res, 'Validation failed', errorMessage, 422);
        return;
      }

      next();
    } catch (err) {
      next(err);
    }
  };
};

// Body, params, and query validation
export const validateBody = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const { error } = schema.validate(req.body);
    if (error) {
      responseUtil.error(res, 'Body validation failed', error.details[0].message, 422);
      return;
    }
    next();
  };
};

export const validateParams = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const { error } = schema.validate(req.params);
    if (error) {
      responseUtil.error(res, 'Params validation failed', error.details[0].message, 422);
      return;
    }
    next();
  };
};

export const validateQuery = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const { error } = schema.validate(req.query);
    if (error) {
      responseUtil.error(res, 'Query validation failed', error.details[0].message, 422);
      return;
    }
    next();
  };
};
