'use client';

import { CalendarClock, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const sessions = [
  {
    topic: 'Peer review Radiant Glow Serum',
    attendees: 'Dr. Minh Đặng, Dr. Hạnh Phạm',
    time: '21/10/2025 • 15:00 - 15:45',
    type: 'Google Meet'
  },
  {
    topic: 'Clinical board weekly sync',
    attendees: 'HealZone Expert Board',
    time: '24/10/2025 • 09:00 - 10:00',
    type: 'HealZone HQ'
  }
];

export default function ExpertSchedulingPage() {
  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Lịch làm việc chuyên gia</h1>
          <p className="text-sm text-slate-500">
            Chủ động sắp xếp ca review, peer-review và buổi cập nhật với Admin.
          </p>
        </div>
        <Button>
          <CalendarClock className="h-4 w-4" />
          Lên lịch mới
        </Button>
      </section>

      <Card>
        <CardHeader>
          <CardTitle>Buổi hẹn sắp tới</CardTitle>
          <CardDescription>Các phiên review đã được xác nhận trong tuần này.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {sessions.map((session) => (
            <div
              key={session.topic}
              className="flex flex-col gap-1 rounded-2xl border border-slate-100 bg-white/60 p-4 text-sm text-slate-600"
            >
              <p className="text-sm font-semibold text-slate-800">{session.topic}</p>
              <p className="flex items-center gap-2 text-xs text-slate-500">
                <Users className="h-3 w-3" />
                {session.attendees}
              </p>
              <p className="text-xs text-slate-500">{session.time} • {session.type}</p>
            </div>
          ))}
        </CardContent>
      </Card>
    </div>
  );
}
