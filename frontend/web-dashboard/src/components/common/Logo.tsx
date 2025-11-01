'use client';

import Link from 'next/link';
import { cn } from '@/lib/utils';

type LogoProps = {
  className?: string;
};

export const Logo = ({ className }: LogoProps) => (
  <Link
    href="/"
    className={cn(
      'inline-flex items-center gap-3 rounded-full bg-white/90 px-3 py-1 text-sm font-semibold text-brand shadow-sm ring-1 ring-white/60 transition hover:bg-white',
      className
    )}
  >
    <span className="flex h-9 w-9 items-center justify-center rounded-2xl bg-brand text-white">
      HZ
    </span>
    <span className="flex flex-col leading-tight">
      <span>HealZone</span>
      <span className="text-[11px] font-medium uppercase tracking-[0.28em] text-slate-400">
        Dashboard
      </span>
    </span>
  </Link>
);
