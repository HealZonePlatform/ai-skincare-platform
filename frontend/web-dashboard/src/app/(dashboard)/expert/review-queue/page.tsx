'use client';

import { Filter } from 'lucide-react';
import { ReviewQueueCard } from '@/components/dashboard/ReviewQueueCard';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable, type ColumnConfig } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useReviews } from '@/hooks/useReviews';
import type { ReviewEntry } from '@/types/review';

const PRIORITY_OPTIONS = [
  { value: 'all', label: 'Tat ca' },
  { value: 'urgent', label: 'Khan cap' },
  { value: 'high', label: 'Uu tien cao' },
  { value: 'medium', label: 'Uu tien vua' },
  { value: 'low', label: 'Uu tien thap' }
] as const;

const STATUS_OPTIONS = [
  { value: 'all', label: 'Tat ca' },
  { value: 'pending_review', label: 'Cho chuyen gia' },
  { value: 'pending_approval', label: 'Cho admin' },
  { value: 'approved', label: 'Da duyet' },
  { value: 'rejected', label: 'Tu choi' }
] as const;

const LoadingState = ({ message }: { message: string }) => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-sm text-slate-500">
    <div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-200 border-t-brand" />
    <p>{message}</p>
  </div>
);

const ErrorState = ({ message, onRetry }: { message: string; onRetry: () => void }) => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-center text-sm text-slate-500">
    <p>{message}</p>
    <Button variant="outline" onClick={onRetry}>
      Thu lai
    </Button>
  </div>
);

const TABLE_COLUMNS: ColumnConfig<ReviewEntry>[] = [
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
    key: 'submittedAt',
    label: 'Ngay gui',
    render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
  }
];

export default function ExpertReviewQueuePage() {
  const {
    queue,
    upcoming,
    filters,
    setPriorityFilter,
    setStatusFilter,
    isLoading,
    isFetching,
    isError,
    error,
    refetch
  } = useReviews();

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Hang doi danh gia</h1>
          <p className="text-sm text-slate-500">
            Loc theo muc uu tien va trang thai xu ly de tap trung vao cac ho so can thiet.
          </p>
        </div>
        <Button variant="secondary">
          <Filter className="h-4 w-4" />
          Bo loc nang cao
        </Button>
      </section>

      <section className="grid gap-6 lg:grid-cols-[1.6fr_1fr]">
        <Card>
          <CardHeader className="flex flex-col gap-4">
            <div className="flex flex-wrap gap-2">
              {PRIORITY_OPTIONS.map((option) => (
                <button
                  key={option.value}
                  type="button"
                  onClick={() => setPriorityFilter(option.value)}
                  className={`inline-flex items-center rounded-full border px-4 py-2 text-sm transition ${
                    filters.priority === option.value
                      ? 'border-brand bg-brand text-white shadow-soft'
                      : 'border-slate-200 bg-white text-slate-600 hover:border-brand hover:text-brand'
                  }`}
                >
                  {option.label}
                </button>
              ))}
            </div>
            <div className="flex flex-wrap gap-2">
              {STATUS_OPTIONS.map((option) => (
                <button
                  key={option.value}
                  type="button"
                  onClick={() => setStatusFilter(option.value as typeof filters.status)}
                  className={`inline-flex items-center rounded-full border px-4 py-2 text-sm transition ${
                    filters.status === option.value
                      ? 'border-brand bg-brand/10 text-brand'
                      : 'border-slate-200 bg-white text-slate-600 hover:border-brand hover:text-brand'
                  }`}
                >
                  {option.label}
                </button>
              ))}
            </div>
          </CardHeader>
          <CardContent className="grid gap-4">
            {isError ? (
              <ErrorState
                message={error instanceof Error ? error.message : 'Khong the tai hang doi danh gia.'}
                onRetry={() => refetch()}
              />
            ) : isLoading ? (
              <LoadingState message="Dang tai hang doi danh gia..." />
            ) : queue.length === 0 ? (
              <p className="rounded-2xl bg-slate-100 p-6 text-center text-sm text-slate-500">
                Khong co san pham nao phu hop voi bo loc hien tai.
              </p>
            ) : (
              queue.map((review) => <ReviewQueueCard key={review.id} review={review} />)
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>San pham sap den han</CardTitle>
            <CardDescription>
              AI goi y thu tu uu tien dua tren rui ro va tiem nang cua tung ho so.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {upcoming.length === 0 ? (
              <p className="rounded-2xl border border-slate-100 p-4 text-sm text-slate-500">
                Hien tai khong co de xuat nao tu he thong.
              </p>
            ) : (
              upcoming.map((review) => (
                <div key={review.id} className="rounded-2xl border border-slate-100 p-4">
                  <div className="flex items-start justify-between">
                    <div>
                      <p className="text-sm font-semibold text-slate-800">{review.productName}</p>
                      <p className="text-xs text-slate-500">{review.partnerName}</p>
                    </div>
                    <Badge className="bg-brand/10 text-brand">AI score {review.aiScore}</Badge>
                  </div>
                  <div className="mt-3 flex items-center justify-between text-xs text-slate-500">
                    <span>Gui: {new Date(review.submittedAt).toLocaleString('vi-VN')}</span>
                    <StatusPill status={review.status} />
                  </div>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </section>

      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Ho so gan day</CardTitle>
              <CardDescription>Cac lan tuong tac gan nhat cua chuyen gia.</CardDescription>
            </div>
            {isFetching ? (
              <span className="inline-flex items-center gap-2 text-xs text-slate-400">
                <span className="h-2 w-2 animate-ping rounded-full bg-brand" />
                Dang dong bo...
              </span>
            ) : null}
          </div>
        </CardHeader>
        <CardContent>
          {isError ? (
            <ErrorState
              message={error instanceof Error ? error.message : 'Khong the tai nhat ky tuong tac.'}
              onRetry={() => refetch()}
            />
          ) : isLoading ? (
            <LoadingState message="Dang tai nhat ky tuong tac..." />
          ) : (
            <DataTable
              data={queue}
              columns={TABLE_COLUMNS}
              emptyMessage="Khong co ban ghi nao phu hop."
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
