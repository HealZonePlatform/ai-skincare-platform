'use client';

import { useMemo } from 'react';
import { Filter, Plus } from 'lucide-react';
import { ColumnConfig, DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { StatusPill } from '@/components/common/StatusPill';
import { useProducts } from '@/hooks/useProducts';
import type { Product, ProductStatus } from '@/types/product';

const STATUS_LABELS: Record<ProductStatus | 'all', string> = {
  all: 'Tat ca',
  draft: 'Nhap',
  pending_review: 'Cho chuyen gia',
  pending_approval: 'Cho admin',
  approved: 'Da duyet',
  rejected: 'Tu choi'
};

const LoadingState = () => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-sm text-slate-500">
    <div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-200 border-t-brand" />
    <p>Dang tai du lieu san pham...</p>
  </div>
);

const ErrorState = ({ message, onRetry }: { message: string; onRetry: () => void }) => (
  <div className="flex flex-col items-center justify-center gap-3 py-10 text-center text-sm text-slate-500">
    <p>{message}</p>
    <Button variant="outline" onClick={onRetry}>
      Thu lai
    </Button>
  </div>
);

export default function PartnerProductsPage() {
  const {
    products,
    search,
    setSearch,
    statusFilter,
    setStatusFilter,
    statusSummary,
    isLoading,
    isFetching,
    isError,
    error,
    refetch
  } = useProducts();

  const columns = useMemo<ColumnConfig<Product>[]>(
    () => [
      {
        key: 'name',
        label: 'San pham',
        render: (product) => (
          <div className="flex flex-col">
            <span className="font-medium text-slate-800">{product.name}</span>
            <span className="text-xs text-slate-500">
              {product.brand} • {product.code}
            </span>
          </div>
        )
      },
      {
        key: 'category',
        label: 'Danh muc',
        render: (product) => (
          <Badge variant="muted" className="capitalize">
            {product.category}
          </Badge>
        )
      },
      {
        key: 'status',
        label: 'Trang thai',
        render: (product) => <StatusPill status={product.status} />
      },
      {
        key: 'metrics.conversionRate',
        label: 'Ti le chuyen doi',
        align: 'center',
        sortable: true,
        render: (product) => (
          <span className="font-semibold text-slate-800">
            {product.metrics.conversionRate.toFixed(1)}%
          </span>
        )
      },
      {
        key: 'metrics.reviewTimeInHours',
        label: 'Thoi gian duyet',
        align: 'center',
        sortable: true,
        render: (product) =>
          product.metrics.reviewTimeInHours ? `${product.metrics.reviewTimeInHours}h` : '—'
      },
      {
        key: 'updatedAt',
        label: 'Cap nhat',
        render: (product) => new Date(product.updatedAt).toLocaleString('vi-VN')
      }
    ],
    []
  );

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Quan ly san pham</h1>
          <p className="text-sm text-slate-500">
            Theo doi trang thai duyet, chi so hieu suat va tai lieu lien quan.
          </p>
        </div>
        <Button>
          <Plus className="h-4 w-4" />
          Them san pham moi
        </Button>
      </section>

      <Card>
        <CardHeader className="flex flex-col gap-4">
          <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div className="flex items-center gap-2 text-sm text-slate-500">
              <Filter className="h-4 w-4" />
              Loc nhanh theo trang thai
              {isFetching ? (
                <span className="ml-2 inline-flex items-center gap-2 text-xs text-slate-400">
                  <span className="h-2 w-2 animate-ping rounded-full bg-brand" />
                  Dang dong bo...
                </span>
              ) : null}
            </div>
            <Input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Tim theo ten, ma san pham hoac thuong hieu..."
              className="w-full max-w-sm"
            />
          </div>
          <div className="flex flex-wrap gap-2">
            {(Object.keys(STATUS_LABELS) as Array<ProductStatus | 'all'>).map((status) => (
              <button
                key={status}
                type="button"
                onClick={() => setStatusFilter(status)}
                className={`inline-flex items-center gap-2 rounded-full border px-4 py-2 text-sm font-medium transition ${
                  statusFilter === status
                    ? 'border-brand bg-brand text-white shadow-soft'
                    : 'border-slate-200 bg-white text-slate-600 hover:border-brand hover:text-brand'
                }`}
              >
                {STATUS_LABELS[status]}
                <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs">
                  {status === 'all' ? statusSummary.total : statusSummary[status]}
                </span>
              </button>
            ))}
          </div>
        </CardHeader>
        <CardContent className="min-h-[260px]">
          {isError ? (
            <ErrorState
              message={error instanceof Error ? error.message : 'Khong the tai du lieu san pham.'}
              onRetry={() => refetch()}
            />
          ) : isLoading ? (
            <LoadingState />
          ) : (
            <DataTable
              data={products}
              columns={columns}
              emptyMessage="Khong tim thay san pham phu hop voi bo loc."
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
