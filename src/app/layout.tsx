import './globals.css';
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import GoogleAnalytics from '@/components/GoogleAnalytics';
import StructuredData from '@/components/StructuredData';
import { Suspense } from 'react';

const inter = Inter({ subsets: ['latin'] });

/**
 * Global metadata configuration for the Horizon Skincare landing page.
 *
 * The metadata values here are tailored for the Vietnamese audience,
 * aligning with the updated branding and using the new custom domain
 * `horizonskincare.online`. OpenGraph and Twitter tags ensure rich
 * previews when links are shared on social media. The `lang` attribute
 * of the `<html>` element is set to `vi` for better accessibility and
 * SEO in Vietnamese search results.
 */
export const metadata: Metadata = {
  title: {
    default: 'Horizon Skincare AI | Nâng Tầm Hành Trình Chăm Sóc Da',
    template: '%s | Horizon Skincare AI',
  },
  description:
    'Nâng tầm hành trình chăm sóc da với phân tích AI chính xác và lộ trình cá nhân hoá.',
  keywords: [
    'AI skincare',
    'phân tích da',
    'chăm sóc da cá nhân',
    'công nghệ làm đẹp',
    'skincare routine',
    'ứng dụng chăm sóc da',
  ],
  authors: [{ name: 'Horizon Skincare' }],
  creator: 'Horizon Skincare',
  publisher: 'Horizon Skincare',
  openGraph: {
    title: 'Horizon Skincare AI | Nâng Tầm Hành Trình Chăm Sóc Da',
    description:
      'Nâng tầm hành trình chăm sóc da với phân tích AI chính xác và lộ trình cá nhân hoá.',
    url: 'https://horizonskincare.online/',
    siteName: 'Horizon Skincare AI',
    images: [
      {
        url: '/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'Horizon Skincare AI - Nâng Tầm Hành Trình Chăm Sóc Da',
      },
    ],
    locale: 'vi_VN',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Horizon Skincare AI | Nâng Tầm Hành Trình Chăm Sóc Da',
    description:
      'Nâng tầm hành trình chăm sóc da với phân tích AI chính xác và lộ trình cá nhân hoá.',
    images: ['/og-image.jpg'],
    creator: '@horizonskincare',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  alternates: {
    canonical: 'https://horizonskincare.online/',
  },
  verification: {
    google: 'google-site-verification-code',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="vi" className={inter.className}>
      <head>
        {/* Structured data improves SEO and helps search engines understand your site. */}
        <StructuredData />
      </head>
      <body>
        {/* Global site tag for Google Analytics, injected only when the
            corresponding environment variable is provided. */}
        <GoogleAnalytics />
        {children}
      </body>
    </html>
  );
}