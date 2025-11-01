'use client';

import { FileBarChart, FileSpreadsheet } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const reports = [
  {
    title: 'Báo cáo hoạt động tuần 42',
    description: 'Tổng hợp sản phẩm mới, tỉ lệ phê duyệt, cảnh báo bảo mật và chỉ số tăng trưởng.',
    size: '4.5 MB',
    generatedAt: '20/10/2025 08:00'
  },
  {
    title: 'Phân tích hiệu suất đối tác',
    description: 'So sánh hiệu suất từng đối tác theo KPI đã cam kết và đề xuất tối ưu.',
    size: '3.2 MB',
    generatedAt: '19/10/2025 17:30'
  },
  {
    title: 'Báo cáo tuân thủ & kiểm soát',
    description: 'Theo dõi chứng chỉ, nhật ký truy cập và tình trạng audit.',
    size: '2.8 MB',
    generatedAt: '18/10/2025 12:00'
  }
];

export default function AdminReportsPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Báo cáo định kỳ</h1>
          <p className="text-sm text-slate-500">
            Tải về và chia sẻ báo cáo tổng hợp cho stakeholder nội bộ và đối tác.
          </p>
        </div>
        <Button>
          <FileSpreadsheet className="h-4 w-4" />
          Xuất báo cáo mới
        </Button>
      </section>

      <section className="grid gap-6 lg:grid-cols-2">
        {reports.map((report) => (
          <Card key={report.title}>
            <CardHeader className="flex flex-row items-start justify-between gap-4">
              <div>
                <CardTitle className="flex items-center gap-2 text-lg text-slate-900">
                  <FileBarChart className="h-5 w-5 text-brand" />
                  {report.title}
                </CardTitle>
                <CardDescription>{report.description}</CardDescription>
              </div>
              <Button variant="secondary" className="whitespace-nowrap">
                Tải xuống
              </Button>
            </CardHeader>
            <CardContent className="flex items-center justify-between text-xs text-slate-500">
              <span>Kích thước: {report.size}</span>
              <span>Generated: {report.generatedAt}</span>
            </CardContent>
          </Card>
        ))}
      </section>
    </div>
  );
}
