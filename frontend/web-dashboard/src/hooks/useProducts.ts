'use client';

import { useMemo, useState } from 'react';
import { mockProducts } from '@/data/mockData';
import { Product, ProductStatus } from '@/types/product';

const searchPredicate = (product: Product, keyword: string) => {
  if (!keyword) return true;
  const target = `${product.name} ${product.brand} ${product.code}`.toLowerCase();
  return target.includes(keyword.toLowerCase());
};

export const useProducts = () => {
  const [statusFilter, setStatusFilter] = useState<ProductStatus | 'all'>('all');
  const [search, setSearch] = useState('');

  const filteredProducts = useMemo(() => {
    return mockProducts.filter((product) => {
      const matchStatus = statusFilter === 'all' ? true : product.status === statusFilter;
      const matchSearch = searchPredicate(product, search);
      return matchStatus && matchSearch;
    });
  }, [statusFilter, search]);

  const statusSummary = useMemo(() => {
    return mockProducts.reduce(
      (acc, product) => {
        acc.total += 1;
        acc[product.status] = (acc[product.status] ?? 0) + 1;
        return acc;
      },
      {
        total: 0,
        draft: 0,
        pending_review: 0,
        pending_approval: 0,
        approved: 0,
        rejected: 0
      } satisfies Record<ProductStatus | 'total', number>
    );
  }, []);

  const topPerformers = useMemo(
    () => [...mockProducts].sort((a, b) => b.metrics.conversionRate - a.metrics.conversionRate).slice(0, 3),
    []
  );

  return {
    products: filteredProducts,
    totalProducts: mockProducts.length,
    statusFilter,
    setStatusFilter,
    search,
    setSearch,
    statusSummary,
    topPerformers
  };
};
