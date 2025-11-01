'use client';

import { ShieldCheck, ThumbsDown, ThumbsUp } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { mockReviews } from '@/data/mockData';

const pendingApprovals = mockReviews.filter((review) => review.status === 'pending_approval');

export default function AdminApprovalsPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Phê duyệt sản phẩm</h1>
          <p className="text-sm text-slate-500">
            Xử lý đề xuất từ chuyên gia và gửi thông báo chính thức cho đối tác.
          </p>
        </div>
        <Badge className="bg-brand/10 text-brand">
          <ShieldCheck className="mr-2 h-4 w-4" />
          {pendingApprovals.length} đang chờ
        </Badge>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Đề xuất chờ duyệt</CardTitle>
          <CardDescription>
            Các đề xuất approve/reject từ chuyên gia cần xác nhận cuối cùng.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <DataTable
            data={pendingApprovals}
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
                render: (item) => (
                  <Badge className="bg-brand/10 text-brand capitalize">{item.priority}</Badge>
                )
              },
              {
                key: 'recommendation',
                label: 'Đề xuất',
                render: (item) => (
                  <span className="capitalize text-slate-700">{item.recommendation ?? '—'}</span>
                )
              },
              {
                key: 'status',
                label: 'Trạng thái',
                render: (item) => <StatusPill status={item.status} />
              },
              {
                key: 'submittedAt',
                label: 'Thời gian',
                render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
              }
            ]}
            emptyMessage="Không có đề xuất nào chờ phê duyệt."
          />
          <div className="flex flex-wrap items-center gap-3 text-xs text-slate-500">
            <Button variant="primary">
              <ThumbsUp className="h-4 w-4" />
              Duyệt tất cả
            </Button>
            <Button variant="secondary">
              <ThumbsDown className="h-4 w-4" />
              Từ chối tất cả
            </Button>
            <span className="text-slate-400">* Demo: hành động thực hiện ở backend.</span>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Lịch sử quyết định</CardTitle>
          <CardDescription>Các lần phê duyệt/từ chối gần nhất.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 text-sm text-slate-600">
          <p>
            • 19/10/2025 20:30 - Approve Calming Skin Toner (theo đề xuất Expert).<br />
            • 17/10/2025 09:20 - Reject Overnight Repair Mask (thiếu chứng nhận an toàn).<br />
            • 15/10/2025 18:10 - Approve Daily Defense Sunscreen (đã hoàn tất chứng chỉ ISO).
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
