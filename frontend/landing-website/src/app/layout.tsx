import './globals.css';
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import GoogleAnalytics from '@/components/GoogleAnalytics';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: {
    default: 'AI Skincare Platform | Transform Your Skincare Journey',
    template: '%s | AI Skincare Platform'
  },
  description: 'Get professional skin analysis and personalized recommendations with our AI-powered skincare platform. 96% accuracy, 30-second analysis.',
  keywords: ['AI skincare', 'skin analysis', 'personalized skincare', 'dermatology AI', 'beauty tech', 'skincare routine', 'skincare app', 'AI beauty'],
  authors: [{ name: 'HealZone Platform' }],
  creator: 'HealZone Platform',
  publisher: 'HealZone Platform',
  openGraph: {
    title: 'AI Skincare Platform | Transform Your Skincare Journey',
    description: 'Get professional skin analysis and personalized recommendations with our AI-powered skincare platform. 96% accuracy, 30-second analysis.',
    url: 'https://healzoneplatform.github.io/ai-skincare-platform/',
    siteName: 'AI Skincare Platform',
    images: [
      {
        url: '/ai-skincare-platform/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'AI Skincare Platform - Transform Your Skincare Journey',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'AI Skincare Platform | Transform Your Skincare Journey',
    description: 'Get professional skin analysis and personalized recommendations with our AI-powered skincare platform.',
    images: ['/ai-skincare-platform/og-image.jpg'],
    creator: '@healzoneplatform'
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
    canonical: 'https://healzoneplatform.github.io/ai-skincare-platform/',
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
    <html lang="en">
      <head>
        <link rel="icon" href="/ai-skincare-platform/favicon.ico" />
        <link rel="apple-touch-icon" href="/ai-skincare-platform/apple-touch-icon.png" />
        <link rel="manifest" href="/ai-skincare-platform/site.webmanifest" />
        
        {/* Structured Data */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "WebSite",
              "name": "AI Skincare Platform",
              "url": "https://healzoneplatform.github.io/ai-skincare-platform/",
              "description": "Get professional skin analysis and personalized recommendations with our AI-powered skincare platform. 96% accuracy, 30-second analysis.",
              "publisher": {
                "@type": "Organization",
                "name": "HealZone Platform",
                "logo": {
                  "@type": "ImageObject",
                  "url": "https://healzoneplatform.github.io/ai-skincare-platform/logo.png"
                }
              }
            })
          }}
        />
        
        {/* Hotjar Tracking Code */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function(h,o,t,j,a,r){
                h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
                h._hjSettings={hjid:${process.env.NEXT_PUBLIC_HOTJAR_ID},hjsv:6};
                a=o.getElementsByTagName('head')[0];
                r=o.createElement('script');r.async=1;
                r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
                a.appendChild(r);
              })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
            `
          }}
        />
        
        {/* Microsoft Clarity Tracking Code */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function(c,l,a,r,i,t,y){
                c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
                t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
                y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
              })(window, document, "clarity", "script", "${process.env.NEXT_PUBLIC_CLARITY_ID}");
            `
          }}
        />
      </head>
      <body className={inter.className}>
        {children}
        <GoogleAnalytics />
      </body>
    </html>
  );
}
