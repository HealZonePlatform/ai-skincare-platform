'use client';

import { CheckCircle2, Shield, SlidersHorizontal } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const settingsItems = [
  {
    id: 'enforce-2fa',
    title: 'Yêu cầu 2FA cho mọi tài khoản dashboard',
    description: 'Bắt buộc OTP qua email/Google Authenticator cho tất cả vai trò.',
    enabled: true
  },
  {
    id: 'auto-assign-expert',
    title: 'Tự động phân công chuyên gia theo hàng đợi AI',
    description: 'Khi partner submit, AI sẽ gợi ý chuyên gia phụ trách theo năng lực.',
    enabled: true
  },
  {
    id: 'require-lab-report',
    title: 'Bắt buộc đính kèm báo cáo phòng lab',
    description: 'Chỉ accept sản phẩm có báo cáo thử nghiệm lâm sàng từ phòng lab đạt chuẩn.',
    enabled: false
  }
];

export default function AdminSettingsPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Cài đặt nền tảng</h1>
          <p className="text-sm text-slate-500">
            Quản lý chính sách bảo mật, quy trình duyệt và thông số hệ thống.
          </p>
        </div>
        <Button variant="secondary">
          <SlidersHorizontal className="h-4 w-4" />
          Lịch sử thay đổi
        </Button>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Chính sách bảo mật</CardTitle>
          <CardDescription>
            Điều chỉnh các chính sách bảo mật và tiêu chuẩn compliance cho dashboard.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {settingsItems.map((item) => (
            <div
              key={item.id}
              className="flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-slate-100 bg-white/70 px-4 py-3"
            >
              <div>
                <p className="text-sm font-semibold text-slate-800">{item.title}</p>
                <p className="text-xs text-slate-500">{item.description}</p>
              </div>
              <label className="relative inline-flex cursor-pointer items-center">
                <input type="checkbox" className="peer sr-only" defaultChecked={item.enabled} />
                <div className="peer h-6 w-12 rounded-full bg-slate-200 transition peer-checked:bg-brand" />
                <span className="absolute left-1 top-1 h-4 w-4 rounded-full bg-white transition peer-checked:translate-x-6" />
              </label>
            </div>
          ))}
        </CardContent>
      </Card>

      <Card className="border-brand/20 bg-brand/5">
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-brand">
            <Shield className="h-5 w-5" />
            Quy trình phê duyệt chuẩn
          </CardTitle>
          <CardDescription className="text-slate-600">
            Tổng hợp các điều kiện bắt buộc trước khi đưa sản phẩm lên production.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-2 text-sm text-slate-600">
          <p>• Đảm bảo partner đã ký Data Processing Agreement.</p>
          <p>• Tài liệu chứng nhận an toàn được upload trong vòng 60 ngày.</p>
          <p>• Chuyên gia đánh giá có chữ ký số hợp lệ.</p>
          <p>• Admin xác nhận và log audit được đẩy sang hệ thống SIEM.</p>
          <Button variant="primary" className="mt-4 inline-flex items-center gap-2">
            <CheckCircle2 className="h-4 w-4" />
            Tải Quy trình PDF
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
