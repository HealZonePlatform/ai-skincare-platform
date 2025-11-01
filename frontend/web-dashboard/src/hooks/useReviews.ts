'use client';

import { useMemo, useState } from 'react';
import { mockReviews } from '@/data/mockData';
import { ReviewEntry } from '@/types/review';

type QueueFilter = {
  priority: 'all' | ReviewEntry['priority'];
  status: 'all' | ReviewEntry['status'];
};

export const useReviews = () => {
  const [filters, setFilters] = useState<QueueFilter>({ priority: 'all', status: 'all' });

  const queue = useMemo(() => {
    return mockReviews.filter((review) => {
      const priorityMatch = filters.priority === 'all' ? true : review.priority === filters.priority;
      const statusMatch = filters.status === 'all' ? true : review.status === filters.status;
      return priorityMatch && statusMatch;
    });
  }, [filters]);

  const upcoming = useMemo(
    () =>
      [...mockReviews]
        .filter((review) => review.status === 'pending_review')
        .sort((a, b) => b.aiScore - a.aiScore)
        .slice(0, 3),
    []
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
    total: mockReviews.length
  };
};
