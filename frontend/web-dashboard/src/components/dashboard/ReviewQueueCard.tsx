'use client';

import { AlarmClock, Sparkles, Star } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { Card } from '@/components/ui/card';
import { StatusPill } from '@/components/common/StatusPill';
import { ReviewEntry } from '@/types/review';

const PRIORITY_LABELS: Record<ReviewEntry['priority'], string> = {
  urgent: 'Khẩn cấp',
  high: 'Ưu tiên cao',
  medium: 'Ưu tiên vừa',
  low: 'Ưu tiên thấp'
};

const PRIORITY_COLOR: Record<ReviewEntry['priority'], string> = {
  urgent: 'bg-danger/10 text-danger',
  high: 'bg-warning/10 text-warning',
  medium: 'bg-info/10 text-info',
  low: 'bg-slate-100 text-slate-500'
};

type ReviewQueueCardProps = {
  review: ReviewEntry;
};

export const ReviewQueueCard = ({ review }: ReviewQueueCardProps) => {
  return (
    <Card className="flex flex-col gap-4">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm font-semibold text-slate-800">{review.productName}</p>
          <p className="text-xs text-slate-500">{review.partnerName}</p>
        </div>
        <Badge className={PRIORITY_COLOR[review.priority]}>{PRIORITY_LABELS[review.priority]}</Badge>
      </div>
      <div className="flex items-center justify-between text-sm text-slate-600">
        <div className="inline-flex items-center gap-2">
          <Sparkles className="h-4 w-4 text-brand" />
          AI score: <strong>{review.aiScore}</strong>
        </div>
        <div className="inline-flex items-center gap-2 text-xs text-slate-500">
          <AlarmClock className="h-3 w-3" />
          Gửi {new Date(review.submittedAt).toLocaleString('vi-VN')}
        </div>
      </div>
      <div className="flex items-center justify-between">
        <StatusPill status={review.status} />
        {review.expertNotes ? (
          <div className="flex items-center gap-2 text-xs text-slate-500">
            <Star className="h-3 w-3 text-warning" />
            {review.expertNotes}
          </div>
        ) : null}
      </div>
    </Card>
  );
};
