import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/features/**/*.{js,ts,jsx,tsx,mdx}',
    './src/lib/**/*.{js,ts,jsx,tsx,mdx}'
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '#6C5CE7',
          foreground: '#ffffff',
          subtle: '#E7E4FF',
          muted: '#A99EF8',
          dark: '#4834D4'
        },
        accent: {
          peach: '#FFB7B2',
          mint: '#A8E6CF'
        },
        success: '#34D399',
        info: '#38BDF8',
        warning: '#F59E0B',
        danger: '#EF4444'
      },
      fontFamily: {
        sans: ['"Inter"', 'system-ui', 'sans-serif'],
        display: ['"Cal Sans"', 'Inter', 'system-ui', 'sans-serif']
      },
      borderRadius: {
        xl: '1.25rem'
      },
      boxShadow: {
        soft: '0 10px 40px rgba(53, 72, 91, 0.08)'
      }
    }
  },
  plugins: []
};

export default config;
