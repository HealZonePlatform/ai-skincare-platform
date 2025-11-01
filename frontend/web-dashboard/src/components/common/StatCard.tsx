'use client';

import { LucideIcon } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { cn } from '@/lib/utils';

type StatCardProps = {
  title: string;
  value: string;
  changeLabel?: string;
  change?: string;
  icon: LucideIcon;
  trend?: 'up' | 'down' | 'flat';
  className?: string;
};

export const StatCard = ({
  title,
  value,
  change,
  changeLabel,
  icon: Icon,
  trend = 'up',
  className
}: StatCardProps) => {
  return (
    <Card className={cn('relative overflow-hidden', className)}>
      <div className="absolute right-4 top-4 h-16 w-16 rounded-full bg-brand/10 blur-2xl" />
      <div className="flex items-start justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.3em] text-slate-400">{title}</p>
          <p className="mt-3 text-3xl font-semibold text-slate-900">{value}</p>
        </div>
        <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-brand/10 text-brand">
          <Icon className="h-5 w-5" />
        </div>
      </div>
      {change ? (
        <div className="mt-4 flex items-center gap-2 text-sm">
          <span
            className={cn(
              'inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold uppercase tracking-wide',
              trend === 'down'
                ? 'bg-danger/10 text-danger'
                : trend === 'flat'
                  ? 'bg-slate-100 text-slate-600'
                  : 'bg-success/10 text-success'
            )}
          >
            {change}
          </span>
          {changeLabel ? <span className="text-slate-500">{changeLabel}</span> : null}
        </div>
      ) : null}
    </Card>
  );
};
