/**
 * Next.js configuration for the Horizon Skincare landing page.
 *
 * We use the static export feature (`output: 'export'`) to generate a
 * fully static site that can be served from GitHub Pages or any static
 * hosting platform. Because the site is deployed on a custom root
 * domain (horizonskincare.online), there is no subpath. Both
 * `basePath` and `assetPrefix` are therefore left empty so that
 * Next.js references assets correctly (e.g. `_next/static/...`).
 */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: false, // Đổi từ true sang false để kích hoạt tối ưu hóa hình ảnh
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'horizonskincare.online',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'lh3.googleusercontent.com',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'firebasestorage.googleapis.com',
        port: '',
        pathname: '/**',
      }
    ],
    formats: ['image/webp', 'image/avif'], // Hỗ trợ các định dạng hình ảnh hiện đại
    minimumCacheTTL: 60, // Thời gian cache tối thiểu là 60 giây
  },
  basePath: '',
  assetPrefix: '',
};

export default nextConfig;