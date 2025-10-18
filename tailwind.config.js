/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        /**
         * Custom brand palette inspired by the Figma mobile designs.
         *
         * primary – warm orange used for primary call‑to‑action buttons and highlights.
         * secondary – muted brown/taupe tones for backgrounds and secondary elements.
         * neutral – light cream tones for backgrounds and gradients.
         * darkmode – deep purples for potential dark‑mode components or contrast blocks.
         * olive – rich olive green for icons and subtle accents.
         */
        primary: {
          50:  '#FFF7D3', // very light cream
          100: '#FCEED2',
          200: '#F7D9A3',
          300: '#F0C583',
          400: '#E8AB5C',
          500: '#E69534', // main accent orange
          600: '#D7842C',
          700: '#B36922',
          800: '#94571B',
          900: '#7A4716'
        },
        secondary: {
          50:  '#F5E8C3', // very light beige
          100: '#E9D8BB',
          200: '#CBB79A',
          300: '#B79D7F',
          400: '#977E64',
          500: '#A78B6D', // main taupe
          600: '#8F755C',
          700: '#705C47',
          800: '#554037',
          900: '#4A372E'
        },
        neutral: {
          50:  '#FFF7D3',
          100: '#F5E8C3',
          200: '#EADABA'
        },
        darkmode: {
          500: '#44186C',
          600: '#652D8F',
          700: '#552A78'
        },
        olive: {
          500: '#5B6239'
        }
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.5s ease-out',
        'slide-down': 'slideDown 0.5s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      }
    },
  },
  plugins: [],
}