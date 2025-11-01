'use client';

import { History } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { mockReviews } from '@/data/mockData';

export default function ExpertHistoryPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Lịch sử đánh giá</h1>
          <p className="text-sm text-slate-500">
            Theo dõi quyết định đã gửi và phản hồi từ đội admin.
          </p>
        </div>
        <Badge className="bg-brand/10 text-brand">
          <History className="mr-2 h-3 w-3" />
          {mockReviews.length} lượt review
        </Badge>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Chi tiết phiên đánh giá</CardTitle>
          <CardDescription>
            Ghi lại các đề xuất, phản hồi và trạng thái phê duyệt cuối cùng.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            data={mockReviews}
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
                key: 'status',
                label: 'Trạng thái',
                render: (item) => <StatusPill status={item.status} />
              },
              {
                key: 'recommendation',
                label: 'Đề xuất',
                render: (item) => item.recommendation ?? '—'
              },
              {
                key: 'adminFeedback',
                label: 'Phản hồi Admin',
                render: (item) => item.adminFeedback ?? '—'
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
