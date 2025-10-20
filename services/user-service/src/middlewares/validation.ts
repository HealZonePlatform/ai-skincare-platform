import { ZodSchema } from 'zod';
import { validate as sharedValidate } from 'hz-shared';

export const validate = (
  schema: ZodSchema<unknown>,
  source: 'body' | 'query' | 'params' = 'body'
) => sharedValidate.validate(schema, source);
