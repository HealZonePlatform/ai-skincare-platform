'use client';

import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { fetchProducts, type ProductListParams } from '@/services/products/productApi';
import { mockProducts } from '@/data/mockData';
import type { Product, ProductStatus } from '@/types/product';

type StatusSummary = Record<ProductStatus | 'total', number>;

const INITIAL_STATUS_SUMMARY: StatusSummary = {
  total: 0,
  draft: 0,
  pending_review: 0,
  pending_approval: 0,
  approved: 0,
  rejected: 0
};

const searchPredicate = (product: Product, keyword: string) => {
  if (!keyword) {
    return true;
  }
  const target = `${product.name} ${product.brand} ${product.code}`.toLowerCase();
  return target.includes(keyword.toLowerCase());
};

const filterByStatus = (products: Product[], status: ProductStatus | 'all') => {
  if (status === 'all') {
    return products;
  }
  return products.filter((product) => product.status === status);
};

const buildQueryParams = (search: string): ProductListParams => {
  return {
    search: search.trim() || undefined,
    limit: 50
  };
};

export const useProducts = () => {
  const [statusFilter, setStatusFilter] = useState<ProductStatus | 'all'>('all');
  const [search, setSearch] = useState('');

  const query = useQuery({
    queryKey: ['products', { search }],
    queryFn: () => fetchProducts(buildQueryParams(search)),
    select: (result) => result.items,
    placeholderData: (previous) => previous,
    meta: {
      description: 'Fetch product catalogue for dashboard'
    }
  });

  const rawProducts = query.data?.length ? query.data : query.isError ? mockProducts : [];

  const filteredProducts = useMemo(() => {
    const afterStatus = filterByStatus(rawProducts, statusFilter);
    return afterStatus.filter((product) => searchPredicate(product, search));
  }, [rawProducts, statusFilter, search]);

  const statusSummary = useMemo(() => {
    return rawProducts.reduce((summary, product) => {
      summary.total += 1;
      summary[product.status] = (summary[product.status] ?? 0) + 1;
      return summary;
    }, { ...INITIAL_STATUS_SUMMARY });
  }, [rawProducts]);

  const topPerformers = useMemo(
    () =>
      [...rawProducts]
        .sort((a, b) => b.metrics.conversionRate - a.metrics.conversionRate)
        .slice(0, 3),
    [rawProducts]
  );

  return {
    products: filteredProducts,
    totalProducts: rawProducts.length,
    search,
    setSearch,
    statusFilter,
    setStatusFilter,
    statusSummary,
    topPerformers,
    isLoading: query.isLoading,
    isFetching: query.isFetching,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch
  };
};
