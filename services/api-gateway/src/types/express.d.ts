import type { jwtUtil } from 'hz-shared';

declare module 'express-serve-static-core' {
  interface Request {
    user?: ReturnType<typeof jwtUtil.verify>;
    requestId?: string;
  }
}
