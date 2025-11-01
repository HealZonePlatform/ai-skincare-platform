import { ProductStatus } from './product';

export type ReviewRecommendation = 'approve' | 'reject' | 'need_more_info';

export type ReviewEntry = {
  id: string;
  productId: string;
  productName: string;
  partnerName: string;
  priority: 'urgent' | 'high' | 'medium' | 'low';
  submittedAt: string;
  status: ProductStatus | 'pending_review';
  aiScore: number;
  expertNotes?: string;
  adminFeedback?: string;
  recommendation?: ReviewRecommendation;
};
