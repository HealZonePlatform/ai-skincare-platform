// src/lib/analytics.ts
'use client';

declare global {
  interface Window {
    gtag: (...args: any[]) => void;
    hj: (...args: any[]) => void;
    clarity: (command: string, ...args: any[]) => void;
  }
}

export const trackEvent = (action: string, category: string, label: string, value?: number) => {
  // Google Analytics event tracking
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', action, {
      event_category: category,
      event_label: label,
      value: value,
    });
  }
  
  // Hotjar event tracking
  if (typeof window !== 'undefined' && window.hj) {
    window.hj('event', `${category}_${action}`, {
      label: label,
      value: value,
    });
  }
  
  // Microsoft Clarity event tracking
  if (typeof window !== 'undefined' && window.clarity) {
    window.clarity('set', `${category}_${action}`, label);
  }
}

export const trackPageView = (url: string) => {
  // Google Analytics page view tracking
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('config', process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID, {
      page_path: url,
    });
  }
};

export const trackButtonClick = (buttonName: string, location: string) => {
  trackEvent('click', 'button', `${buttonName}_${location}`);
};

export const trackFormSubmit = (formName: string, success: boolean) => {
  trackEvent('submit', 'form', `${formName}_${success ? 'success' : 'error'}`);
};

export const trackDownloadAttempt = (platform: string) => {
  trackEvent('download', 'app', platform);
};

export const trackEarlyAccessSignup = (email: string) => {
  trackEvent('signup', 'early_access', email);
};

export const trackScrollDepth = (depth: number) => {
  trackEvent('scroll', 'engagement', `${depth}%`);
};

// Initialize scroll depth tracking
export const initScrollTracking = () => {
  if (typeof window === 'undefined') return;
  
  let scrollDepthsTracked = [25, 50, 75, 100];
  let maxDepth = 0;
  
  const trackScroll = () => {
    const scrollTop = window.scrollY;
    const docHeight = document.body.scrollHeight - window.innerHeight;
    const scrollPercent = Math.round((scrollTop / docHeight) * 100);
    
    if (scrollPercent > maxDepth) {
      maxDepth = scrollPercent;
      
      // Track when reaching new depth milestones
      for (const depth of scrollDepthsTracked) {
        if (scrollPercent >= depth && !scrollDepthsTracked.includes(depth * -1)) {
          trackScrollDepth(depth);
          // Mark this depth as tracked by negating it
          scrollDepthsTracked = scrollDepthsTracked.map(d => d === depth ? -d : d);
          break;
        }
      }
    }
  };
  
  window.addEventListener('scroll', trackScroll);
  
  // Return cleanup function
  return () => {
    window.removeEventListener('scroll', trackScroll);
  };
};

// Track time on page
export const initTimeTracking = () => {
  if (typeof window === 'undefined') return;
  
  let startTime = Date.now();
  
  const trackTime = () => {
    const timeSpent = Math.round((Date.now() - startTime) / 1000); // in seconds
    
    // Track time spent in 30-second intervals up to 5 minutes
    if (timeSpent % 30 === 0 && timeSpent <= 300) {
      trackEvent('time_spent', 'engagement', `${timeSpent}s`);
    }
  };
  
  const interval = setInterval(trackTime, 1000);
  
  // Return cleanup function
  return () => {
    clearInterval(interval);
    const timeSpent = Math.round((Date.now() - startTime) / 1000);
    trackEvent('time_spent', 'engagement', `total_${timeSpent}s`);
  };
};

// Hotjar-specific functions
export const hotjarInitialize = (hjid: number, hjsv: number) => {
  if (typeof window !== 'undefined' && typeof window.hj === 'undefined') {
    (function(h: any, o: any, t: any, j: any) {
      h.hj = h.hj || function() { (h.hj.q = h.hj.q || []).push(arguments); };
      h._hjSettings = { hjid, hjsv };
      const a = o.getElementsByTagName('head')[0];
      const r = o.createElement('script'); r.async = 1;
      r.src = t + h._hjSettings.hjid + j + h._hjSettings.hjsv;
      a.appendChild(r);
    })(window, document, 'https://static.hotjar.com/c/hotjar-', '.js?sv=');
  }
};

export const hotjarTrack = (eventName: string, properties?: any) => {
  if (typeof window !== 'undefined' && window.hj) {
    window.hj('event', eventName, properties);
  }
};

// Microsoft Clarity-specific functions
export const clarityInitialize = (projectId: string) => {
  if (typeof window !== 'undefined' && typeof window.clarity === 'undefined') {
    (function(c: any, l: any, a: any, r: any, i: any) {
      c[a] = c[a] || function() { (c[a].q = c[a].q || []).push(arguments); };
      a = l.getElementsByTagName('head')[0];
      r = l.createElement('script'); r.async = 1; r.src = 'https://www.clarity.ms/tag/' + i;
      a.appendChild(r);
    })(window, document, 'clarity', 'script', projectId);
  }
};

export const clarityTrack = (eventName: string, eventProperties?: any) => {
  if (typeof window !== 'undefined' && window.clarity) {
    window.clarity('set', eventName, eventProperties);
  }
};

// Record user session events for behavior analysis
export const recordUserBehavior = (behaviorType: string, details: any) => {
  // Track in Google Analytics
  trackEvent('behavior', behaviorType, JSON.stringify(details));
  
  // Track in Hotjar
  hotjarTrack(behaviorType, details);
  
  // Track in Microsoft Clarity
  clarityTrack(behaviorType, details);
};

// Identify user for better analytics
export const identifyUser = (userId: string, traits?: any) => {
  // Google Analytics user identification
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('config', process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID, {
      user_id: userId,
      ...traits
    });
  }
  
  // Hotjar user identification
  if (typeof window !== 'undefined' && window.hj) {
    window.hj('identify', userId, traits);
  }
  
  // Microsoft Clarity user identification
  if (typeof window !== 'undefined' && window.clarity) {
    window.clarity('identify', userId, JSON.stringify(traits));
  }
};