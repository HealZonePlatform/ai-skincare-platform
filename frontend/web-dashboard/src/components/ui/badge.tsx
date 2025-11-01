'use client';

import { cva, type VariantProps } from 'class-variance-authority';
import { HTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

const badgeVariants = cva(
  'inline-flex items-center rounded-full border border-transparent px-3 py-1 text-[11px] font-semibold uppercase tracking-wider',
  {
    variants: {
      variant: {
        default: 'bg-brand text-white',
        success: 'bg-success/10 text-success border-success/30',
        info: 'bg-info/10 text-info border-info/30',
        warning: 'bg-warning/10 text-warning border-warning/30',
        danger: 'bg-danger/10 text-danger border-danger/30',
        muted: 'bg-slate-100 text-slate-500 border-slate-200'
      }
    },
    defaultVariants: {
      variant: 'default'
    }
  }
);

type BadgeProps = HTMLAttributes<HTMLSpanElement> & VariantProps<typeof badgeVariants>;

export const Badge = ({ className, variant, ...props }: BadgeProps) => (
  <span className={cn(badgeVariants({ variant }), className)} {...props} />
);
