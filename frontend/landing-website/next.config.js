/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true,
  },
  basePath: process.env.NODE_ENV === 'production' ? '/ai-skincare-platform' : '',
  assetPrefix: process.env.NODE_ENV === 'production' ? '/ai-skincare-platform/' : '',
  
  // Enable gzip compression
  compress: true,
  
  // Webpack configuration for production optimization
  webpack: (config, { dev, isServer }) => {
    // Minimize JS in production
    if (!dev) {
      config.optimization.minimize = true;
    }
    
    return config;
  },
};

module.exports = nextConfig;