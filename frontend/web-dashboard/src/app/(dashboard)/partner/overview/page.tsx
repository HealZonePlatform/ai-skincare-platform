'use client';

import { Activity, Box, CheckCircle, FileCheck } from 'lucide-react';
import { InsightCard } from '@/components/dashboard/InsightCard';
import { StatCard } from '@/components/common/StatCard';
import { DataTable } from '@/components/table/DataTable';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { usePartnerInsights } from '@/hooks/usePartnerInsights';
import { useProducts } from '@/hooks/useProducts';
import { StatusPill } from '@/components/common/StatusPill';

export default function PartnerOverviewPage() {
  const { statusSummary, topPerformers } = useProducts();
  const { insights } = usePartnerInsights();

  return (
    <div className="flex flex-col gap-8">
      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
        <StatCard
          title="Tổng sản phẩm"
          value={`${statusSummary.total}`}
          change="+3 sản phẩm mới"
          changeLabel="trong 30 ngày gần nhất"
          icon={Box}
        />
        <StatCard
          title="Được duyệt"
          value={`${statusSummary.approved}`}
          change="+12%"
          changeLabel="tăng trưởng tỉ lệ duyệt"
          icon={CheckCircle}
        />
        <StatCard
          title="Chờ chuyên gia"
          value={`${statusSummary.pending_review}`}
          change="3 mục"
          changeLabel="ưu tiên xử lý"
          icon={Activity}
          trend="down"
        />
        <StatCard
          title="Chứng chỉ cập nhật"
          value="92%"
          change="+4%"
          changeLabel="đã hoàn tất cập nhật Q4"
          icon={FileCheck}
        />
      </section>

      <section className="grid gap-6 xl:grid-cols-[2fr_1fr]">
        <Card>
          <CardHeader className="flex flex-col gap-2">
            <CardTitle>Top sản phẩm hiệu suất cao</CardTitle>
            <CardDescription>
              Xếp hạng theo tỷ lệ chuyển đổi và điểm đánh giá trung bình.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <DataTable
              data={topPerformers}
              columns={[
                {
                  key: 'name',
                  label: 'Sản phẩm',
                  render: (product) => (
                    <div className="flex flex-col">
                      <span className="font-medium text-slate-800">{product.name}</span>
                      <span className="text-xs text-slate-500">{product.brand}</span>
                    </div>
                  )
                },
                {
                  key: 'status',
                  label: 'Trạng thái',
                  render: (product) => <StatusPill status={product.status} />
                },
                {
                  key: 'metrics.conversionRate',
                  label: 'Tỉ lệ chuyển đổi',
                  align: 'center',
                  render: (product) => (
                    <span className="font-semibold text-slate-800">
                      {product.metrics.conversionRate}%
                    </span>
                  ),
                  sortable: true
                },
                {
                  key: 'metrics.rating',
                  label: 'Rating',
                  align: 'center',
                  render: (product) => (
                    <span className="font-semibold text-slate-800">
                      {product.metrics.rating.toFixed(1)}
                    </span>
                  ),
                  sortable: true
                }
              ]}
              emptyMessage="Chưa có sản phẩm nổi bật."
            />
          </CardContent>
        </Card>

        <div className="grid gap-4">
          {insights.map((insight) => (
            <InsightCard key={insight.id} insight={insight} />
          ))}
        </div>
      </section>

      <section className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Việc cần làm</CardTitle>
            <CardDescription>Những công việc ưu tiên cho tuần này.</CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="space-y-4 text-sm text-slate-600">
              <li className="flex items-start gap-3 rounded-2xl bg-brand/5 p-4">
                <span className="mt-1 h-2 w-2 rounded-full bg-brand" />
                <div>
                  <p className="font-medium text-slate-800">
                    Bổ sung chứng nhận thử nghiệm ổn định cho Hydra Barrier Cream.
                  </p>
                  <p className="text-xs text-slate-500">Hạn: 23/10/2025</p>
                </div>
              </li>
              <li className="flex items-start gap-3 rounded-2xl bg-success/10 p-4">
                <span className="mt-1 h-2 w-2 rounded-full bg-success" />
                <div>
                  <p className="font-medium text-slate-800">
                    Chuẩn bị chiến dịch ra mắt Radiant Glow Serum tuần tới.
                  </p>
                  <p className="text-xs text-slate-500">Hạn: 26/10/2025</p>
                </div>
              </li>
              <li className="flex items-start gap-3 rounded-2xl bg-warning/10 p-4">
                <span className="mt-1 h-2 w-2 rounded-full bg-warning" />
                <div>
                  <p className="font-medium text-slate-800">
                    Rà soát thành phần sản phẩm mới Ultra Repair Ampoule.
                  </p>
                  <p className="text-xs text-slate-500">Hạn: 28/10/2025</p>
                </div>
              </li>
            </ul>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Nhật ký duyệt gần đây</CardTitle>
            <CardDescription>Thông tin cập nhật từ đội chuyên gia và admin.</CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="space-y-4 text-sm text-slate-600">
              <li>
                <p className="font-semibold text-slate-800">Radiant Glow Serum</p>
                <p className="text-xs text-slate-500">
                  Dr. Minh Đặng đặt câu hỏi về thử nghiệm kích ứng. Cập nhật trước 24/10.
                </p>
              </li>
              <li>
                <p className="font-semibold text-slate-800">Calming Skin Toner</p>
                <p className="text-xs text-slate-500">
                  Đề xuất phê duyệt đã gửi sang Admin. Dự kiến phản hồi trong 12 giờ.
                </p>
              </li>
              <li>
                <p className="font-semibold text-slate-800">Daily Defense Sunscreen SPF50+</p>
                <p className="text-xs text-slate-500">
                  Admin xác nhận chứng chỉ ISO 22716. Sẵn sàng cho chiến dịch Q4.
                </p>
              </li>
            </ul>
          </CardContent>
        </Card>
      </section>
    </div>
  );
}
