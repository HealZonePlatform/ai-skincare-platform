'use client';

import Script from 'next/script';
import { usePathname, useSearchParams } from 'next/navigation';
import { useEffect, Suspense } from 'react';

// ✅ Tách phần tracking ra component riêng
function GATracking() {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    const url = pathname + searchParams.toString();
    
    // @ts-ignore
    if (window.gtag) {
      // @ts-ignore
      window.gtag('config', process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID, {
        page_path: url,
      });
    }
  }, [pathname, searchParams]);

  return null;
}

const GoogleAnalytics = () => {
  // If no Google Analytics ID is provided at build time, don't render
  // any GA scripts. Without this guard the template strings below will
  // expand `undefined` which leads to invalid script URLs and runtime
  // errors on the deployed static site.
  if (!process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID) {
    return null;
  }

  return (
    <>
      <Script
        strategy="afterInteractive"
        src={`https://www.googletagmanager.com/gtag/js?id=${process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID}`}
      />
      <Script
        id="gtag-init"
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '${process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID}', {
              page_path: window.location.pathname,
            });
          `,
        }}
      />
      <Script
        id="gtag-event-tracking"
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `
            // Enhanced event tracking for button clicks and other interactions
            window.addEventListener('click', function(e) {
              // Track button clicks
              if (e.target && e.target.tagName === 'BUTTON') {
                const button = e.target;
                const buttonText = button.textContent || button.innerText || button.value || '';
                const buttonId = button.id || '';
                const buttonClass = button.className || '';
                
                if (window.gtag) {
                  window.gtag('event', 'click', {
                    event_category: 'engagement',
                    event_label: 'Button Click: ' + buttonText + ' | ID: ' + buttonId + ' | Class: ' + buttonClass,
                    non_interaction: false
                  });
                }
              }
              
              // Track link clicks
              let element = e.target;
              while (element && element !== document) {
                if (element.tagName === 'A') {
                  const link = element;
                  const linkText = link.textContent || link.innerText || '';
                  const linkUrl = link.href || '';
                  
                  if (window.gtag) {
                    window.gtag('event', 'click', {
                      event_category: 'engagement',
                      event_label: 'Link Click: ' + linkText + ' | URL: ' + linkUrl,
                      non_interaction: false
                    });
                  }
                  break;
                }
                element = element.parentElement;
              }
            });
          `,
        }}
      />
      
      {/* ✅ Wrap component tracking trong Suspense */}
      <Suspense fallback={null}>
        <GATracking />
      </Suspense>
    </>
  );
};

export default GoogleAnalytics;
