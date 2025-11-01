'use client';

import { Fragment, useMemo } from 'react';
import { ArrowUpRight, BarChart3, TrendingUp } from 'lucide-react';
import { InsightCard } from '@/components/dashboard/InsightCard';
import { StatCard } from '@/components/common/StatCard';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { usePartnerInsights } from '@/hooks/usePartnerInsights';
import { useProducts } from '@/hooks/useProducts';

const weeklyTrend = [
  { label: 'Tuần 1', submissions: 8, approvals: 4 },
  { label: 'Tuần 2', submissions: 11, approvals: 6 },
  { label: 'Tuần 3', submissions: 7, approvals: 5 },
  { label: 'Tuần 4', submissions: 9, approvals: 7 }
];

export default function PartnerInsightsPage() {
  const { topPerformers, statusSummary } = useProducts();
  const { insights } = usePartnerInsights();

  const approvalRate = useMemo(() => {
    const approved = statusSummary.approved;
    const submitted =
      statusSummary.pending_review +
      statusSummary.pending_approval +
      statusSummary.approved +
      statusSummary.rejected;
    if (submitted === 0) return '0%';
    return `${((approved / submitted) * 100).toFixed(0)}%`;
  }, [statusSummary]);

  const averageConversion = useMemo(() => {
    if (topPerformers.length === 0) return '0%';
    const total = topPerformers.reduce((sum, product) => sum + product.metrics.conversionRate, 0);
    return `${(total / topPerformers.length).toFixed(1)}%`;
  }, [topPerformers]);

  return (
    <div className="flex flex-col gap-8">
      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
        <StatCard
          title="Tỉ lệ phê duyệt"
          value={approvalRate}
          change="+6%"
          changeLabel="so với tháng trước"
          icon={TrendingUp}
        />
        <StatCard
          title="Tăng trưởng lượt xem"
          value="+18%"
          change="+1.2k"
          changeLabel="lượt xem mới"
          icon={BarChart3}
        />
        <StatCard
          title="Điểm AI trung bình"
          value="87/100"
          change="+3 điểm"
          changeLabel="AI ưu tiên sản phẩm mới"
          icon={ArrowUpRight}
        />
        <StatCard
          title="Tỉ lệ chuyển đổi"
          value={averageConversion}
          change="+0.9pt"
          changeLabel="tăng trưởng tuần gần nhất"
          icon={ArrowUpRight}
        />
      </section>

      <section className="grid gap-6 lg:grid-cols-[2fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>Hiệu suất theo tuần</CardTitle>
            <CardDescription>
              So sánh số lượng sản phẩm gửi lên so với số lượng được duyệt.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4">
              {weeklyTrend.map((week) => (
                <div key={week.label} className="rounded-2xl border border-slate-100 p-4">
                  <div className="flex items-center justify-between text-sm font-medium text-slate-700">
                    <span>{week.label}</span>
                    <span>{week.approvals}/{week.submissions} được duyệt</span>
                  </div>
                  <div className="mt-3 flex items-center gap-3">
                    <div className="h-2 flex-1 rounded-full bg-slate-100">
                      <div
                        className="h-2 rounded-full bg-brand"
                        style={{
                          width: `${Math.max((week.approvals / week.submissions) * 100, 8)}%`
                        }}
                      />
                    </div>
                    <span className="text-xs text-slate-500">
                      {(week.approvals / week.submissions * 100).toFixed(0)}%
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <div className="grid gap-4">
          {insights.map((insight) => (
            <InsightCard key={insight.id} insight={insight} />
          ))}
        </div>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Luồng duyệt điển hình</CardTitle>
          <CardDescription>
            Tổng quan các bước chính từ khi sản phẩm được gửi đến khi hiển thị trên platform.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <ol className="relative space-y-6 border-l border-dashed border-brand/30 pl-6">
            {[
              {
                title: 'Đối tác gửi sản phẩm',
                detail: 'Hoàn tất thông tin sản phẩm, tài liệu chứng nhận và hình ảnh minh họa.'
              },
              {
                title: 'AI đánh giá sơ bộ',
                detail: 'Gợi ý độ ưu tiên dựa trên thành phần, market-fit và dữ liệu lịch sử.'
              },
              {
                title: 'Chuyên gia review',
                detail: 'Kiểm tra thành phần, đánh giá an toàn và đề xuất approve/reject.'
              },
              {
                title: 'Admin phê duyệt cuối',
                detail: 'Xác nhận chứng từ, đảm bảo tuân thủ pháp lý trước khi public.'
              }
            ].map((step, index) => (
              <Fragment key={step.title}>
                <li>
                  <span className="absolute -left-[9px] mt-1 h-4 w-4 rounded-full border-2 border-white bg-brand" />
                  <p className="text-sm font-semibold text-slate-800">
                    {index + 1}. {step.title}
                  </p>
                  <p className="text-sm text-slate-500">{step.detail}</p>
                </li>
              </Fragment>
            ))}
          </ol>
        </CardContent>
      </Card>
    </div>
  );
}
