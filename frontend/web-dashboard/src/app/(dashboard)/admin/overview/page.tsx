'use client';

import { AlertTriangle, BarChart4, Gauge, Lock, Users } from 'lucide-react';
import { StatCard } from '@/components/common/StatCard';
import { StatusPill } from '@/components/common/StatusPill';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { mockReviews, mockUsers } from '@/data/mockData';
import { useProducts } from '@/hooks/useProducts';
import { useReviews } from '@/hooks/useReviews';
import { useUsers } from '@/hooks/useUsers';

const alerts = [
  {
    id: 'alt-01',
    type: 'security',
    title: 'Chưa bật 2FA cho 3 tài khoản đối tác',
    detail: 'Nhắc nhở đối tác kích hoạt trước 25/10/2025.'
  },
  {
    id: 'alt-02',
    type: 'compliance',
    title: 'Thiếu chứng từ ISO ở 2 sản phẩm pending approval',
    detail: 'Hydra Barrier Cream, Calming Skin Toner.'
  }
];

export default function AdminOverviewPage() {
  const { statusSummary } = useProducts();
  const { queue } = useReviews();
  const { summary } = useUsers();

  return (
    <div className="flex flex-col gap-8">
      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
        <StatCard
          title="Sản phẩm chờ duyệt"
          value={`${statusSummary.pending_review + statusSummary.pending_approval}`}
          change={`${statusSummary.pending_review} chuyên gia • ${statusSummary.pending_approval} admin`}
          changeLabel="Đang nằm trong hàng đợi"
          icon={Gauge}
        />
        <StatCard
          title="Người dùng hoạt động"
          value={`${summary.active}`}
          change={`${summary.partner} đối tác, ${summary.expert} chuyên gia`}
          changeLabel="Hoạt động trong 7 ngày"
          icon={Users}
        />
        <StatCard
          title="Cảnh báo bảo mật"
          value="02"
          change="3 tài khoản cần bật 2FA"
          changeLabel="Ưu tiên cao"
          icon={Lock}
          trend="down"
        />
        <StatCard
          title="Độ phủ báo cáo"
          value="96%"
          change="+4%"
          changeLabel="Báo cáo tuần đã gửi"
          icon={BarChart4}
        />
      </section>

      <section className="grid gap-6 lg:grid-cols-[1.6fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>Hàng đợi quyết định</CardTitle>
            <CardDescription>Danh sách đề xuất mới nhất từ chuyên gia.</CardDescription>
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
                  key: 'aiScore',
                  label: 'AI score',
                  align: 'center',
                  sortable: true
                },
                {
                  key: 'submittedAt',
                  label: 'Thời gian',
                  render: (item) => new Date(item.submittedAt).toLocaleString('vi-VN')
                }
              ]}
            />
          </CardContent>
        </Card>

        <Card className="border-danger/30 bg-danger/5">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-danger">
              <AlertTriangle className="h-4 w-4" />
              Cảnh báo hệ thống
            </CardTitle>
            <CardDescription className="text-slate-600">
              Theo dõi các hạng mục cần hành động ngay.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm text-slate-600">
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
          <CardTitle>Nhật ký truy cập gần nhất</CardTitle>
          <CardDescription>
            5 lần đăng nhập/hoạt động gần nhất để theo dõi bất thường.
          </CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 text-sm text-slate-600">
          {mockUsers.slice(0, 5).map((user) => (
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
                <span>Hoạt động: {new Date(user.lastActiveAt).toLocaleString('vi-VN')}</span>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>
    </div>
  );
}
