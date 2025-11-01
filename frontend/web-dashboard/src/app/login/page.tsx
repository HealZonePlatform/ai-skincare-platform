'use client';

import { FormEvent, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useRole, type DashboardRole } from '@/providers/RoleProvider';

const ROLE_LABELS: Record<DashboardRole, string> = {
  partner: 'Doi tac',
  expert: 'Chuyen gia',
  admin: 'Quan tri'
};

const DEFAULT_ROUTES: Record<DashboardRole, string> = {
  partner: '/partner/overview',
  expert: '/expert/review-queue',
  admin: '/admin/overview'
};

export default function LoginPage() {
  const router = useRouter();
  const { setRole } = useRole();
  const [role, setSelectedRole] = useState<DashboardRole>('partner');

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setRole(role);
    router.push(DEFAULT_ROUTES[role]);
  };

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-100 px-4 py-8">
      <div className="w-full max-w-md rounded-3xl bg-white p-8 shadow-soft">
        <h1 className="text-2xl font-semibold text-slate-900">Dang nhap</h1>
        <p className="mt-2 text-sm text-slate-600">
          Chon vai tro de truy cap cac module quan ly tren HealZone Dashboard.
        </p>
        <form className="mt-6 flex flex-col gap-4" onSubmit={handleSubmit}>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Email</span>
            <input
              type="email"
              placeholder="ban@healzone.ai"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
              required
            />
          </label>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Mat khau</span>
            <input
              type="password"
              placeholder="********"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
              required
            />
          </label>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Chon vai tro demo</span>
            <select
              value={role}
              onChange={(event) => setSelectedRole(event.target.value as DashboardRole)}
              className="rounded-xl border border-slate-200 px-4 py-2 text-sm text-slate-700 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
            >
              {(Object.keys(ROLE_LABELS) as DashboardRole[]).map((value) => (
                <option key={value} value={value}>
                  {ROLE_LABELS[value]}
                </option>
              ))}
            </select>
          </label>
          <button
            type="submit"
            className="mt-2 inline-flex items-center justify-center rounded-full bg-brand px-6 py-2 text-sm font-medium text-white shadow-soft transition hover:bg-brand-dark"
          >
            Tiep tuc
          </button>
          <p className="text-center text-xs text-slate-500">
            Dang nhap that se duoc tich hop thong qua Auth Service o cac giai doan tiep theo.
          </p>
        </form>
      </div>
    </main>
  );
}
