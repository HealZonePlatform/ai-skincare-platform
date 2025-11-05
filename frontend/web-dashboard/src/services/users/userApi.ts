import { apiClient } from '@/lib/httpClient';
import { buildQueryString } from '@/lib/queryString';
import type { DashboardUser, DashboardUserRole } from '@/types/user';

type UserApiRecord = {
  id?: string;
  _id?: string;
  email: string;
  firstName?: string;
  first_name?: string;
  lastName?: string;
  last_name?: string;
  fullName?: string;
  full_name?: string;
  organisation?: string;
  organization?: string;
  company?: string;
  role?: DashboardUserRole;
  dashboardRole?: DashboardUserRole;
  dashboard_role?: DashboardUserRole;
  status?: 'active' | 'invited' | 'suspended';
  isActive?: boolean;
  is_active?: boolean;
  lastActiveAt?: string;
  last_active_at?: string;
  updatedAt?: string;
  updated_at?: string;
};

type UserListResponse = {
  data?: UserApiRecord[];
  pagination?: {
    total?: number;
    limit?: number;
    offset?: number;
  };
};

export type UserListParams = {
  role?: DashboardUserRole | 'all';
  status?: 'all' | 'active' | 'invited' | 'suspended';
  search?: string;
  limit?: number;
  offset?: number;
};

const deriveStatus = (record: UserApiRecord): DashboardUser['status'] => {
  if (record.status) {
    return record.status;
  }
  const isActive = record.isActive ?? record.is_active;
  if (isActive === false) {
    return 'suspended';
  }
  return 'active';
};

const deriveRole = (record: UserApiRecord): DashboardUserRole => {
  return (
    record.role ??
    record.dashboardRole ??
    record.dashboard_role ??
    ('partner' as DashboardUserRole)
  );
};

const deriveFullName = (record: UserApiRecord) => {
  const explicit = record.fullName ?? record.full_name;
  if (explicit && explicit.trim()) {
    return explicit.trim();
  }
  const parts = [record.firstName ?? record.first_name, record.lastName ?? record.last_name]
    .filter(Boolean)
    .map((value) => value!.trim())
    .filter(Boolean);
  if (parts.length > 0) {
    return parts.join(' ');
  }
  return record.email;
};

const mapUser = (record: UserApiRecord): DashboardUser => {
  const id = record.id ?? record._id ?? `user-${Math.random().toString(36).slice(2, 10)}`;
  return {
    id,
    fullName: deriveFullName(record),
    email: record.email,
    role: deriveRole(record),
    organisation:
      record.organisation ?? record.organization ?? record.company ?? undefined,
    lastActiveAt:
      record.lastActiveAt ??
      record.last_active_at ??
      record.updatedAt ??
      record.updated_at ??
      new Date().toISOString(),
    status: deriveStatus(record)
  };
};

export const fetchUsers = async (params: UserListParams = {}) => {
  const query = buildQueryString({
    role: params.role !== 'all' ? params.role : undefined,
    status: params.status !== 'all' ? params.status : undefined,
    search: params.search,
    limit: params.limit,
    offset: params.offset
  });

  const response = await apiClient.get<UserListResponse>(`/users${query}`);

  const records = Array.isArray(response.data)
    ? (response.data as unknown as UserApiRecord[])
    : response.data?.data ?? [];

  return {
    items: records.map(mapUser),
    pagination: {
      total: response.data?.pagination?.total ?? records.length,
      limit: response.data?.pagination?.limit ?? params.limit ?? records.length,
      offset: response.data?.pagination?.offset ?? params.offset ?? 0
    }
  };
};
