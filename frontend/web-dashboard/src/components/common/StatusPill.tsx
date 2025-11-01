'use client';

import { cn } from '@/lib/utils';

type StatusMap = {
  label: string;
  className: string;
};

const STATUS_STYLES: Record<string, StatusMap> = {
  pending_review: { label: 'Chờ chuyên gia', className: 'bg-warning/10 text-warning' },
  pending_approval: { label: 'Chờ admin', className: 'bg-info/10 text-info' },
  approved: { label: 'Đã duyệt', className: 'bg-success/10 text-success' },
  rejected: { label: 'Từ chối', className: 'bg-danger/10 text-danger' },
  draft: { label: 'Nháp', className: 'bg-slate-100 text-slate-500' }
};

type StatusPillProps = {
  status: string;
  className?: string;
};

export const StatusPill = ({ status, className }: StatusPillProps) => {
  const fallback: StatusMap = {
    label: status,
    className: 'bg-slate-100 text-slate-500'
  };

  const { label, className: statusClasses } = STATUS_STYLES[status] ?? fallback;

  return (
    <span
      className={cn(
        'inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold capitalize',
        statusClasses,
        className
      )}
    >
      {label}
    </span>
  );
};
