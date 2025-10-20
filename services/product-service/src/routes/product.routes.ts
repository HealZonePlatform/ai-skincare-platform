import { Router } from 'express';
import * as productController from '../controllers/product.controller';

const router = Router();

router
  .route('/')
  .get(productController.listProducts)
  .post(productController.createProduct);

router.get('/categories', productController.getCategories);

router
  .route('/:id')
  .get(productController.getProduct)
  .put(productController.updateProduct)
  .delete(productController.deleteProduct);

export default router;
