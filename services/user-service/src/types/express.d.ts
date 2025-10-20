import { jwtUtil } from 'hz-shared';

declare module 'express-serve-static-core' {
  interface Request {
    user?: jwtUtil.JwtUser;
  }
}
