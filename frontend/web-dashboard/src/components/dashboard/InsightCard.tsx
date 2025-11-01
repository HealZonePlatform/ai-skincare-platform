'use client';

import { Lightbulb, TrendingDown, TrendingUp } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { cn } from '@/lib/utils';
import { InsightHighlight } from '@/types/analytics';

type InsightCardProps = {
  insight: InsightHighlight;
};

const ICON_MAP = {
  positive: TrendingUp,
  negative: TrendingDown,
  neutral: Lightbulb
} as const;

const COLOR_MAP = {
  positive: 'text-success bg-success/10',
  negative: 'text-danger bg-danger/10',
  neutral: 'text-slate-600 bg-slate-100'
} as const;

export const InsightCard = ({ insight }: InsightCardProps) => {
  const Icon = ICON_MAP[insight.impact] ?? Lightbulb;
  return (
    <Card className="flex flex-col gap-3">
      <div className={cn('inline-flex w-fit items-center gap-2 rounded-full px-3 py-1 text-xs font-semibold', COLOR_MAP[insight.impact])}>
        <Icon className="h-4 w-4" />
        <span>{insight.delta}</span>
      </div>
      <h3 className="text-lg font-semibold text-slate-900">{insight.title}</h3>
      <p className="text-sm text-slate-600">{insight.description}</p>
    </Card>
  );
};
