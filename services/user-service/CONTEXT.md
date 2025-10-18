Context - User Service (Node.js/TypeScript)

- Mục đích
  - Quản lý dữ liệu/hồ sơ người dùng, lịch sử phân tích, tùy chọn, avatar, bảo mật tài khoản (ngoài phần auth thuần JWT).

- Trạng thái hiện tại
  - Có `Dockerfile`, `package.json` placeholder. Chưa có mã nguồn (controller/model/route).

- Nghiệp vụ dự kiến
  - CRUD users (khác Auth: không xử lý password), profile, cập nhật skin type, thống kê cơ bản.
  - Liên kết bảng `skin_analyses` để trả lịch sử phân tích theo user.

- CSDL
  - PostgreSQL (chia sẻ DB với Auth hoặc tách DB), sử dụng các bảng trong `database/init.sql`.

- API dự kiến
  - `GET/PUT /users/profile`, `GET /users/history`, upload avatar, đổi thông tin cá nhân.

- TODO/Gợi ý
  - Khởi tạo dự án TS/Express, module hóa layer (controller/service/repo), validate (Joi/Zod), error handling thống nhất.
  - Thêm test, CI, và Dockerfile hoàn chỉnh.

