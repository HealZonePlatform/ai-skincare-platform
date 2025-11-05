'use client';

import { ShieldCheck, ThumbsDown, ThumbsUp } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable, type ColumnConfig } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useReviews } from '@/hooks/useReviews';
import type { ReviewEntry } from '@/types/review';

const columns: ColumnConfig<ReviewEntry>[] = [
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
    key: 'recommendation',
    label: 'De xuat',
    render: (item) => (
      <span className="capitalize text-slate-700">{item.recommendation ?? 'Chua co'}</span>
    )
  },
  {
    key: 'status',
    label: 'Trang thai',
    render: (item) => <StatusPill status={item.status} />
  },
  {
    key: 'submittedAt',
    label: 'Thoi gian',
    render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
  }
];

export default function AdminApprovalsPage() {
  const {
    queue,
    isLoading,
    isError,
    error,
    refetch,
    isFetching
  } = useReviews();

  const pendingApprovals = queue.filter((review) => review.status === 'pending_approval');

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Phe duyet san pham</h1>
          <p className="text-sm text-slate-500">
            Xu ly de xuat tu chuyen gia va gui thong bao chinh thuc cho doi tac.
          </p>
        </div>
        <Badge className="bg-brand/10 text-brand">
          <ShieldCheck className="mr-2 h-4 w-4" />
          {pendingApprovals.length} dang cho
        </Badge>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>De xuat cho phe duyet</CardTitle>
          <CardDescription>
            Danh sach de xuat approve/reject tu chuyen gia can xac nhan cuoi cung.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {isError ? (
            <div className="rounded-2xl border border-danger/20 bg-danger/5 p-6 text-center text-sm text-slate-600">
              <p>
                {error instanceof Error ? error.message : 'Khong the tai danh sach de xuat.'}
              </p>
              <Button variant="outline" onClick={() => refetch()} className="mt-4">
                Thu lai
              </Button>
            </div>
          ) : isLoading ? (
            <div className="flex flex-col items-center justify-center gap-3 py-10 text-sm text-slate-500">
              <div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-200 border-t-brand" />
              <p>Dang tai de xuat cho phe duyet...</p>
            </div>
          ) : (
            <DataTable
              data={pendingApprovals}
              columns={columns}
              emptyMessage="Khong co de xuat nao dang cho phe duyet."
            />
          )}
          <div className="flex flex-wrap items-center gap-3 text-xs text-slate-500">
            <Button variant="primary" disabled={pendingApprovals.length === 0 || isFetching}>
              <ThumbsUp className="h-4 w-4" />
              Duyet tat ca
            </Button>
            <Button variant="secondary" disabled={pendingApprovals.length === 0 || isFetching}>
              <ThumbsDown className="h-4 w-4" />
              Tu choi tat ca
            </Button>
            <span className="text-slate-400">
              * Demo: thao tac thuc te se duoc tich hop backend.
            </span>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Lich su quyet dinh</CardTitle>
          <CardDescription>Cac lan phe duyet/tu choi gan nhat.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 text-sm text-slate-600">
          <p>
            19/10/2025 20:30 - Approve Calming Skin Toner (theo de xuat chuyen gia).
            <br />
            17/10/2025 09:20 - Reject Overnight Repair Mask (thieu chung nhan an toan).
            <br />
            15/10/2025 18:10 - Approve Daily Defense Sunscreen (da hoan tat chung nhan ISO).
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
