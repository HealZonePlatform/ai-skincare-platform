const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true,
  },
  basePath: process.env.NODE_ENV === 'production' ? '/ai-skincare-platform' : '',
  assetPrefix: process.env.NODE_ENV === 'production' ? '/ai-skincare-platform/' : '',
};

module.exports = nextConfig;