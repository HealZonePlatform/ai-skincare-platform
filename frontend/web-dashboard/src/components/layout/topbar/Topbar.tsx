'use client';

import { Bell, CircleHelp, LogOut, Menu, Search } from 'lucide-react';
import { useCallback, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { RoleSwitcher } from './RoleSwitcher';
import { type DashboardRole, useRole } from '@/providers/RoleProvider';
import { cn } from '@/lib/utils';
import { useAuth } from '@/providers/AuthProvider';

type TopbarProps = {
  onToggleSidebar: () => void;
};

const HEADLINES: Record<DashboardRole, { title: string; subtitle: string }> = {
  partner: {
    title: 'Bang dieu khien doi tac',
    subtitle: 'Theo doi hieu suat san pham va chien dich.'
  },
  expert: {
    title: 'Bang dieu khien chuyen gia',
    subtitle: 'Duyet san pham uu tien va cap nhat phan hoi.'
  },
  admin: {
    title: 'Bang dieu khien quan tri',
    subtitle: 'Dieu hanh he thong va giam sat bao cao.'
  }
};

export const Topbar = ({ onToggleSidebar }: TopbarProps) => {
  const { role } = useRole();
  const { user, logout } = useAuth();
  const headline = useMemo(() => HEADLINES[role], [role]);
  const router = useRouter();

  const handleLogout = useCallback(async () => {
    try {
      await logout();
    } finally {
      router.replace('/login');
    }
  }, [logout, router]);

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
            <Search className="h-4 w-4 text-slate-400" />
            <input
              placeholder="Tim san pham, phien tu van, nguoi dung..."
              className="flex-1 bg-transparent outline-none"
            />
          </div>
          <RoleSwitcher />
        </div>
        <div className="flex flex-1 items-center justify-end gap-2">
          <IconButton icon={<CircleHelp className="h-4 w-4" />} label="Help center" />
          <IconButton icon={<Bell className="h-4 w-4" />} label="Notifications" badge="3" />
          <UserProfile
            displayName={
              user ? `${user.firstName ?? ''} ${user.lastName ?? ''}`.trim() || user.email : 'Tai khoan'
            }
            email={user?.email ?? ''}
            onLogout={handleLogout}
          />
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

type UserProfileProps = {
  displayName: string;
  email: string;
  onLogout: () => Promise<void>;
};

const getInitials = (value: string) => {
  const segments = value
    .split(' ')
    .map((segment) => segment.trim())
    .filter(Boolean);
  if (segments.length === 0) {
    return 'HZ';
  }
  if (segments.length === 1) {
    return segments[0].slice(0, 2).toUpperCase();
  }
  const first = segments[0].charAt(0);
  const last = segments[segments.length - 1].charAt(0);
  return `${first}${last}`.toUpperCase();
};

const UserProfile = ({ displayName, email, onLogout }: UserProfileProps) => {
  const [isLoggingOut, setIsLoggingOut] = useState(false);

  const handleClick = useCallback(async () => {
    setIsLoggingOut(true);
    try {
      await onLogout();
    } catch (error) {
      console.warn('[Topbar] Logout failed', error);
      setIsLoggingOut(false);
    }
  }, [onLogout]);

  return (
    <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-3 py-2 shadow-sm">
      <div className="h-10 w-10 rounded-2xl bg-gradient-to-br from-brand via-brand-dark to-slate-900 text-sm font-semibold text-white shadow-soft">
        <div className={cn('flex h-full w-full items-center justify-center')}>
          {getInitials(displayName || email)}
        </div>
      </div>
      <div className="hidden leading-tight sm:block">
        <p className="text-sm font-semibold text-slate-800">{displayName}</p>
        <p className="text-xs text-slate-500">{email}</p>
      </div>
      <button
        type="button"
        onClick={handleClick}
        disabled={isLoggingOut}
        className="inline-flex items-center gap-1 rounded-full border border-slate-200 px-3 py-1 text-xs font-medium text-slate-600 transition hover:border-danger hover:bg-danger/5 hover:text-danger disabled:cursor-not-allowed disabled:opacity-60"
      >
        <LogOut className="h-3.5 w-3.5" />
        {isLoggingOut ? 'Dang xuat...' : 'Dang xuat'}
      </button>
    </div>
  );
};
