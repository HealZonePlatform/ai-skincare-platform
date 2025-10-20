import { Request, Response, NextFunction } from 'express';
import createHttpError from 'http-errors';
import * as expertService from '../services/expert.service';

export const createExpert = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const expert = await expertService.createExpert(req.body);
    res.status(201).json(expert);
  } catch (error) {
    next(error);
  }
};

export const listExperts = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const experts = await expertService.listExperts(req.query);
    res.status(200).json({
      data: experts.data,
      pagination: {
        total: experts.total,
        limit: experts.limit,
        offset: experts.offset
      }
    });
  } catch (error) {
    next(error);
  }
};

export const getExpert = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const expert = await expertService.getExpertById(req.params.id);
    if (!expert) {
      throw new createHttpError.NotFound('Expert not found');
    }
    res.status(200).json(expert);
  } catch (error) {
    next(error);
  }
};

export const updateExpert = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const expert = await expertService.updateExpert(req.params.id, req.body);
    if (!expert) {
      throw new createHttpError.NotFound('Expert not found');
    }
    res.status(200).json(expert);
  } catch (error) {
    next(error);
  }
};

export const deleteExpert = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const expert = await expertService.deleteExpert(req.params.id);
    if (!expert) {
      throw new createHttpError.NotFound('Expert not found');
    }
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};

export const getSpecialties = async (
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const specialties = await expertService.listSpecialties();
    res.status(200).json(specialties);
  } catch (error) {
    next(error);
  }
};

export const addReview = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const updatedExpert = await expertService.addReview(
      req.params.id,
      req.body
    );
    if (!updatedExpert) {
      throw new createHttpError.NotFound('Expert not found');
    }
    res.status(201).json(updatedExpert);
  } catch (error) {
    next(error);
  }
};

export const listReviews = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const reviews = await expertService.listReviews(req.params.id);
    if (!reviews) {
      throw new createHttpError.NotFound('Expert not found');
    }
    res.status(200).json(reviews);
  } catch (error) {
    next(error);
  }
};

export const removeReview = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const expert = await expertService.removeReview(
      req.params.id,
      req.params.reviewId
    );
    if (!expert) {
      throw new createHttpError.NotFound('Expert or review not found');
    }
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};
