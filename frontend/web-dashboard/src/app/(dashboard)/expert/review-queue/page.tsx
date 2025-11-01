'use client';

import { Filter } from 'lucide-react';
import { ReviewQueueCard } from '@/components/dashboard/ReviewQueueCard';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useReviews } from '@/hooks/useReviews';

const PRIORITY_OPTIONS = [
  { value: 'all', label: 'Tất cả' },
  { value: 'urgent', label: 'Khẩn cấp' },
  { value: 'high', label: 'Ưu tiên cao' },
  { value: 'medium', label: 'Ưu tiên vừa' },
  { value: 'low', label: 'Ưu tiên thấp' }
] as const;

const STATUS_OPTIONS = [
  { value: 'all', label: 'Tất cả' },
  { value: 'pending_review', label: 'Chờ chuyên gia' },
  { value: 'pending_approval', label: 'Chờ admin' },
  { value: 'approved', label: 'Đã duyệt' },
  { value: 'rejected', label: 'Từ chối' }
] as const;

export default function ExpertReviewQueuePage() {
  const { queue, upcoming, filters, setPriorityFilter, setStatusFilter } = useReviews();

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Hàng đợi ưu tiên</h1>
          <p className="text-sm text-slate-500">
            Lọc theo mức độ ưu tiên và trạng thái để xử lý các sản phẩm mới.
          </p>
        </div>
        <Button variant="secondary">
          <Filter className="h-4 w-4" />
          Bộ lọc nâng cao
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
            {queue.map((review) => (
              <ReviewQueueCard key={review.id} review={review} />
            ))}
            {queue.length === 0 ? (
              <p className="rounded-2xl bg-slate-100 p-6 text-center text-sm text-slate-500">
                Không có sản phẩm nào phù hợp với bộ lọc hiện tại.
              </p>
            ) : null}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Sản phẩm sắp review</CardTitle>
            <CardDescription>AI gợi ý thứ tự ưu tiên dựa trên rủi ro và tiềm năng.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {upcoming.map((review) => (
              <div key={review.id} className="rounded-2xl border border-slate-100 p-4">
                <div className="flex items-start justify-between">
                  <div>
                    <p className="text-sm font-semibold text-slate-800">{review.productName}</p>
                    <p className="text-xs text-slate-500">{review.partnerName}</p>
                  </div>
                  <Badge className="bg-brand/10 text-brand">AI score {review.aiScore}</Badge>
                </div>
                <div className="mt-3 flex items-center justify-between text-xs text-slate-500">
                  <span>Gửi: {new Date(review.submittedAt).toLocaleString('vi-VN')}</span>
                  <StatusPill status={review.status} />
                </div>
              </div>
            ))}
          </CardContent>
        </Card>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Nhật ký tương tác gần nhất</CardTitle>
          <CardDescription>Các cập nhật quan trọng sau mỗi lần đánh giá.</CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            data={queue}
            columns={[
              {
                key: 'productName',
                label: 'Sản phẩm',
                render: (item) => (
                  <div className="flex flex-col">
                    <span className="font-medium text-slate-800">{item.productName}</span>
                    <span className="text-xs text-slate-500">{item.partnerName}</span>
                  </div>
                )
              },
              {
                key: 'priority',
                label: 'Ưu tiên',
                render: (item) => <Badge className="bg-brand/10 text-brand">{item.priority}</Badge>
              },
              {
                key: 'status',
                label: 'Trạng thái',
                render: (item) => <StatusPill status={item.status} />
              },
              {
                key: 'submittedAt',
                label: 'Ngày gửi',
                render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
              }
            ]}
          />
        </CardContent>
      </Card>
    </div>
  );
}
