'use client';

import { createContext, ReactNode, useCallback, useContext, useMemo, useState } from 'react';

export type DashboardRole = 'partner' | 'expert' | 'admin';

type RoleContextValue = {
  role: DashboardRole;
  setRole: (role: DashboardRole) => void;
};

const RoleContext = createContext<RoleContextValue | undefined>(undefined);

type RoleProviderProps = {
  initialRole?: DashboardRole;
  children: ReactNode;
};

export const RoleProvider = ({ initialRole = 'partner', children }: RoleProviderProps) => {
  const [role, setRoleState] = useState<DashboardRole>(initialRole);

  const setRole = useCallback((nextRole: DashboardRole) => {
    setRoleState(nextRole);
  }, []);

  const value = useMemo(
    () => ({
      role,
      setRole
    }),
    [role, setRole]
  );

  return <RoleContext.Provider value={value}>{children}</RoleContext.Provider>;
};

export const useRole = () => {
  const ctx = useContext(RoleContext);
  if (!ctx) {
    throw new Error('useRole must be used within a RoleProvider');
  }
  return ctx;
};
