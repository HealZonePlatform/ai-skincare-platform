'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactNode, useMemo } from 'react';
import { AuthProvider } from './AuthProvider';
import { RoleProvider } from './RoleProvider';

type AppProvidersProps = {
  children: ReactNode;
};

export const AppProviders = ({ children }: AppProvidersProps) => {
  const queryClient = useMemo(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000,
            gcTime: 5 * 60 * 1000,
            retry: 2,
            refetchOnWindowFocus: false,
            refetchOnReconnect: true
          },
          mutations: {
            retry: 1
          }
        }
      }),
    []
  );

  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <RoleProvider>{children}</RoleProvider>
      </AuthProvider>
    </QueryClientProvider>
  );
};
