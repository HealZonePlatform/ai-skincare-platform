export default function LoginPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-100 px-4 py-8">
      <div className="w-full max-w-md rounded-3xl bg-white p-8 shadow-soft">
        <h1 className="text-2xl font-semibold text-slate-900">Đăng nhập</h1>
        <p className="mt-2 text-sm text-slate-600">
          Đăng nhập để truy cập bảng điều khiển HealZone.
        </p>
        <form className="mt-6 flex flex-col gap-4">
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Email</span>
            <input
              type="email"
              placeholder="ban@healzone.ai"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
            />
          </label>
          <label className="flex flex-col gap-2 text-sm">
            <span className="font-medium text-slate-700">Mật khẩu</span>
            <input
              type="password"
              placeholder="••••••••"
              className="rounded-xl border border-slate-200 px-4 py-2 text-slate-900 outline-none transition focus:border-brand focus:ring-2 focus:ring-brand/40"
            />
          </label>
          <button
            type="submit"
            className="mt-2 inline-flex items-center justify-center rounded-full bg-brand px-6 py-2 text-sm font-medium text-white shadow-soft transition hover:bg-brand-dark"
          >
            Tiếp tục
          </button>
          <p className="text-center text-xs text-slate-500">
            Single Sign-On và xác thực đa vai trò sẽ được tích hợp với Auth Service.
          </p>
        </form>
      </div>
    </main>
  );
}
