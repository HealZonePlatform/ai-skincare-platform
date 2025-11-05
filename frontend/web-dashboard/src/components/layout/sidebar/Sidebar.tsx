'use client';

import Link from 'next/link';
import type { Route } from 'next';
import { usePathname } from 'next/navigation';
import { useMemo } from 'react';
import { ChevronRight } from 'lucide-react';
import { Logo } from '@/components/common/Logo';
import { navigation } from '@/config/navigation';
import { cn } from '@/lib/utils';
import { useRole } from '@/providers/RoleProvider';

type SidebarProps = {
  open: boolean;
  onClose: () => void;
};

export const Sidebar = ({ open, onClose }: SidebarProps) => {
  const pathname = usePathname();
  const { role } = useRole();

  const sections = useMemo(() => navigation[role] ?? [], [role]);

  return (
    <>
      <div
        role="presentation"
        onClick={onClose}
        className={cn(
          'fixed inset-0 z-40 bg-slate-900/40 backdrop-blur-sm transition-opacity lg:hidden',
          open ? 'pointer-events-auto opacity-100' : 'pointer-events-none opacity-0'
        )}
      />
      <aside
        className={cn(
          'fixed inset-y-0 left-0 z-50 w-72 transform border-r border-slate-200 bg-slate-50/80 px-5 pb-10 pt-8 shadow-soft transition-all duration-300 lg:static lg:translate-x-0',
          open ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        )}
      >
        <div className="flex items-center justify-between">
          <Logo />
          <button
            type="button"
            onClick={onClose}
            className="rounded-full border border-slate-200 p-2 text-slate-500 transition hover:border-brand hover:text-brand lg:hidden"
          >
            <ChevronRight className="h-4 w-4" />
          </button>
        </div>
        <nav className="mt-10 space-y-7">
          {sections.map((section) => (
            <div key={section.label} className="space-y-3">
              <p className="text-xs font-semibold uppercase tracking-[0.3em] text-slate-400">
                {section.label}
              </p>
              <ul className="space-y-2.5">
                {section.items.map((item) => {
                  const isActive = pathname.startsWith(item.href);
                  const Icon = item.icon;
                  return (
                    <li key={item.href}>
                      <Link
                        href={item.href as Route}
                        className={cn(
                          'group block rounded-2xl border border-transparent bg-white/70 p-4 shadow-sm transition hover:border-brand hover:bg-white',
                          isActive && 'border-brand bg-white ring-2 ring-brand/20'
                        )}
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-3">
                            <span
                              className={cn(
                                'flex h-9 w-9 items-center justify-center rounded-2xl bg-brand/10 text-brand transition group-hover:bg-brand group-hover:text-white',
                                isActive && 'bg-brand text-white'
                              )}
                            >
                              <Icon className="h-4 w-4" />
                            </span>
                            <div className="flex flex-col">
                              <span className="text-sm font-semibold text-slate-900">
                                {item.title}
                              </span>
                              {item.description ? (
                                <span className="mt-1 text-xs text-slate-500">{item.description}</span>
                              ) : null}
                            </div>
                          </div>
                          <ChevronRight className="h-4 w-4 text-slate-300 transition group-hover:text-brand" />
                        </div>
                        {item.badgeText ? (
                          <span className="mt-3 inline-flex items-center rounded-full bg-brand/10 px-3 py-1 text-[11px] font-medium uppercase tracking-wide text-brand">
                            {item.badgeText}
                          </span>
                        ) : null}
                      </Link>
                    </li>
                  );
                })}
              </ul>
            </div>
          ))}
        </nav>
        <footer className="mt-10 rounded-2xl bg-gradient-to-br from-brand/10 via-white to-white p-5 text-xs text-slate-500">
          <p className="font-semibold text-slate-700">Chế độ hiện tại</p>
          <p className="mt-1 capitalize text-slate-600">Vai trò: {role}</p>
          <p className="mt-3 text-[11px] leading-relaxed text-slate-500">
            Module dashboard được cấu hình theo từng vai trò. Thay đổi vai trò tại thanh điều hướng
            phía trên để xem các chức năng tương ứng.
          </p>
        </footer>
      </aside>
    </>
  );
};
