Context - Database (PostgreSQL Schema)

- Mục đích
  - Định nghĩa schema quan hệ cho người dùng và phân tích da, hỗ trợ Auth/User services.

- Tệp chính
  - `database/init.sql`: Khởi tạo extensions, bảng `users`, `skin_analyses`, `refresh_tokens`, index/trigger/views, seed mẫu.

- Bảng & chỉ số chính
  - `users`: thông tin người dùng, ràng buộc unique email, trạng thái hoạt động/xác minh; index: email/active/verified/skin_type/created_at.
  - `skin_analyses`: kết quả phân tích AI, JSONB kết quả/khuyến nghị, severity, concerns[]; index GIN cho JSONB và concerns.
  - `refresh_tokens`: lưu token refresh (hash), expires_at, revoked, device/ip.

- Trigger/Function
  - `update_updated_at_column()` + trigger cập nhật `updated_at` tự động trên các bảng chính.

- Seed/Ví dụ
  - Admin/demo user được chèn nếu chưa tồn tại.

- Sử dụng với docker-compose
  - Service `postgres` mount `./database/init.sql` vào `/docker-entrypoint-initdb.d/init.sql` để tự khởi tạo.

