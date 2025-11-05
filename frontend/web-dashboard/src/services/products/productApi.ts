import { apiClient } from '@/lib/httpClient';
import { buildQueryString } from '@/lib/queryString';
import type { Product, ProductStatus } from '@/types/product';

type ProductApiRecord = {
  _id?: string;
  id?: string;
  code?: string;
  sku?: string;
  name: string;
  description?: string;
  brand?: string;
  category?: string;
  subCategory?: string;
  tags?: string[];
  certifications?: string[];
  ingredients?: Array<{ name: string; percentage?: number; function?: string }>;
  price?: { currency?: string; amount?: number };
  rating?: { average?: number; totalReviews?: number };
  ratings?: { average?: number; totalReviews?: number };
  analytics?: {
    views?: number;
    conversionRate?: number;
    rating?: number;
    reviewTimeInHours?: number;
  };
  metrics?: {
    views?: number;
    conversionRate?: number;
    rating?: number;
    reviewTimeInHours?: number;
  };
  status?: ProductStatus;
  isActive?: boolean;
  isRecommended?: boolean;
  verified?: boolean;
  createdAt?: string;
  updatedAt?: string;
};

type ProductListResponse = {
  data?: ProductApiRecord[];
  pagination?: {
    total?: number;
    limit?: number;
    offset?: number;
  };
};

export type ProductListParams = {
  search?: string;
  category?: string;
  tags?: string[];
  limit?: number;
  offset?: number;
};

const deriveStatus = (record: ProductApiRecord): ProductStatus => {
  if (record.status) {
    return record.status;
  }

  if (record.isActive === false) {
    return 'draft';
  }

  if (record.verified === true) {
    return 'approved';
  }

  if (record.isActive === true && record.isRecommended === false) {
    return 'rejected';
  }

  return 'pending_review';
};

const deriveHighlights = (record: ProductApiRecord) => {
  const highlights = new Set<string>();

  record.certifications?.forEach((item) => highlights.add(item));
  record.tags?.forEach((tag) => highlights.add(tag));

  const firstIngredients = record.ingredients
    ?.map((ingredient) => ingredient.name)
    .filter(Boolean)
    .slice(0, 3);
  firstIngredients?.forEach((name) => highlights.add(name));

  return Array.from(highlights).slice(0, 3);
};

const deriveMetrics = (record: ProductApiRecord): Product['metrics'] => {
  const source = record.metrics ?? record.analytics ?? {};
  const ratingSource = record.rating ?? record.ratings ?? {};

  return {
    views: source.views ?? 0,
    conversionRate: source.conversionRate ?? 0,
    rating: source.rating ?? ratingSource.average ?? 0,
    reviewTimeInHours: source.reviewTimeInHours ?? 0
  };
};

const mapProduct = (record: ProductApiRecord): Product => {
  const id = record.id ?? record._id ?? crypto.randomUUID();
  return {
    id,
    code: record.code ?? record.sku ?? id,
    name: record.name,
    brand: record.brand ?? 'Chua cap nhat',
    status: deriveStatus(record),
    category: record.category ?? 'khac',
    createdAt: record.createdAt ?? new Date().toISOString(),
    updatedAt: record.updatedAt ?? record.createdAt ?? new Date().toISOString(),
    highlights: deriveHighlights(record),
    metrics: deriveMetrics(record)
  };
};

export const fetchProducts = async (params: ProductListParams = {}) => {
  const query = buildQueryString({
    search: params.search,
    category: params.category,
    tags: params.tags,
    limit: params.limit,
    offset: params.offset
  });

  const response = await apiClient.get<ProductListResponse>(`/products${query}`);
  const records = response.data?.data ?? [];

  return {
    items: records.map(mapProduct),
    pagination: {
      total: response.data?.pagination?.total ?? records.length,
      limit: response.data?.pagination?.limit ?? params.limit ?? records.length,
      offset: response.data?.pagination?.offset ?? params.offset ?? 0
    }
  };
};
