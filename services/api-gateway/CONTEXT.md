Context - API Gateway (Node.js)

- Mục đích
  - Điểm vào duy nhất cho client: định tuyến request đến microservices (auth, user, product, ai, recommendation...), áp dụng cross-cutting concerns.

- Trạng thái hiện tại
  - Đã có mã nguồn hoàn chỉnh với cấu trúc: app.ts, server.ts, config/, middlewares/, types/
  - Đã có các middleware: auth, errorHandler, notFound, rateLimiter
  - Đã có cấu hình TypeScript và Express
  - Đã có Dockerfile hoàn chỉnh

- Vai trò dự kiến
  - Routing, auth (validate JWT), CORS, rate limiting, logging, API versioning, tổng hợp response khi cần.

- Kết nối downstream
  - `auth-service` (cổng 3001) và các service khác (user/product/ai/recommendation...), cấu hình qua biến môi trường.

- TODO/Gợi ý
  - Middleware JWT xác thực, mapping route → service, circuit breaker/retry.
  - Thêm cấu hình Docker + CI workflow tương ứng (tham khảo `.github/workflows/ci-*`).
