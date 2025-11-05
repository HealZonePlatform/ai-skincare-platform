'use client';

import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { fetchUsers } from '@/services/users/userApi';
import { mockUsers } from '@/data/mockData';
import type { DashboardUser, DashboardUserRole } from '@/types/user';

type StatusFilter = 'all' | 'active' | 'invited' | 'suspended';

type Summary = {
  total: number;
  partner: number;
  expert: number;
  admin: number;
  active: number;
  invited: number;
  suspended: number;
};

const INITIAL_SUMMARY: Summary = {
  total: 0,
  partner: 0,
  expert: 0,
  admin: 0,
  active: 0,
  invited: 0,
  suspended: 0
};

const matchesSearch = (user: DashboardUser, keyword: string) => {
  if (!keyword) {
    return true;
  }
  const target = `${user.fullName} ${user.email} ${user.organisation ?? ''}`.toLowerCase();
  return target.includes(keyword.toLowerCase());
};

export const useUsers = () => {
  const [roleFilter, setRoleFilter] = useState<DashboardUserRole | 'all'>('all');
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all');
  const [search, setSearch] = useState('');

  const query = useQuery({
    queryKey: ['users', { roleFilter, statusFilter, search }],
    queryFn: () =>
      fetchUsers({
        role: roleFilter,
        status: statusFilter,
        search,
        limit: 100
      }),
    select: (result) => result.items,
    placeholderData: (previous) => previous,
    meta: {
      description: 'Fetch dashboard user management list'
    }
  });

  const source = query.data?.length ? query.data : query.isError ? mockUsers : [];

  const users = useMemo(() => {
    return source.filter((user) => {
      const roleMatch = roleFilter === 'all' || user.role === roleFilter;
      const statusMatch = statusFilter === 'all' || user.status === statusFilter;
      const searchMatch = matchesSearch(user, search);
      return roleMatch && statusMatch && searchMatch;
    });
  }, [source, roleFilter, statusFilter, search]);

  const summary = useMemo(() => {
    return source.reduce((acc, user) => {
      acc.total += 1;
      acc[user.role] = (acc[user.role] ?? 0) + 1;
      acc[user.status] = (acc[user.status] ?? 0) + 1;
      return acc;
    }, { ...INITIAL_SUMMARY });
  }, [source]);

  return {
    users,
    search,
    setSearch,
    roleFilter,
    setRoleFilter,
    statusFilter,
    setStatusFilter,
    summary,
    isLoading: query.isLoading,
    isFetching: query.isFetching,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch
  };
};
