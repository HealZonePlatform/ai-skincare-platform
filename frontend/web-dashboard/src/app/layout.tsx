import { Inter } from 'next/font/google';
import type { Metadata } from 'next';
import './globals.css';
import { AppProviders } from '@/providers/AppProviders';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap'
});

export const metadata: Metadata = {
  title: 'HealZone Dashboard',
  description:
    'HealZone administrative dashboard for partners, experts, and platform administrators.'
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="vi">
      <body className={`${inter.className} min-h-screen bg-slate-50`}>
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
