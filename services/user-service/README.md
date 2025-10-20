# HealZone User Service — v2 (No overlap with Auth, `/api/v1/me`)

**Mục tiêu**: tránh trùng lặp với `auth-service` bằng cách:
- Đổi prefix endpoint thành `/api/v1/me/*` (không dùng `/users/*`).
- Không join/không FK sang bảng `users`: lưu `user_id` UUID độc lập; email/role lấy từ JWT claim.
- Giữ chức năng: profile mở rộng, thói quen sinh hoạt, nhắc nhở, mục tiêu, lịch sử phân tích.

## Endpoints
- `GET /api/v1/me/profile` — lấy hồ sơ (trả kèm `user_id` + `email` từ JWT).
- `PUT /api/v1/me/profile`
- `GET /api/v1/me/history?limit=30&offset=0`
- `GET /api/v1/me/reminders` • `PUT /api/v1/me/reminders`
- `GET /api/v1/me/lifestyle` • `PUT /api/v1/me/lifestyle`
- `GET /api/v1/me/goals` • `PUT /api/v1/me/goals`

## DB schema (PostgreSQL, không FK sang `users`)
Xem `sql/001_init_user_service_v2.sql`. Các bảng:
- `user_profiles`, `user_lifestyle`, `user_reminders`, `user_goals`.
- `skin_analyses` (tuỳ chọn, nếu service khác không own).

## Chạy local
```bash
cp .env.example .env
npm ci
npm run db:migrate
npm run dev
# -> http://localhost:3004/health
```

## Tích hợp Gateway
- Map `/auth/*` → auth-service; `/me/*` → user-service v2.
- Forward header `Authorization` (bearer).

## Gợi ý dùng Shared Library
Thư mục `../hz-shared` (đính kèm) cung cấp `hz-shared` chứa:
- `jwt` helpers, `ApiError`, `wrapAsync`, `validate()`.
- `pgPool()` wrapper + `healthCheck()` dùng chung.
Bạn có thể thay import trong user-service v2 để dùng shared lib cho giảm lặp.
