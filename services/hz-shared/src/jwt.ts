import jwt from 'jsonwebtoken';

export interface JwtUser {
  id?: string;
  sub?: string;
  email?: string;
  role?: string;
  [key: string]: unknown;
}

export function verify(token: string, secret: string): JwtUser {
  return jwt.verify(token, secret) as JwtUser;
}
