import { Router } from 'express';
import * as expertController from '../controllers/expert.controller';

const router = Router();

router
  .route('/')
  .get(expertController.listExperts)
  .post(expertController.createExpert);

router.get('/specialties', expertController.getSpecialties);

router
  .route('/:id')
  .get(expertController.getExpert)
  .put(expertController.updateExpert)
  .delete(expertController.deleteExpert);

router
  .route('/:id/reviews')
  .get(expertController.listReviews)
  .post(expertController.addReview);

router.delete('/:id/reviews/:reviewId', expertController.removeReview);

export default router;
