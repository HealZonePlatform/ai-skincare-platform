Context - Deploy (Landing Copy)

- Mục đích
  - Bản cấu hình/triển khai landing tách riêng, có workflow riêng (`frontend/deploy/.github/workflows/deploy.yml`).

- Trạng thái
  - Nội dung tương tự `frontend/landing-website` (Next 14, Tailwind, v.v.).

- Lưu ý
  - Dễ phát sinh trôi nội dung so với `landing-website`. Khuyến nghị hợp nhất và chỉ giữ một nguồn sự thật, hoặc tự động đồng bộ.

- TODO/Gợi ý
  - Xác định chiến lược: (1) giữ một project, nhiều env; hoặc (2) giữ 2 bản nhưng có script sync/CI đảm bảo đồng bộ.

