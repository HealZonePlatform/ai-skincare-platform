'use client';

import { CalendarDays, Clock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const appointments = [
  {
    title: 'Sync chiến dịch Q4',
    with: 'Đội Growth HealZone',
    time: '22/10/2025 • 10:00 - 11:00',
    type: 'Google Meet'
  },
  {
    title: 'Review hồ sơ Radiant Glow Serum',
    with: 'Dr. Minh Đặng',
    time: '23/10/2025 • 14:00 - 14:45',
    type: 'Meet trực tiếp'
  }
];

export default function PartnerSchedulingPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Lịch tư vấn & họp</h1>
          <p className="text-sm text-slate-500">
            Quản lý lịch làm việc với chuyên gia HealZone và đội vận hành.
          </p>
        </div>
        <Button variant="secondary">
          <CalendarDays className="h-4 w-4" />
          Đặt lịch mới
        </Button>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Lịch hẹn sắp tới</CardTitle>
          <CardDescription>Các buổi làm việc đã xác nhận trong 7 ngày tới.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {appointments.map((appointment) => (
            <div
              key={appointment.title}
              className="flex flex-col gap-1 rounded-2xl border border-slate-100 bg-white/60 p-4 text-sm text-slate-600"
            >
              <p className="text-sm font-semibold text-slate-800">{appointment.title}</p>
              <p>Với: {appointment.with}</p>
              <p className="flex items-center gap-2 text-xs text-slate-500">
                <Clock className="h-3 w-3" />
                {appointment.time} • {appointment.type}
              </p>
            </div>
          ))}
        </CardContent>
      </Card>
    </div>
  );
}
