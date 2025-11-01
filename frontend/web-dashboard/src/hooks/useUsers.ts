'use client';

import { useMemo, useState } from 'react';
import { mockUsers } from '@/data/mockData';
import { DashboardUserRole } from '@/types/user';

type StatusFilter = 'all' | 'active' | 'invited' | 'suspended';

export const useUsers = () => {
  const [roleFilter, setRoleFilter] = useState<DashboardUserRole | 'all'>('all');
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all');
  const [search, setSearch] = useState('');

  const filteredUsers = useMemo(() => {
    return mockUsers.filter((user) => {
      const roleMatch = roleFilter === 'all' ? true : user.role === roleFilter;
      const statusMatch = statusFilter === 'all' ? true : user.status === statusFilter;
      const searchMatch = search
        ? `${user.fullName} ${user.email} ${user.organisation ?? ''}`
            .toLowerCase()
            .includes(search.toLowerCase())
        : true;
      return roleMatch && statusMatch && searchMatch;
    });
  }, [roleFilter, statusFilter, search]);

  const summary = useMemo(
    () =>
      mockUsers.reduce(
        (acc, user) => {
          acc.total += 1;
          acc[user.role] = (acc[user.role] ?? 0) + 1;
          acc[user.status] = (acc[user.status] ?? 0) + 1;
          return acc;
        },
        {
          total: 0,
          partner: 0,
          expert: 0,
          admin: 0,
          active: 0,
          invited: 0,
          suspended: 0
        } as Record<string, number>
      ),
    []
  );

  return {
    users: filteredUsers,
    search,
    setSearch,
    roleFilter,
    setRoleFilter,
    statusFilter,
    setStatusFilter,
    summary
  };
};
