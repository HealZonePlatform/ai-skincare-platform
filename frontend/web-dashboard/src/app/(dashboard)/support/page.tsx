'use client';

import { LifeBuoy, Mail, MessageSquare } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

export default function SupportPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-col gap-2">
        <h1 className="text-2xl font-semibold text-slate-900">Trung tâm hỗ trợ HealZone</h1>
        <p className="text-sm text-slate-500">
          Liên hệ với đội vận hành hoặc gửi ticket khi gặp sự cố trong quá trình quản trị.
        </p>
      </section>

      <section className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader className="flex items-start justify-between">
            <div>
              <CardTitle className="flex items-center gap-2 text-lg">
                <LifeBuoy className="h-5 w-5 text-brand" />
                Live Support
              </CardTitle>
              <CardDescription>Trò chuyện trực tiếp với đội vận hành trong giờ làm việc.</CardDescription>
            </div>
            <Button variant="primary">
              <MessageSquare className="h-4 w-4" />
              Mở chat
            </Button>
          </CardHeader>
          <CardContent className="text-sm text-slate-600">
            Thời gian hỗ trợ: 08:00 - 22:00 (GMT+7) • Kênh Slack #healzone-support
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex items-start justify-between">
            <div>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Mail className="h-5 w-5 text-brand" />
                Gửi ticket
              </CardTitle>
              <CardDescription>Phù hợp với các yêu cầu cần kiểm tra kỹ hoặc mang tính pháp lý.</CardDescription>
            </div>
            <Button variant="secondary">Gửi ticket</Button>
          </CardHeader>
          <CardContent className="text-sm text-slate-600">
            Email: support@healzone.ai • SLA phản hồi trong vòng 12 giờ làm việc.
          </CardContent>
        </Card>
      </section>
    </div>
  );
}
