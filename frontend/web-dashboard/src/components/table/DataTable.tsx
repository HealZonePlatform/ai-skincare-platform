'use client';

import { ReactNode, useMemo, useState } from 'react';
import { ArrowDown, ArrowUp, ChevronUp } from 'lucide-react';
import { cn } from '@/lib/utils';

export type ColumnConfig<T> = {
  key: keyof T | string;
  label: string;
  sortable?: boolean;
  align?: 'left' | 'right' | 'center';
  width?: string;
  render?: (item: T) => ReactNode;
};

type SortState<T> = {
  key: keyof T | string | null;
  direction: 'asc' | 'desc';
};

type DataTableProps<T> = {
  data: T[];
  columns: ColumnConfig<T>[];
  emptyMessage?: string;
};

export const DataTable = <T,>({ data, columns, emptyMessage }: DataTableProps<T>) => {
  const [sortState, setSortState] = useState<SortState<T>>({ key: null, direction: 'asc' });

  const sortedData = useMemo(() => {
    if (!sortState.key) return data;

    return [...data].sort((a, b) => {
      const aValue = resolveValue(a, sortState.key);
      const bValue = resolveValue(b, sortState.key);

      if (typeof aValue === 'number' && typeof bValue === 'number') {
        return sortState.direction === 'asc' ? aValue - bValue : bValue - aValue;
      }

      return sortState.direction === 'asc'
        ? String(aValue).localeCompare(String(bValue))
        : String(bValue).localeCompare(String(aValue));
    });
  }, [data, sortState]);

  const toggleSort = (key: keyof T | string) => {
    setSortState((prev) => {
      if (prev.key !== key) {
        return { key, direction: 'asc' };
      }

      return { key, direction: prev.direction === 'asc' ? 'desc' : 'asc' };
    });
  };

  return (
    <div className="overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-soft">
      <table className="min-w-full table-fixed divide-y divide-slate-100">
        <thead className="bg-slate-50/80">
          <tr>
            {columns.map((column) => (
              <th
                key={column.key as string}
                style={{ width: column.width }}
                className={cn(
                  'px-5 py-4 text-left text-xs font-semibold uppercase tracking-[0.3em] text-slate-400',
                  column.align === 'right' && 'text-right',
                  column.align === 'center' && 'text-center'
                )}
              >
                {column.sortable ? (
                  <button
                    type="button"
                    className="flex items-center gap-2 text-slate-500 transition hover:text-brand"
                    onClick={() => toggleSort(column.key)}
                  >
                    {column.label}
                    <SortIcon columnKey={column.key} sortState={sortState} />
                  </button>
                ) : (
                  column.label
                )}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100">
          {sortedData.length === 0 ? (
            <tr>
              <td colSpan={columns.length} className="px-5 py-10 text-center text-sm text-slate-500">
                {emptyMessage ?? 'Không có dữ liệu'}
              </td>
            </tr>
          ) : (
            sortedData.map((item, rowIndex) => (
              <tr key={rowIndex} className="bg-white/60 transition hover:bg-brand/5">
                {columns.map((column) => (
                  <td
                    key={column.key as string}
                    className={cn(
                      'px-5 py-4 text-sm text-slate-600',
                      column.align === 'right' && 'text-right',
                      column.align === 'center' && 'text-center'
                    )}
                  >
                    {column.render ? column.render(item) : renderDefaultCell(item, column.key)}
                  </td>
                ))}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};

const renderDefaultCell = <T,>(item: T, key: keyof T | string) => {
  const value = resolveValue(item, key);
  if (value === undefined || value === null) return '—';
  if (value instanceof Date) return value.toLocaleDateString('vi-VN');
  return String(value);
};

const resolveValue = <T,>(item: T, key: keyof T | string) => {
  const path = String(key).split('.');
  return path.reduce<unknown>((acc, segment) => {
    if (acc === undefined || acc === null) return undefined;
    if (typeof acc !== 'object') return undefined;
    return (acc as Record<string, unknown>)[segment];
  }, item as unknown);
};

const SortIcon = <T,>({
  columnKey,
  sortState
}: {
  columnKey: keyof T | string;
  sortState: SortState<T>;
}) => {
  if (sortState.key !== columnKey) {
    return <ChevronUp className="h-3 w-3 opacity-30" />;
  }
  if (sortState.direction === 'asc') {
    return <ArrowUp className="h-3 w-3" />;
  }
  return <ArrowDown className="h-3 w-3" />;
};
