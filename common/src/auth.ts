import jwt from 'jsonwebtoken';
import { env } from './env';

export type JwtPayload = { userId: string };

export function signToken(payload: JwtPayload) {
  return jwt.sign(payload, env.jwtSecret, { expiresIn: '1d' });
}

export function verifyToken(token: string): JwtPayload {
  return jwt.verify(token, env.jwtSecret) as JwtPayload;
}
