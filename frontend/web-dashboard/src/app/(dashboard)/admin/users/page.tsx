'use client';

import { useMemo } from 'react';
import { Filter, Plus } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { ColumnConfig, DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { useUsers } from '@/hooks/useUsers';
import type { DashboardUser, DashboardUserRole } from '@/types/user';

const ROLE_LABELS: Record<DashboardUserRole | 'all', string> = {
  all: 'Tat ca vai tro',
  partner: 'Doi tac',
  expert: 'Chuyen gia',
  admin: 'Quan tri'
};

const STATUS_LABELS: Record<'all' | 'active' | 'invited' | 'suspended', string> = {
  all: 'Trang thai (tat ca)',
  active: 'Dang hoat dong',
  invited: 'Da moi',
  suspended: 'Tam khoa'
};

export default function AdminUsersPage() {
  const {
    users,
    search,
    setSearch,
    roleFilter,
    setRoleFilter,
    statusFilter,
    setStatusFilter,
    summary
  } = useUsers();

  const columns = useMemo<ColumnConfig<DashboardUser>[]>(
    () => [
      {
        key: 'fullName',
        label: 'Nguoi dung',
        render: (user) => (
          <div className="flex flex-col">
            <span className="font-medium text-slate-800">{user.fullName}</span>
            <span className="text-xs text-slate-500">{user.email}</span>
          </div>
        )
      },
      {
        key: 'role',
        label: 'Vai tro',
        render: (user) => (
          <Badge className="bg-brand/10 text-brand capitalize">{user.role}</Badge>
        )
      },
      {
        key: 'organisation',
        label: 'To chuc',
        render: (user) => user.organisation ?? '—'
      },
      {
        key: 'status',
        label: 'Trang thai',
        render: (user) => (
          <StatusPill status={user.status === 'invited' ? 'pending_review' : user.status} />
        )
      },
      {
        key: 'lastActiveAt',
        label: 'Hoat dong gan nhat',
        render: (user) => new Date(user.lastActiveAt).toLocaleString('vi-VN')
      }
    ],
    []
  );

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Quan ly nguoi dung</h1>
          <p className="text-sm text-slate-500">
            Moi nguoi dung moi, phan quyen vai tro va theo doi trang thai truy cap.
          </p>
        </div>
        <Button>
          <Plus className="h-4 w-4" />
          Moi nguoi dung
        </Button>
      </section>

      <Card>
        <CardHeader className="flex flex-col gap-4">
          <div className="flex flex-wrap items-center gap-3">
            <Filter className="h-4 w-4 text-slate-400" />
            <Input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Tim theo ten, email hoac to chuc..."
              className="max-w-sm"
            />
            <Badge className="bg-brand/10 text-brand">{summary.total} tai khoan</Badge>
          </div>
          <div className="flex flex-wrap gap-3">
            {(Object.keys(ROLE_LABELS) as Array<DashboardUserRole | 'all'>).map((role) => (
              <button
                key={role}
                type="button"
                onClick={() => setRoleFilter(role)}
                className={`inline-flex items-center rounded-full border px-4 py-2 text-sm transition ${
                  roleFilter === role
                    ? 'border-brand bg-brand text-white shadow-soft'
                    : 'border-slate-200 bg-white text-slate-600 hover:border-brand hover:text-brand'
                }`}
              >
                {ROLE_LABELS[role]}
              </button>
            ))}
          </div>
          <div className="flex flex-wrap gap-3">
            {(Object.keys(STATUS_LABELS) as Array<'all' | 'active' | 'invited' | 'suspended'>).map(
              (status) => (
                <button
                  key={status}
                  type="button"
                  onClick={() => setStatusFilter(status)}
                  className={`inline-flex items-center rounded-full border px-4 py-2 text-sm transition ${
                    statusFilter === status
                      ? 'border-brand bg-brand/10 text-brand'
                      : 'border-slate-200 bg-white text-slate-600 hover:border-brand hover:text-brand'
                  }`}
                >
                  {STATUS_LABELS[status]}
                </button>
              )
            )}
          </div>
        </CardHeader>
        <CardContent>
          <DataTable
            data={users}
            columns={columns}
            emptyMessage="Khong co nguoi dung nao phu hop voi bo loc."
          />
        </CardContent>
      </Card>
    </div>
  );
}
