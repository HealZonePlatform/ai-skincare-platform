'use client';

import { BookOpenCheck, BrainCircuit, Download } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const resources = [
  {
    title: 'HealZone Clinical Playbook',
    category: 'Hướng dẫn nội bộ',
    description: 'Quy trình đánh giá thành phần, đánh giá an toàn và template báo cáo chuẩn.',
    updatedAt: '16/10/2025'
  },
  {
    title: 'Bảng thành phần nhạy cảm',
    category: 'Dữ liệu AI',
    description: 'Top 50 thành phần cần lưu ý với da nhạy cảm & cơ chế cảnh báo tự động.',
    updatedAt: '14/10/2025'
  },
  {
    title: 'Checklist kiểm chứng tài liệu',
    category: 'Compliance',
    description: 'Danh sách tài liệu bắt buộc trước khi gửi đề xuất phê duyệt cho Admin.',
    updatedAt: '10/10/2025'
  }
];

export default function ExpertResourcesPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-col gap-2">
        <h1 className="text-2xl font-semibold text-slate-900">Tài nguyên cho chuyên gia</h1>
        <p className="text-sm text-slate-500">
          Bộ tài liệu chuyên sâu hỗ trợ đánh giá sản phẩm nhanh, chính xác và nhất quán.
        </p>
      </section>

      <section className="grid gap-6 lg:grid-cols-2">
        {resources.map((item) => (
          <Card key={item.title}>
            <CardHeader className="flex flex-row items-start justify-between gap-4">
              <div>
                <CardTitle className="flex items-center gap-2 text-lg text-slate-900">
                  <BrainCircuit className="h-5 w-5 text-brand" />
                  {item.title}
                </CardTitle>
                <CardDescription>{item.description}</CardDescription>
              </div>
              <Button variant="secondary" className="whitespace-nowrap">
                <Download className="h-4 w-4" />
                Tải xuống
              </Button>
            </CardHeader>
            <CardContent className="flex items-center justify-between text-xs text-slate-500">
              <span>Nhóm: {item.category}</span>
              <span>Cập nhật: {item.updatedAt}</span>
            </CardContent>
          </Card>
        ))}
      </section>

      <Card className="border-brand/20 bg-brand/5">
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-brand">
            <BookOpenCheck className="h-5 w-5" />
            Clinical Knowledge Hub
          </CardTitle>
          <CardDescription className="text-slate-600">
            Hệ thống kiến thức tập trung giúp đồng nhất quyết định giữa các chuyên gia.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-3 text-sm text-slate-600">
          <p>
            • Cơ sở dữ liệu thành phần INCI cập nhật hàng tuần<br />
            • Mẫu báo cáo phản hồi tiêu chuẩn HealZone<br />
            • FAQ và best practice khi trao đổi với Admin<br />
            • Bộ câu trả lời mẫu cho đối tác khi cần bổ sung tài liệu
          </p>
          <Button variant="primary" className="w-full">
            Mở Knowledge Hub
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
