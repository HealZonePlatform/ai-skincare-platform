'use client';

import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { fetchReviewQueue } from '@/services/reviews/reviewApi';
import { mockReviews } from '@/data/mockData';
import type { ReviewEntry } from '@/types/review';

type QueueFilter = {
  priority: 'all' | ReviewEntry['priority'];
  status: 'all' | ReviewEntry['status'];
};

const applyFilters = (reviews: ReviewEntry[], filters: QueueFilter) => {
  return reviews.filter((review) => {
    const matchPriority = filters.priority === 'all' || review.priority === filters.priority;
    const matchStatus = filters.status === 'all' || review.status === filters.status;
    return matchPriority && matchStatus;
  });
};

export const useReviews = () => {
  const [filters, setFilters] = useState<QueueFilter>({ priority: 'all', status: 'all' });

  const query = useQuery({
    queryKey: ['reviews', filters],
    queryFn: () =>
      fetchReviewQueue({
        priority: filters.priority,
        status: filters.status,
        limit: 50
      }),
    placeholderData: (previous) => previous,
    meta: {
      description: 'Fetch review queue for expert/admin dashboards'
    }
  });

  const source = query.data?.length ? query.data : query.isError ? mockReviews : [];

  const queue = useMemo(() => applyFilters(source, filters), [source, filters]);

  const upcoming = useMemo(
    () =>
      source
        .filter((review) => review.status === 'pending_review')
        .sort((a, b) => b.aiScore - a.aiScore)
        .slice(0, 3),
    [source]
  );

  const setPriorityFilter = (priority: QueueFilter['priority']) =>
    setFilters((current) => ({ ...current, priority }));

  const setStatusFilter = (status: QueueFilter['status']) =>
    setFilters((current) => ({ ...current, status }));

  return {
    queue,
    upcoming,
    filters,
    setPriorityFilter,
    setStatusFilter,
    total: source.length,
    isLoading: query.isLoading,
    isFetching: query.isFetching,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch
  };
};
