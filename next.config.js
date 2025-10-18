/** @type {import('next').NextConfig} */
module.exports = {
  // xuất site tĩnh cho GitHub Pages
  output: 'export',

  // Vì bạn dùng custom domain (root domain), KHÔNG có subpath,
  // nên để trống cả basePath và assetPrefix để _next/static tải đúng.
  basePath: '',
  assetPrefix: '',

  // Để Next export ảnh mà không qua Image Optimization server
  images: { unoptimized: true },
};
