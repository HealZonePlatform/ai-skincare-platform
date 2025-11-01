'use client';

import { BookOpen, Download, FileText, ShieldCheck } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const documents = [
  {
    title: 'Checklist hồ sơ sản phẩm 2025',
    description: 'Danh sách tài liệu cần nộp theo tiêu chuẩn HealZone và quy định Bộ Y tế.',
    fileSize: '2.1 MB',
    lastUpdated: '18/10/2025'
  },
  {
    title: 'Mẫu specification chuẩn',
    description: 'Template chuẩn hóa thông tin thành phần INCI, thử nghiệm lâm sàng và packaging.',
    fileSize: '1.4 MB',
    lastUpdated: '12/10/2025'
  },
  {
    title: 'Hướng dẫn vận hành chiến dịch',
    description: 'Quy trình phối hợp marketing cùng đội Growth của HealZone.',
    fileSize: '3.6 MB',
    lastUpdated: '08/10/2025'
  }
];

const trainings = [
  {
    title: 'Workshop: Xây dựng hồ sơ sản phẩm chuẩn',
    time: '25/10/2025 • 09:00 - 11:00',
    speaker: 'Dr. Minh Đặng',
    location: 'Google Meet'
  },
  {
    title: 'Office Hour: Q&A cùng đội Admin',
    time: 'Thứ 4 hàng tuần • 15:00 - 16:00',
    speaker: 'Lan Trần',
    location: 'Slack #healzone-partners'
  }
];

export default function PartnerResourcesPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-col gap-2">
        <h1 className="text-2xl font-semibold text-slate-900">Tài nguyên cho đối tác</h1>
        <p className="text-sm text-slate-500">
          Tổng hợp tài liệu, checklist và lịch đào tạo giúp tăng tốc quy trình duyệt sản phẩm.
        </p>
      </section>

      <section className="grid gap-6 lg:grid-cols-2">
        {documents.map((doc) => (
          <Card key={doc.title}>
            <CardHeader className="flex flex-row items-start justify-between gap-4">
              <div>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <FileText className="h-4 w-4 text-brand" />
                  {doc.title}
                </CardTitle>
                <CardDescription>{doc.description}</CardDescription>
              </div>
              <Button variant="secondary" className="whitespace-nowrap">
                <Download className="h-4 w-4" />
                Tải xuống
              </Button>
            </CardHeader>
            <CardContent className="flex items-center justify-between text-xs text-slate-500">
              <span>Kích thước tệp: {doc.fileSize}</span>
              <span>Cập nhật lần cuối: {doc.lastUpdated}</span>
            </CardContent>
          </Card>
        ))}
      </section>

      <section className="grid gap-6 lg:grid-cols-[1.4fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>Lịch đào tạo & office hour</CardTitle>
            <CardDescription>Đăng ký tham gia để cập nhật quy định và best practices.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {trainings.map((training) => (
              <div
                key={training.title}
                className="rounded-2xl border border-slate-100 bg-white/60 p-4"
              >
                <p className="text-sm font-semibold text-slate-800">{training.title}</p>
                <p className="text-xs text-slate-500">{training.time}</p>
                <p className="text-xs text-slate-500">
                  Người trình bày: <strong>{training.speaker}</strong> • {training.location}
                </p>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card className="border-brand/20 bg-brand/5">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-brand">
              <ShieldCheck className="h-4 w-4" />
              Compliance Hub
            </CardTitle>
            <CardDescription className="text-slate-600">
              Trung tâm cập nhật tiêu chuẩn pháp lý & chứng nhận.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm text-slate-600">
            <p>
              • Bộ tiêu chuẩn sản phẩm chăm sóc da 2025<br />
              • Checklist đánh giá hợp chất gây kích ứng<br />
              • Quy trình đăng ký sản phẩm nhập khẩu vào Việt Nam<br />
              • Mẫu thư thông báo khi cần bổ sung tài liệu
            </p>
            <Button variant="primary" className="w-full">
              <BookOpen className="h-4 w-4" />
              Mở Compliance Hub
            </Button>
          </CardContent>
        </Card>
      </section>
    </div>
  );
}
