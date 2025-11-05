import { apiClient } from '@/lib/httpClient';
import { buildQueryString } from '@/lib/queryString';
import type { ReviewEntry, ReviewRecommendation } from '@/types/review';
import type { ProductStatus } from '@/types/product';

type ReviewApiRecord = {
  id?: string;
  _id?: string;
  productId?: string;
  product_id?: string;
  productName?: string;
  product_name?: string;
  partnerName?: string;
  partner_name?: string;
  priority?: ReviewEntry['priority'];
  submittedAt?: string;
  submitted_at?: string;
  status?: ProductStatus | 'pending_review';
  aiScore?: number;
  ai_score?: number;
  expertNotes?: string;
  expert_notes?: string;
  adminFeedback?: string;
  admin_feedback?: string;
  recommendation?: ReviewRecommendation;
};

type ReviewQueueResponse = {
  data?: ReviewApiRecord[];
};

export type ReviewQueueParams = {
  priority?: ReviewEntry['priority'] | 'all';
  status?: ReviewEntry['status'] | 'all';
  limit?: number;
};

const mapReview = (record: ReviewApiRecord): ReviewEntry => {
  const id = record.id ?? record._id ?? `review-${Math.random().toString(36).slice(2, 10)}`;

  return {
    id,
    productId: record.productId ?? record.product_id ?? 'unknown-product',
    productName: record.productName ?? record.product_name ?? 'San pham khong ro',
    partnerName: record.partnerName ?? record.partner_name ?? 'Doi tac khong ro',
    priority: record.priority ?? 'medium',
    submittedAt: record.submittedAt ?? record.submitted_at ?? new Date().toISOString(),
    status: record.status ?? 'pending_review',
    aiScore: record.aiScore ?? record.ai_score ?? 0,
    expertNotes: record.expertNotes ?? record.expert_notes,
    adminFeedback: record.adminFeedback ?? record.admin_feedback,
    recommendation: record.recommendation
  };
};

export const fetchReviewQueue = async (params: ReviewQueueParams = {}) => {
  const query = buildQueryString({
    priority: params.priority !== 'all' ? params.priority : undefined,
    status: params.status !== 'all' ? params.status : undefined,
    limit: params.limit
  });

  const response = await apiClient.get<ReviewQueueResponse>(`/reviews/queue${query}`);
  const records = response.data?.data ?? [];
  return records.map(mapReview);
};
