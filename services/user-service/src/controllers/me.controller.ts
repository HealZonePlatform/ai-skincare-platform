import { Request, Response, NextFunction } from 'express';
import { errors } from 'hz-shared';
import * as svc from '../services/me.service';

const ok = (data: unknown) => ({ data });

const ensureUser = (req: Request) => {
  if (!req.user) {
    throw errors.unauthorized();
  }
  return req.user;
};

export async function getProfile(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const profile = await svc.getProfile(user.id);
    const enriched = { user_id: user.id, email: user.email, ...profile };
    res.json(ok(enriched));
  } catch (error) {
    next(error);
  }
}

export async function updateProfile(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const updated = await svc.updateProfile(user.id, req.body);
    res.json(ok(updated));
  } catch (error) {
    next(error);
  }
}

export async function getHistory(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const parsedLimit = Number.parseInt(String(req.query.limit ?? '30'), 10);
    const parsedOffset = Number.parseInt(String(req.query.offset ?? '0'), 10);
    const limit = Number.isNaN(parsedLimit) ? 30 : parsedLimit;
    const offset = Number.isNaN(parsedOffset) ? 0 : parsedOffset;
    const rows = await svc.getHistory(user.id, limit, offset);
    res.json(ok(rows));
  } catch (error) {
    next(error);
  }
}

export async function getReminders(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const data = await svc.getReminders(user.id);
    res.json(ok(data));
  } catch (error) {
    next(error);
  }
}

export async function updateReminders(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const data = await svc.updateReminders(user.id, req.body);
    res.json(ok(data));
  } catch (error) {
    next(error);
  }
}

export async function getLifestyle(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const data = await svc.getLifestyle(user.id);
    res.json(ok(data));
  } catch (error) {
    next(error);
  }
}

export async function updateLifestyle(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const data = await svc.updateLifestyle(user.id, req.body);
    res.json(ok(data));
  } catch (error) {
    next(error);
  }
}

export async function getGoals(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const goals = await svc.getGoals(user.id);
    res.json(ok(goals));
  } catch (error) {
    next(error);
  }
}

export async function setGoals(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const user = ensureUser(req);
    const goals = await svc.setGoals(user.id, req.body.goals || []);
    res.json(ok(goals));
  } catch (error) {
    next(error);
  }
}
