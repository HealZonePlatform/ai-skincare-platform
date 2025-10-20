Context - Infra/Postgres Init

- Mục đích
  - Script init PostgreSQL cho môi trường infra/container, đồng bộ với schema chuẩn.

- Tệp chính
  - `infra/postgres/init.sql`: Tạo schema đầy đủ bao gồm `users`, `skin_analyses`, `refresh_tokens`, index, trigger `updated_at`, views và dữ liệu mẫu; log thông báo init.

- Đồng bộ hóa
  - Bản infra hiện đã đồng bộ hoàn toàn với `database/init.sql` để đảm bảo nhất quán schema.

- Gợi ý
  - Cả hai tệp `infra/postgres/init.sql` và `database/init.sql` giờ đây có cùng schema, không cần phải duy trì hai phiên bản khác nhau.

