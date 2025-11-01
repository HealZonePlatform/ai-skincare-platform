import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 px-4">
      <div className="max-w-xl rounded-3xl bg-white p-10 shadow-soft">
        <h1 className="text-3xl font-semibold text-slate-900">HealZone Web Dashboard</h1>
        <p className="mt-4 text-base text-slate-600">
          Nền tảng quản trị dành cho đối tác, chuyên gia và quản trị viên của hệ sinh thái HealZone.
          Đăng nhập để truy cập các module quản lý sản phẩm, duyệt nội dung và theo dõi phân tích.
        </p>
        <div className="mt-6 flex flex-col gap-3 sm:flex-row">
          <Link
            href="/login"
            className="inline-flex items-center justify-center rounded-full bg-brand px-6 py-2 text-sm font-medium text-white shadow-soft transition hover:bg-brand-dark"
          >
            Đăng nhập
          </Link>
          <Link
            href="/docs"
            className="inline-flex items-center justify-center rounded-full border border-slate-200 px-6 py-2 text-sm font-medium text-slate-700 transition hover:border-brand hover:text-brand"
          >
            Xem tài liệu
          </Link>
        </div>
      </div>
      <p className="text-xs uppercase tracking-[0.3em] text-slate-400">HealZone Platform</p>
    </main>
  );
}
