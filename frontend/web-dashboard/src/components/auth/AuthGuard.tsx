'use client';

import { useEffect, useMemo, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import type { ReadonlyURLSearchParams } from 'next/navigation';
import { useAuth } from '@/providers/AuthProvider';

type AuthGuardProps = {
  children: React.ReactNode;
};

type LoginRoute = `/login${'' | `?redirect=${string}`}`;

const makeRedirectUrl = (
  pathname: string | null,
  searchParams: ReadonlyURLSearchParams
) => {
  const redirectPath = pathname && pathname !== '/' ? pathname : null;
  const redirectQuery = searchParams.get('redirect');
  if (redirectQuery && redirectQuery.startsWith('/')) {
    return redirectQuery;
  }
  return redirectPath;
};

export const AuthGuard = ({ children }: AuthGuardProps) => {
  const { isInitializing, isAuthenticated } = useAuth();
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [isRedirecting, setIsRedirecting] = useState(false);

  const redirectTarget = useMemo(
    () => makeRedirectUrl(pathname, searchParams),
    [pathname, searchParams]
  );

  useEffect(() => {
    if (isInitializing) {
      return;
    }
    if (!isAuthenticated) {
      setIsRedirecting(true);
      const loginRoute: LoginRoute = redirectTarget
        ? (`/login?redirect=${encodeURIComponent(redirectTarget)}` as LoginRoute)
        : '/login';
      router.replace(loginRoute);
    }
  }, [isAuthenticated, isInitializing, redirectTarget, router]);

  if (isInitializing || isRedirecting) {
    return (
      <div className="flex min-h-[50vh] flex-col items-center justify-center gap-3 text-center text-sm text-slate-500">
        <div className="h-10 w-10 animate-spin rounded-full border-2 border-slate-200 border-t-brand" />
        <p>Tai khoan dang duoc kiem tra. Vui long cho trong giay lat.</p>
      </div>
    );
  }

  if (!isAuthenticated) {
    return null;
  }

  return <>{children}</>;
};
