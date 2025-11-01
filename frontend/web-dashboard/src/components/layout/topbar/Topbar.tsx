'use client';

import { Bell, CircleHelp, Menu } from 'lucide-react';
import { useMemo } from 'react';
import { RoleSwitcher } from './RoleSwitcher';
import { type DashboardRole, useRole } from '@/providers/RoleProvider';
import { cn } from '@/lib/utils';

type TopbarProps = {
  onToggleSidebar: () => void;
};

const HEADLINES: Record<DashboardRole, { title: string; subtitle: string }> = {
  partner: {
    title: 'Bảng điều khiển đối tác',
    subtitle: 'Theo dõi hiệu suất sản phẩm & chiến dịch.'
  },
  expert: {
    title: 'Bảng điều khiển chuyên gia',
    subtitle: 'Duyệt sản phẩm ưu tiên và cập nhật phản hồi.'
  },
  admin: {
    title: 'Bảng điều khiển quản trị',
    subtitle: 'Điều hành hệ thống và giám sát bảo mật.'
  }
};

export const Topbar = ({ onToggleSidebar }: TopbarProps) => {
  const { role } = useRole();
  const headline = useMemo(() => HEADLINES[role], [role]);

  return (
    <header className="fixed inset-x-0 top-0 z-40 border-b border-slate-200 bg-white/70 backdrop-blur-xl">
      <div className="mx-auto flex max-w-[1600px] items-center justify-between gap-6 px-4 py-4 lg:px-10">
        <div className="flex flex-1 items-center gap-4">
          <button
            type="button"
            onClick={onToggleSidebar}
            className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-600 transition hover:border-brand hover:text-brand lg:hidden"
          >
            <Menu className="h-5 w-5" />
          </button>
          <div className="hidden lg:flex lg:flex-col">
            <h1 className="text-lg font-semibold text-slate-900">{headline.title}</h1>
            <p className="text-sm text-slate-500">{headline.subtitle}</p>
          </div>
        </div>
        <div className="flex flex-1 items-center justify-center gap-4">
          <div className="hidden w-full max-w-lg items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm text-slate-600 shadow-sm md:flex">
            <span className="text-slate-400">⌕</span>
            <input
              placeholder="Tìm kiếm sản phẩm, phiên tư vấn, người dùng..."
              className="flex-1 bg-transparent outline-none"
            />
          </div>
          <RoleSwitcher />
        </div>
        <div className="flex flex-1 items-center justify-end gap-2">
          <IconButton icon={<CircleHelp className="h-4 w-4" />} label="Help center" />
          <IconButton icon={<Bell className="h-4 w-4" />} label="Notifications" badge="3" />
          <UserProfile />
        </div>
      </div>
    </header>
  );
};

type IconButtonProps = {
  icon: React.ReactNode;
  label: string;
  badge?: string;
};

const IconButton = ({ icon, label, badge }: IconButtonProps) => (
  <button
    type="button"
    className="relative inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-600 transition hover:border-brand hover:text-brand"
    aria-label={label}
  >
    {icon}
    {badge ? (
      <span className="absolute -right-1 -top-1 inline-flex h-5 min-w-[20px] items-center justify-center rounded-full bg-danger px-1 text-[11px] font-semibold text-white">
        {badge}
      </span>
    ) : null}
  </button>
);

const UserProfile = () => (
  <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-3 py-2 shadow-sm">
    <div className="h-10 w-10 rounded-2xl bg-gradient-to-br from-brand via-brand-dark to-slate-900 text-sm font-semibold text-white shadow-soft">
      <div className={cn('flex h-full w-full items-center justify-center')}>LT</div>
    </div>
    <div className="hidden leading-tight sm:block">
      <p className="text-sm font-semibold text-slate-800">Lan Trần</p>
      <p className="text-xs text-slate-500">lan.tran@healzone.ai</p>
    </div>
  </div>
);
