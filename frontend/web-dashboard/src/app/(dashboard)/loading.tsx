export default function DashboardLoading() {
  return (
    <div className="grid gap-6 lg:grid-cols-3">
      {Array.from({ length: 6 }).map((_, index) => (
        <div key={index} className="h-48 animate-pulse rounded-3xl bg-white/60 shadow-inner" />
      ))}
    </div>
  );
}
