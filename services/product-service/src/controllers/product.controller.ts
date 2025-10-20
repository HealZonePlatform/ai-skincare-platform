import { Request, Response, NextFunction } from 'express';
import createHttpError from 'http-errors';
import * as productService from '../services/product.service';

export const createProduct = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const product = await productService.createProduct(req.body);
    res.status(201).json(product);
  } catch (error) {
    next(error);
  }
};

export const listProducts = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const result = await productService.listProducts(req.query);
    res.status(200).json({
      data: result.data,
      pagination: {
        total: result.total,
        limit: result.limit,
        offset: result.offset
      }
    });
  } catch (error) {
    next(error);
  }
};

export const getProduct = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const product = await productService.getProductById(req.params.id);
    if (!product) {
      throw new createHttpError.NotFound('Product not found');
    }
    res.status(200).json(product);
  } catch (error) {
    next(error);
  }
};

export const updateProduct = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const product = await productService.updateProduct(
      req.params.id,
      req.body
    );
    if (!product) {
      throw new createHttpError.NotFound('Product not found');
    }
    res.status(200).json(product);
  } catch (error) {
    next(error);
  }
};

export const deleteProduct = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const product = await productService.deleteProduct(req.params.id);
    if (!product) {
      throw new createHttpError.NotFound('Product not found');
    }
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};

export const getCategories = async (
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const categories = await productService.listCategories();
    res.status(200).json(categories);
  } catch (error) {
    next(error);
  }
};
