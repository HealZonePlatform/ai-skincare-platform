'use client';

import { useEffect } from 'react';
import Header from '@/components/Header';
import Hero from '@/components/Hero';
import Features from '@/components/Features';
import HowItWorks from '@/components/HowItWorks';
import Testimonials from '@/components/Testimonials';
import Benefits from '@/components/Benefits';
import AppShowcase from '@/components/AppShowcase';
import TechnologyStack from '@/components/TechnologyStack';
import CallToAction from '@/components/CallToAction';
import Contact from '@/components/Contact';
import Footer from '@/components/Footer';
import FAQSection from '@/components/sections/FAQ';
import SocialProof from '@/components/SocialProof';

export default function Home() {
  useEffect(() => {
    // Initialize analytics tracking
    if (typeof window !== 'undefined') {
      // Scroll depth tracking
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
              // Track scroll depth event
              if (window.gtag) {
                window.gtag('event', 'scroll_depth', {
                  event_category: 'engagement',
                  event_label: `${depth}%`,
                  value: depth,
                });
              }
              
              // Mark this depth as tracked by negating it
              scrollDepthsTracked = scrollDepthsTracked.map(d => d === depth ? -d : d);
              break;
            }
          }
        }
      };
      
      window.addEventListener('scroll', trackScroll);
      
      // Time on page tracking
      let startTime = Date.now();
      const timeInterval = setInterval(() => {
        const timeSpent = Math.round((Date.now() - startTime) / 1000); // in seconds
        
        // Track time spent in 30-second intervals up to 5 minutes
        if (timeSpent % 30 === 0 && timeSpent <= 300) {
          if (window.gtag) {
            window.gtag('event', 'time_spent', {
              event_category: 'engagement',
              event_label: `${timeSpent}s`,
              value: timeSpent,
            });
          }
        }
      }, 10);
      
      // Cleanup functions
      return () => {
        window.removeEventListener('scroll', trackScroll);
        clearInterval(timeInterval);
        
        // Track total time on page
        const totalTime = Math.round((Date.now() - startTime) / 1000);
        if (window.gtag) {
          window.gtag('event', 'time_spent', {
            event_category: 'engagement',
            event_label: `total_${totalTime}s`,
            value: totalTime,
          });
        }
      };
    }
  }, []);
  
  return (
    <main>
      <Header />
      <Hero />
      <Features />
      <HowItWorks />
      <Testimonials />
      <Benefits />
      <AppShowcase />
      <TechnologyStack />
      <CallToAction />
      <FAQSection />
      {/* <SocialProof /> */}
      <Contact />
      <Footer />
    </main>
  );
}