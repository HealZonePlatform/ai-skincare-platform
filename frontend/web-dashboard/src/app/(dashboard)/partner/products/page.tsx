'use client';

import { useMemo } from 'react';
import { Filter, Plus } from 'lucide-react';
import { DataTable } from '@/components/table/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { StatusPill } from '@/components/common/StatusPill';
import { useProducts } from '@/hooks/useProducts';
import { ProductStatus } from '@/types/product';

const STATUS_LABELS: Record<ProductStatus | 'all', string> = {
  all: 'Tất cả',
  draft: 'Nháp',
  pending_review: 'Chờ chuyên gia',
  pending_approval: 'Chờ admin',
  approved: 'Đã duyệt',
  rejected: 'Từ chối'
};

export default function PartnerProductsPage() {
  const { products, search, setSearch, statusFilter, setStatusFilter, statusSummary } = useProducts();

  const columns = useMemo(
    () => [
      {
        key: 'name',
        label: 'Sản phẩm',
        render: (product: (typeof products)[number]) => (
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
        label: 'Danh mục',
        render: (product: (typeof products)[number]) => (
          <Badge variant="muted" className="capitalize">
            {product.category}
          </Badge>
        )
      },
      {
        key: 'status',
        label: 'Trạng thái',
        render: (product: (typeof products)[number]) => <StatusPill status={product.status} />
      },
      {
        key: 'metrics.conversionRate',
        label: 'Tỉ lệ chuyển đổi',
        align: 'center',
        sortable: true,
        render: (product: (typeof products)[number]) => (
          <span className="font-semibold text-slate-800">
            {product.metrics.conversionRate.toFixed(1)}%
          </span>
        )
      },
      {
        key: 'metrics.reviewTimeInHours',
        label: 'Thời gian duyệt',
        align: 'center',
        sortable: true,
        render: (product: (typeof products)[number]) =>
          product.metrics.reviewTimeInHours ? `${product.metrics.reviewTimeInHours}h` : '—'
      },
      {
        key: 'updatedAt',
        label: 'Cập nhật',
        render: (product: (typeof products)[number]) =>
          new Date(product.updatedAt).toLocaleString('vi-VN')
      }
    ],
    [products]
  );

  return (
    <div className="flex flex-col gap-8">
      <section className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-slate-900">Quản lý sản phẩm</h1>
          <p className="text-sm text-slate-500">
            Theo dõi trạng thái duyệt, chỉ số hiệu suất và tài liệu liên quan.
          </p>
        </div>
        <Button>
          <Plus className="h-4 w-4" />
          Thêm sản phẩm mới
        </Button>
      </section>

      <Card>
        <CardHeader className="flex flex-col gap-4">
          <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div className="flex items-center gap-2 text-sm text-slate-500">
              <Filter className="h-4 w-4" />
              Lọc nhanh theo trạng thái
            </div>
            <Input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Tìm kiếm theo tên, mã sản phẩm hoặc thương hiệu..."
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
        <CardContent>
          <DataTable
            data={products}
            columns={columns}
            emptyMessage="Không tìm thấy sản phẩm nào phù hợp với bộ lọc."
          />
        </CardContent>
      </Card>
    </div>
  );
}
