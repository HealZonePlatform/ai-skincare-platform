'use client';

import { useEffect, useMemo, useState } from 'react';
import type { Route } from 'next';
import { useRouter, useSearchParams } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { useAuth } from '@/providers/AuthProvider';
import { useRole, type DashboardRole } from '@/providers/RoleProvider';

const ROLE_LABELS: Record<DashboardRole, string> = {
  partner: 'Doi tac',
  expert: 'Chuyen gia',
  admin: 'Quan tri'
};

const ROLE_OPTIONS = ['partner', 'expert', 'admin'] as const;

const DEFAULT_ROUTES = {
  partner: '/partner/overview',
  expert: '/expert/review-queue',
  admin: '/admin/overview'
} satisfies Record<DashboardRole, Route>;

const loginSchema = z.object({
  email: z.string().email('Email khong hop le'),
  password: z.string().min(6, 'Mat khau phai co it nhat 6 ky tu'),
  role: z.enum(ROLE_OPTIONS)
});

type LoginFormValues = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { login, isSubmitting, isAuthenticated, isInitializing } = useAuth();
  const { setRole } = useRole();
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors }
  } = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: '',
      password: '',
      role: 'partner'
    }
  });

  const redirectPath = useMemo(() => {
    const redirectParam = searchParams.get('redirect');
    if (redirectParam && redirectParam.startsWith('/')) {
      return redirectParam;
    }
    return null;
  }, [searchParams]);

  useEffect(() => {
    if (isInitializing) {
      return;
    }
    if (isAuthenticated) {
      setRole('partner');
      router.replace(resolveDestination(redirectPath, DEFAULT_ROUTES.partner));
    }
  }, [isAuthenticated, isInitializing, redirectPath, router, setRole]);

  const onSubmit = handleSubmit(async (values) => {
    setErrorMessage(null);
    try {
      await login({ email: values.email, password: values.password });
      setRole(values.role);
      router.replace(resolveDestination(redirectPath, DEFAULT_ROUTES[values.role]));
    } catch (error) {
      const message =
        error instanceof Error ? error.message : 'Dang nhap that bai. Vui long thu lai.';
      setErrorMessage(message);
    }
  });

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-100 px-4 py-8">
      <div className="w-full max-w-md rounded-3xl bg-white p-8 shadow-soft">
        <h1 className="text-2xl font-semibold text-slate-900">Dang nhap</h1>
        <p className="mt-2 text-sm text-slate-600">
          Su dung tai khoan HealZone de truy cap bang dieu khien.
        </p>

        <form className="mt-6 flex flex-col gap-4" onSubmit={onSubmit} noValidate>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Email</span>
            <input
              type="email"
              autoComplete="email"
              placeholder="ban@healzone.ai"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
              disabled={isSubmitting}
              {...register('email')}
            />
            {errors.email ? (
              <span className="text-xs text-danger">{errors.email.message}</span>
            ) : null}
          </label>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Mat khau</span>
            <input
              type="password"
              autoComplete="current-password"
              placeholder="********"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
              disabled={isSubmitting}
              {...register('password')}
            />
            {errors.password ? (
              <span className="text-xs text-danger">{errors.password.message}</span>
            ) : null}
          </label>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Chon vai tro demo</span>
            <select
              className="rounded-xl border border-slate-200 px-4 py-2 text-sm text-slate-700 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
              disabled={isSubmitting}
              {...register('role')}
            >
              {ROLE_OPTIONS.map((value) => (
                <option key={value} value={value}>
                  {ROLE_LABELS[value]}
                </option>
              ))}
            </select>
          </label>
          {errorMessage ? <p className="text-sm text-danger">{errorMessage}</p> : null}
          <button
            type="submit"
            disabled={isSubmitting}
            className="mt-2 inline-flex items-center justify-center rounded-full bg-brand px-6 py-2 text-sm font-medium text-white shadow-soft transition hover:bg-brand-dark disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isSubmitting ? 'Dang dang nhap...' : 'Dang nhap'}
          </button>
        </form>

        <p className="mt-6 text-center text-xs text-slate-500">
          Vui long lien he quan tri vien neu ban can cap tai khoan hoac khoi phuc mat khau.
        </p>
      </div>
    </main>
  );
}
const resolveDestination = (preferred: string | null, fallback: Route): Route => {
  if (preferred && preferred.startsWith('/')) {
    return preferred as Route;
  }
  return fallback;
};
