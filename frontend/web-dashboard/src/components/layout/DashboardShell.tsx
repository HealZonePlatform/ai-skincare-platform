'use client';

import { ReactNode, useState } from 'react';
import { Sidebar } from './sidebar/Sidebar';
import { Topbar } from './topbar/Topbar';

type DashboardShellProps = {
  children: ReactNode;
};

export const DashboardShell = ({ children }: DashboardShellProps) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="flex min-h-screen bg-slate-100/80">
      <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      <div className="flex w-full flex-1 flex-col lg:pl-72">
        <Topbar onToggleSidebar={() => setSidebarOpen(true)} />
        <main className="mt-24 flex flex-1 flex-col gap-6 px-4 pb-10 sm:px-6 lg:px-14">
          {children}
        </main>
      </div>
    </div>
  );
};
