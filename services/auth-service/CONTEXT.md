Context - Auth Service (Node.js/TypeScript)

- Mục đích
  - Cung cấp xác thực/ủy quyền: đăng ký/đăng nhập, refresh token, logout, profile; quản lý JWT + blacklist, lưu refresh token.

- Công nghệ chính
  - Node.js 18, TypeScript, Express, PostgreSQL (`pg`), Redis, JWT, Joi (validate), Helmet/CORS/Rate limit, Winston (log).

- Cấu trúc & tệp chính
  - `services/auth-service/src/server.ts`: Bootstrap, kiểm tra health DB/Redis, lắng nghe cổng, graceful shutdown.
  - `services/auth-service/src/app.ts`: Middlewares bảo mật, rate limit, CORS, body parser, routes `/api/v1/auth`, 404 + error handler.
  - `services/auth-service/src/routes/auth.routes.ts`: Định tuyến `register/login/refresh/logout/profile`, health route.
  - `services/auth-service/src/controllers/auth.controller.ts`: Xử lý request, response chuẩn hoá (success/error), không lộ lỗi nhạy cảm.
  - `services/auth-service/src/services/auth.service.ts`: Logic nghiệp vụ (hash/check password, generate tokens, Redis lưu token, blacklist, refresh flow).
  - `services/auth-service/src/models/user.model.ts`: CRUD user qua PostgreSQL (bảng `users`).
  - `services/auth-service/src/config/database.ts`: Pool PG, retry, `healthCheck()`, query wrapper, close.
  - `services/auth-service/src/config/redis.ts`: Redis client, retry, get/set/del, `healthCheck()`, close.
  - `services/auth-service/src/utils/jwt.util.ts`: Tạo/kiểm tra access/refresh token, TTL, decode, validate config.
  - `services/auth-service/src/validators/auth.validator.ts`: Joi schema cho register/login/refresh/logout.
  - `services/auth-service/src/middlewares/*`: `auth.middleware` (verify access/refresh + blacklist), `validation`, `error`.
  - `services/auth-service/src/types/*`: Kiểu `AuthenticatedRequest`, `ApiResponse`, tiện ích type handler.

- API endpoints (prefix: `/api/v1/auth`)
  - `POST /register` → tạo user, trả về `{ user, tokens }`.
  - `POST /login` → xác thực, trả về `{ user, tokens }`.
  - `POST /refresh` → cần `refreshToken` hợp lệ + không blacklist, sinh token mới.
  - `POST /logout` → blacklist access/refresh, xóa refresh token trong Redis.
  - `GET /profile` → trả về profile cơ bản từ payload JWT (đã verify access token).
  - `GET /health` → kiểm tra dịch vụ.

- Cơ sở dữ liệu & cache
  - PostgreSQL: bảng `users`, `skin_analyses`, `refresh_tokens` (DDL tại `database/init.sql`).
  - Redis: key `refresh_<userId>` lưu refresh token; `blacklist_<token>` để thu hồi.

- Biến môi trường quan trọng
  - PostgreSQL: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`.
  - Redis: `REDIS_URL` (ví dụ `redis://redis:6379`).
  - JWT: `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `JWT_ACCESS_EXPIRY` (vd `15m`), `JWT_REFRESH_EXPIRY` (vd `7d`).
  - CORS: `ALLOWED_ORIGINS`.

- Chạy local
  - Cần Postgres + Redis (dùng `docker-compose.yml` root: services `postgres`, `redis`, `auth-service`).
  - Trong thư mục service: `npm ci`, `npm run dev` hoặc build: `npm run build` + run: `npm start`.

- Docker/Deploy
  - Dockerfile multi-stage, healthcheck GET `/health`, user non-root, expose `3001`.

- Luồng nghiệp vụ chính
  - Đăng ký/đăng nhập → hash/check password → tạo access/refresh → lưu refresh vào Redis → trả response chuẩn.
  - Refresh → verify refresh (chữ ký + tồn tại trong Redis + chưa blacklist) → blacklist cũ → cấp token mới.
  - Logout → blacklist 2 token → xóa refresh khỏi Redis.

- TODO/Gợi ý
  - Bổ sung test (Jest) cho service/middleware/utils.
  - Triển khai logger (Winston) vào các lớp để theo dõi sự kiện.
  - Thêm rate limit chi tiết theo route nhạy cảm; chuẩn hoá CORS theo môi trường.

