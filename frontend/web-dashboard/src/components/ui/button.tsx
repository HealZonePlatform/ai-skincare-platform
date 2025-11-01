'use client';

import { Slot } from '@radix-ui/react-slot';
import { cva, type VariantProps } from 'class-variance-authority';
import { ButtonHTMLAttributes, forwardRef } from 'react';
import { cn } from '@/lib/utils';

const buttonVariants = cva(
  'inline-flex items-center justify-center gap-2 rounded-full border border-transparent px-5 py-2 text-sm font-semibold transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand/50 disabled:cursor-not-allowed disabled:opacity-60',
  {
    variants: {
      variant: {
        primary: 'bg-brand text-white shadow-soft hover:bg-brand-dark',
        secondary: 'bg-white text-slate-700 border-slate-200 hover:border-brand hover:text-brand',
        subtle: 'bg-brand/10 text-brand hover:bg-brand/20',
        outline: 'bg-transparent text-slate-700 border-slate-200 hover:border-brand hover:text-brand',
        ghost: 'bg-transparent text-slate-600 hover:text-brand hover:bg-brand/10'
      },
      size: {
        sm: 'px-3 py-1 text-xs',
        md: 'px-5 py-2 text-sm',
        lg: 'px-6 py-3 text-base'
      }
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md'
    }
  }
);

export type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> &
  VariantProps<typeof buttonVariants> & {
    asChild?: boolean;
  };

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : 'button';
    return (
      <Comp className={cn(buttonVariants({ variant, size }), className)} ref={ref} {...props} />
    );
  }
);

Button.displayName = 'Button';

export { buttonVariants };
