export type ProductStatus = 'draft' | 'pending_review' | 'pending_approval' | 'approved' | 'rejected';

export type ProductMetric = {
  views: number;
  conversionRate: number;
  rating: number;
  reviewTimeInHours: number;
};

export type Product = {
  id: string;
  code: string;
  name: string;
  brand: string;
  status: ProductStatus;
  category: string;
  createdAt: string;
  updatedAt: string;
  highlights: string[];
  metrics: ProductMetric;
};
