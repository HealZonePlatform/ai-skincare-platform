'use client';

import { useMemo } from 'react';
import { AlertTriangle, CheckCircle2, FileText, Sparkles } from 'lucide-react';
import { StatusPill } from '@/components/common/StatusPill';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { mockProducts, mockReviews } from '@/data/mockData';

export default function ExpertReviewDetailPage() {
  const review = mockReviews[0];
  const product = useMemo(
    () => mockProducts.find((item) => item.id === review.productId),
    [review.productId]
  );

  if (!product) {
    return (
      <div className="rounded-3xl bg-danger/10 p-6 text-danger">
        Không tìm thấy thông tin sản phẩm. Kiểm tra lại dữ liệu mockData.
      </div>
    );
  }

  return (
    <div className="grid gap-8 lg:grid-cols-[1.3fr_0.7fr]">
      <Card>
        <CardHeader>
          <CardTitle>{product.name}</CardTitle>
          <CardDescription>
            {product.brand} • {product.code} • Danh mục {product.category}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex flex-wrap items-center gap-3">
            <StatusPill status={review.status} />
            <span className="text-sm text-slate-500">
              AI Score: <strong>{review.aiScore}</strong>/100
            </span>
            <span className="text-sm text-slate-500">
              Gửi lúc {new Date(review.submittedAt).toLocaleString('vi-VN')}
            </span>
          </div>

          <div className="grid gap-4 md:grid-cols-2">
            <Card className="border-brand/20 bg-brand/5">
              <CardHeader className="pb-2">
                <CardTitle className="flex items-center gap-2 text-sm text-brand">
                  <Sparkles className="h-4 w-4" />
                  Điểm nổi bật
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2 text-sm text-slate-600">
                {product.highlights.map((highlight) => (
                  <p key={highlight}>• {highlight}</p>
                ))}
              </CardContent>
            </Card>
            <Card className="border-warning/30 bg-warning/10">
              <CardHeader className="pb-2">
                <CardTitle className="flex items-center gap-2 text-sm text-warning">
                  <AlertTriangle className="h-4 w-4" />
                  Điểm cần lưu ý
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2 text-sm text-slate-700">
                <p>• Kiểm tra thử nghiệm kích ứng cho da nhạy cảm.</p>
                <p>• Xác nhận tiêu chuẩn kiểm nghiệm phòng lab Q3/2025.</p>
              </CardContent>
            </Card>
          </div>

          <div>
            <p className="text-sm font-semibold text-slate-800">Ghi chú gần nhất</p>
            <p className="mt-2 rounded-2xl bg-slate-100/80 p-4 text-sm text-slate-600">
              {review.expertNotes ?? 'Chưa có ghi chú từ chuyên gia.'}
            </p>
          </div>

          <div className="space-y-3">
            <p className="text-sm font-semibold text-slate-800">
              Ý kiến đề xuất ({review.recommendation ?? 'chưa có'})
            </p>
            <Textarea placeholder="Ghi lại kết luận và khuyến nghị gửi tới Admin..." />
            <div className="flex flex-wrap gap-3 text-xs text-slate-500">
              <span className="inline-flex items-center gap-2 rounded-full bg-success/10 px-3 py-1 text-success">
                <CheckCircle2 className="h-3 w-3" />
                Approve
              </span>
              <span className="inline-flex items-center gap-2 rounded-full bg-danger/10 px-3 py-1 text-danger">
                <AlertTriangle className="h-3 w-3" />
                Reject
              </span>
              <span className="inline-flex items-center gap-2 rounded-full bg-info/10 px-3 py-1 text-info">
                <FileText className="h-3 w-3" />
                Request more info
              </span>
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>Thông tin hiệu suất</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3 text-sm text-slate-600">
            <div className="flex items-center justify-between">
              <span>Lượt xem</span>
              <strong>{product.metrics.views.toLocaleString('vi-VN')}</strong>
            </div>
            <div className="flex items-center justify-between">
              <span>Tỉ lệ chuyển đổi</span>
              <strong>{product.metrics.conversionRate}%</strong>
            </div>
            <div className="flex items-center justify-between">
              <span>Đánh giá trung bình</span>
              <strong>{product.metrics.rating.toFixed(1)}/5</strong>
            </div>
            <div className="flex items-center justify-between">
              <span>Thời gian duyệt trung bình</span>
              <strong>{product.metrics.reviewTimeInHours} giờ</strong>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Tài liệu đính kèm</CardTitle>
            <CardDescription>Danh sách tài liệu được partner cung cấp.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm text-slate-600">
            <p>• Báo cáo thử nghiệm kích ứng da (PDF) • cập nhật 18/10</p>
            <p>• Thành phần INCI chi tiết (XLSX) • cập nhật 15/10</p>
            <p>• Chứng nhận phòng lab (PDF) • đang yêu cầu bản mới</p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
