'use client';

import { useMemo } from 'react';
import { Filter, Plus } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { useUsers } from '@/hooks/useUsers';
import { DashboardUserRole } from '@/types/user';

const ROLE_LABELS: Record<DashboardUserRole | 'all', string> = {
  all: 'Tất cả vai trò',
  partner: 'Đối tác',
  expert: 'Chuyên gia',
  admin: 'Quản trị'
};

const STATUS_LABELS: Record<'all' | 'active' | 'invited' | 'suspended', string> = {
  all: 'Trạng thái (tất cả)',
  active: 'Đang hoạt động',
  invited: 'Đang mời',
  suspended: 'Tạm khóa'
};

export default function AdminUsersPage() {
  const { users, search, setSearch, roleFilter, setRoleFilter, statusFilter, setStatusFilter, summary } =
    useUsers();

  const columns = useMemo(
    () => [
      {
        key: 'fullName',
        label: 'Người dùng',
        render: (user: (typeof users)[number]) => (
          <div className="flex flex-col">
            <span className="font-medium text-slate-800">{user.fullName}</span>
            <span className="text-xs text-slate-500">{user.email}</span>
          </div>
        )
      },
      {
        key: 'role',
        label: 'Vai trò',
        render: (user: (typeof users)[number]) => (
          <Badge className="bg-brand/10 text-brand capitalize">{user.role}</Badge>
        )
      },
      {
        key: 'organisation',
        label: 'Tổ chức',
        render: (user: (typeof users)[number]) => user.organisation ?? '—'
      },
      {
        key: 'status',
        label: 'Trạng thái',
        render: (user: (typeof users)[number]) => (
          <StatusPill status={user.status === 'invited' ? 'pending_review' : user.status} />
        )
      },
      {
        key: 'lastActiveAt',
        label: 'Hoạt động gần nhất',
        render: (user: (typeof users)[number]) => new Date(user.lastActiveAt).toLocaleString('vi-VN')
      }
    ],
    [users]
  );

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Quản lý người dùng</h1>
          <p className="text-sm text-slate-500">
            Mời người dùng mới, phân quyền vai trò và theo dõi trạng thái truy cập.
          </p>
        </div>
        <Button>
          <Plus className="h-4 w-4" />
          Mời người dùng
        </Button>
      </section>

      <Card>
        <CardHeader className="flex flex-col gap-4">
          <div className="flex flex-wrap items-center gap-3">
            <Filter className="h-4 w-4 text-slate-400" />
            <Input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Tìm theo tên, email hoặc tổ chức..."
              className="max-w-sm"
            />
            <Badge className="bg-brand/10 text-brand">{summary.total} tài khoản</Badge>
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
            emptyMessage="Không có người dùng nào phù hợp với bộ lọc hiện tại."
          />
        </CardContent>
      </Card>
    </div>
  );
}
