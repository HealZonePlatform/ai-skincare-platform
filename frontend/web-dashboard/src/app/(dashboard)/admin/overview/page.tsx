'use client';

import { AlertTriangle, BarChart4, Gauge, Lock, Users } from 'lucide-react';
import { StatCard } from '@/components/common/StatCard';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable, type ColumnConfig } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useProducts } from '@/hooks/useProducts';
import { useReviews } from '@/hooks/useReviews';
import { useUsers } from '@/hooks/useUsers';
import type { ReviewEntry } from '@/types/review';
import type { DashboardUser } from '@/types/user';

const alerts = [
  {
    id: 'alert-1',
    title: 'Chua bat 2FA cho ba tai khoan doi tac',
    detail: 'Yeu cau kich hoat bo sung truoc ngay 25/10/2025.'
  },
  {
    id: 'alert-2',
    title: 'Thieu chung tu ISO cho hai san pham pending approval',
    detail: 'Hydra Barrier Cream va Calming Skin Toner can cap nhat tai lieu.'
  }
];

const reviewColumns: ColumnConfig<ReviewEntry>[] = [
  {
    key: 'productName',
    label: 'San pham',
    render: (item) => (
      <div className="flex flex-col">
        <span className="font-medium text-slate-800">{item.productName}</span>
        <span className="text-xs text-slate-500">{item.partnerName}</span>
      </div>
    )
  },
  {
    key: 'priority',
    label: 'Uu tien',
    render: (item) => <Badge className="bg-brand/10 text-brand capitalize">{item.priority}</Badge>
  },
  {
    key: 'status',
    label: 'Trang thai',
    render: (item) => <StatusPill status={item.status} />
  },
  {
    key: 'aiScore',
    label: 'AI score',
    align: 'center',
    sortable: true
  },
  {
    key: 'submittedAt',
    label: 'Thoi gian',
    render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
  }
];

const LoadingBlock = ({ message }: { message: string }) => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-sm text-slate-500">
    <div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-200 border-t-brand" />
    <p>{message}</p>
  </div>
);

const ErrorBlock = ({ message, onRetry }: { message: string; onRetry: () => void }) => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-center text-sm text-slate-500">
    <p>{message}</p>
    <button
      type="button"
      onClick={onRetry}
      className="rounded-full border border-slate-200 px-4 py-2 text-xs font-medium text-slate-600 transition hover:border-brand hover:text-brand"
    >
      Thu lai
    </button>
  </div>
);

export default function AdminOverviewPage() {
  const {
    statusSummary,
    isLoading: productsLoading,
    isError: productsError,
    error: productsErrorValue,
    refetch: refetchProducts
  } = useProducts();

  const {
    queue,
    isLoading: reviewsLoading,
    isError: reviewsError,
    error: reviewsErrorValue,
    refetch: refetchReviews
  } = useReviews();

  const {
    users,
    summary,
    isLoading: usersLoading,
    isError: usersError,
    error: usersErrorValue,
    refetch: refetchUsers
  } = useUsers();

  const pendingCount = statusSummary.pending_review + statusSummary.pending_approval;
  const alertMessage =
    productsError && productsErrorValue instanceof Error ? productsErrorValue.message : undefined;

  return (
    <div className="flex flex-col gap-8">
      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
        <StatCard
          title="San pham cho duyet"
          value={productsLoading ? '...' : `${pendingCount}`}
          change={`${statusSummary.pending_review} cho chuyen gia / ${statusSummary.pending_approval} cho admin`}
          changeLabel="Dang nam trong hang doi"
          icon={Gauge}
        />
        <StatCard
          title="Nguoi dung hoat dong"
          value={usersLoading ? '...' : `${summary.active}`}
          change={`${summary.partner} doi tac, ${summary.expert} chuyen gia`}
          changeLabel="Hoat dong trong 7 ngay"
          icon={Users}
        />
        <StatCard
          title="Canh bao bao mat"
          value="02"
          change="3 tai khoan can bat 2FA"
          changeLabel="Uu tien cao"
          icon={Lock}
          trend="down"
        />
        <StatCard
          title="Ti le hoan tat bao cao"
          value="96%"
          change="+4%"
          changeLabel="Bao cao tuan da gui"
          icon={BarChart4}
        />
      </section>

      <section className="grid gap-6 lg:grid-cols-[1.6fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>Hang doi quyet dinh</CardTitle>
            <CardDescription>Danh sach de xuat moi nhat tu chuyen gia.</CardDescription>
          </CardHeader>
          <CardContent>
            {reviewsError ? (
              <ErrorBlock
                message={
                  reviewsErrorValue instanceof Error
                    ? reviewsErrorValue.message
                    : 'Khong the tai hang doi quyet dinh.'
                }
                onRetry={() => refetchReviews()}
              />
            ) : reviewsLoading ? (
              <LoadingBlock message="Dang tai hang doi quyet dinh..." />
            ) : (
              <DataTable
                data={queue}
                columns={reviewColumns}
                emptyMessage="Khong co de xuat nao phu hop."
              />
            )}
          </CardContent>
        </Card>

        <Card className="border-danger/30 bg-danger/5">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-danger">
              <AlertTriangle className="h-4 w-4" />
              Canh bao he thong
            </CardTitle>
            <CardDescription className="text-slate-600">
              Theo doi cac hang muc can hanh dong ngay.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm text-slate-600">
            {productsError && alertMessage ? (
              <div className="rounded-2xl border border-danger/20 bg-white/70 p-4">
                <p className="font-semibold text-danger">Loi du lieu san pham</p>
                <p className="text-xs text-slate-500">{alertMessage}</p>
                <button
                  type="button"
                  onClick={() => refetchProducts()}
                  className="mt-3 inline-flex items-center rounded-full border border-danger px-3 py-1 text-xs font-semibold text-danger transition hover:bg-danger hover:text-white"
                >
                  Thu tai lai
                </button>
              </div>
            ) : null}
            {alerts.map((alert) => (
              <div key={alert.id} className="rounded-2xl border border-danger/20 bg-white/70 p-4">
                <p className="font-semibold text-slate-800">{alert.title}</p>
                <p className="text-xs text-slate-500">{alert.detail}</p>
              </div>
            ))}
          </CardContent>
        </Card>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Nhat ky truy cap gan day</CardTitle>
          <CardDescription>
            Nam luot dang nhap hoac hoat dong gan nhat de phat hien bat thuong.
          </CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 text-sm text-slate-600">
          {usersError ? (
            <ErrorBlock
              message={
                usersErrorValue instanceof Error
                  ? usersErrorValue.message
                  : 'Khong the tai nhat ky truy cap.'
              }
              onRetry={() => refetchUsers()}
            />
          ) : usersLoading ? (
            <LoadingBlock message="Dang tai nhat ky truy cap..." />
          ) : users.length === 0 ? (
            <p className="rounded-2xl border border-slate-100 bg-white/70 px-4 py-3 text-center text-xs text-slate-500">
              Chua co hoat dong gan day.
            </p>
          ) : (
            users.slice(0, 5).map((user: DashboardUser) => (
              <div
                key={user.id}
                className="flex flex-wrap items-center justify-between gap-2 rounded-2xl border border-slate-100 bg-white/70 px-4 py-3"
              >
                <div>
                  <p className="font-semibold text-slate-800">{user.fullName}</p>
                  <p className="text-xs text-slate-500">{user.email}</p>
                </div>
                <div className="flex items-center gap-3 text-xs text-slate-500">
                  <Badge className="bg-brand/10 text-brand capitalize">{user.role}</Badge>
                  <span>Hoat dong: {new Date(user.lastActiveAt).toLocaleString('vi-VN')}</span>
                </div>
              </div>
            ))
          )}
        </CardContent>
      </Card>
    </div>
  );
}
