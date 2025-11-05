'use client';

import { ChangeEvent } from 'react';
import type { Route } from 'next';
import { useRouter } from 'next/navigation';
import { navigation } from '@/config/navigation';
import { type DashboardRole, useRole } from '@/providers/RoleProvider';

const ROLE_LABELS: Record<DashboardRole, string> = {
  partner: 'Đối tác',
  expert: 'Chuyên gia',
  admin: 'Quản trị'
};

export const RoleSwitcher = () => {
  const { role, setRole } = useRole();
  const router = useRouter();

  const handleRoleChange = (event: ChangeEvent<HTMLSelectElement>) => {
    const nextRole = event.target.value as DashboardRole;
    if (!nextRole || nextRole === role) {
      return;
    }

    setRole(nextRole);
    const defaultRoute = navigation[nextRole]?.[0]?.items?.[0]?.href ?? '/';
    router.push(defaultRoute as Route);
  };

  return (
    <label className="flex flex-col text-xs font-semibold uppercase tracking-[0.3em] text-slate-400">
      Vai trò
      <div className="relative mt-2">
        <select
          value={role}
          onChange={handleRoleChange}
          className="w-[180px] appearance-none rounded-2xl border border-slate-200 bg-white py-2 pl-4 pr-9 text-sm font-medium capitalize text-slate-700 shadow-sm transition focus:border-brand focus:outline-none focus:ring-2 focus:ring-brand/40"
        >
          {Object.entries(ROLE_LABELS).map(([value, label]) => (
            <option key={value} value={value}>
              {label}
            </option>
          ))}
        </select>
        <span className="pointer-events-none absolute inset-y-0 right-3 flex items-center text-slate-400">
          ▾
        </span>
      </div>
    </label>
  );
};
