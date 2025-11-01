/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  reactStrictMode: true,
  experimental: {
    typedRoutes: true,
    serverActions: false
  },
  images: {
    unoptimized: true
  }
};

module.exports = nextConfig;
