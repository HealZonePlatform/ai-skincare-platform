import jwt from 'jsonwebtoken';

export interface JwtUser { id: string; email?: string; role?: string }

export function verify(token: string, secret: string): JwtUser {
  return jwt.verify(token, secret) as JwtUser;
}
