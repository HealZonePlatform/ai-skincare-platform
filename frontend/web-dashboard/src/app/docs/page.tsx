export default function DocsPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col gap-6 px-6 py-16">
      <section className="rounded-3xl bg-white p-8 shadow-soft">
        <h1 className="text-3xl font-semibold text-slate-900">Tài liệu dự án</h1>
        <p className="mt-3 text-base text-slate-600">
          Tham khảo thư mục <code className="rounded bg-slate-100 px-2 py-1">/docs</code> trong repo
          để xem chi tiết kiến trúc, roadmap và plan triển khai Web Dashboard.
        </p>
        <ul className="mt-6 space-y-3 text-sm text-slate-700">
          <li>
            <strong>05_WEB_DASHBOARD_PLAN.md</strong> – Phân chia module và lộ trình phát triển.
          </li>
          <li>
            <strong>00_PROJECT_OVERVIEW.md</strong> – Tổng quan dự án AI Skincare Platform.
          </li>
          <li>
            <strong>AGENTS.md</strong> – Quy ước và hướng dẫn cho agent khi làm việc với codebase.
          </li>
        </ul>
      </section>
      <p className="text-center text-xs uppercase tracking-[0.3em] text-slate-400">
        HealZone Platform
      </p>
    </main>
  );
}
