Context - Infra/Postgres Init

- Mục đích
  - Script init PostgreSQL tối giản cho môi trường infra/container.

- Tệp chính
  - `infra/postgres/init.sql`: Tạo `users`, `skin_analyses`, index, trigger `updated_at`; log thông báo init.

- Khác biệt so với `database/init.sql`
  - Bản infra tối giản hơn (ít cột/hạn chế so với bản đầy đủ trong `database/`).

- Gợi ý
  - Chọn một nguồn schema chuẩn (database/) và dùng cùng một script để tránh lệch cấu trúc.

