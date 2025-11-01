'use client';

import { useMemo } from 'react';
import { partnerHighlights } from '@/data/mockData';

export const usePartnerInsights = () => {
  const insights = useMemo(() => partnerHighlights, []);

  return {
    insights,
    positive: insights.filter((item) => item.impact === 'positive').length,
    negative: insights.filter((item) => item.impact === 'negative').length
  };
};
