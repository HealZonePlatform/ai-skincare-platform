HealZone Backend Services Implementation Guide - User Service v2 & Shared Library

# Hướng Dẫn Implement User Service v2 và Shared Library

## Tổng Quan

Tài liệu này cung cấp hướng dẫn chi tiết để implement User Service v2 và tích hợp Shared Library trong hệ thống microservices của HealZone platform. User Service v2 được thiết kế để tránh trùng lặp với auth-service bằng cách sử dụng endpoint `/api/v1/me/*` thay vì `/users/*`, không có foreign key sang bảng `users` mà lưu `user_id` UUID độc lập, lấy email/role từ JWT claim.

## Cấu trúc thư mục

Sau khi giải nén, bạn sẽ có hai thư mục mới trong thư mục `services/`:

- `user-service-skeleton-v2/` - Skeleton cho User Service v2
- `hz-shared/` - Thư viện dùng chung cho các microservices

## Shared Library

### Tổng quan

Shared Library (`hz-shared`) là thư viện dùng chung cho các microservices, cung cấp các chức năng thường dùng:

- `jwt` helpers - Hỗ trợ xác thực và xử lý JWT tokens
- `ApiError` - Lớp lỗi chuẩn cho các service
- `validate()` - Middleware xác thực request
- `pgPool()` wrapper và `healthCheck()` - Wrapper cho PostgreSQL và kiểm tra sức khỏe database

### Cài đặt và sử dụng

1. Trong package.json của service, thêm dependency:
```json
{
  "dependencies": {
    "hz-shared": "file:../hz-shared"
  }
}
```

2. Sau đó chạy `npm install` để cài đặt

3. Import các module trong service:
```ts
import { jwtUtil, errors, validate, db } from 'hz-shared';
```

### Các module trong thư viện

#### jwt.ts
- `verify(token: string, secret: string): JwtUser` - Xác minh JWT token và trả về thông tin người dùng
- `JwtUser` interface: `{ id: string; email?: string; role?: string }`

#### errors.ts
- `ApiError` class: Lỗi có status code
- `notFound()`, `unauthorized()`, `forbidden()` - Các hàm tiện ích tạo lỗi chuẩn

#### validate.ts
- `validate(schema: ZodSchema, source: 'body'|'query'|'params')` - Middleware xác thực request với Zod schema

#### pg.ts
- `pgPool(config)` - Tạo PostgreSQL connection pool với kiểm tra sức khỏe

## User Service v2

### Mục tiêu thiết kế

- Tránh trùng lặp với `auth-service` bằng cách:
  - Đổi prefix endpoint thành `/api/v1/me/*` (không dùng `/users/*`)
  - Không join/không FK sang bảng `users`: lưu `user_id` UUID độc lập; email/role lấy từ JWT claim
  - Giữ chức năng: profile mở rộng, thói quen sinh hoạt, nhắc nhở, mục tiêu, lịch sử phân tích

### Endpoints

- `GET /api/v1/me/profile` — lấy hồ sơ (trả kèm `user_id` + `email` từ JWT)
- `PUT /api/v1/me/profile`
- `GET /api/v1/me/history?limit=30&offset=0`
- `GET /api/v1/me/reminders` • `PUT /api/v1/me/reminders`
- `GET /api/v1/me/lifestyle` • `PUT /api/v1/me/lifestyle`
- `GET /api/v1/me/goals` • `PUT /api/v1/me/goals`

### Schema cơ sở dữ liệu

User Service v2 sử dụng PostgreSQL với các bảng không có foreign key sang bảng `users`:

- `user_profiles` - Thông tin hồ sơ người dùng
- `user_lifestyle` - Thói quen sinh hoạt của người dùng
- `user_reminders` - Nhắc nhở của người dùng
- `user_goals` - Mục tiêu của người dùng
- `skin_analyses` - (tùy chọn) lịch sử phân tích da

Xem chi tiết trong `sql/001_init_user_service_v2.sql`.

### Cài đặt và chạy thử

1. Sao chép file môi trường:
```bash
cp .env.example .env
```

2. Cài đặt dependencies:
```bash
npm ci
```

3. Chạy migration database:
```bash
npm run db:migrate
```

4. Chạy service ở chế độ development:
```bash
npm run dev
```

Service sẽ chạy trên cổng 3004: `http://localhost:3004/health`

### Cấu hình môi trường

File `.env` cần chứa các biến sau:

- `PORT` - Cổng chạy service (mặc định 3004)
- `DB_HOST` - Host của PostgreSQL
- `DB_PORT` - Cổng của PostgreSQL (mặc định 5432)
- `DB_NAME` - Tên database
- `DB_USER` - Username của database
- `DB_PASSWORD` - Password của database
- `JWT_ACCESS_SECRET` - Secret key để xác minh JWT
- `ALLOWED_ORIGINS` - Danh sách các origin được phép truy cập (cách nhau bằng dấu phẩy)

### Tích hợp với Gateway

- Map `/auth/*` → auth-service; `/me/*` → user-service v2
- Forward header `Authorization` (bearer) để xác thực JWT

### Sử dụng Shared Library trong User Service

User Service v2 đã được cấu hình sẵn để sử dụng Shared Library. Bạn có thể thay đổi các import trong service để dùng các module từ `hz-shared`:

```ts
// Thay vì sử dụng các hàm được định nghĩa trong service
import { jwtUtil, errors, validate, db } from 'hz-shared';

// Ví dụ sử dụng validate middleware
import { validate } from 'hz-shared';
app.post('/api/v1/me/profile', validate(profileSchema, 'body'), profileController.update);

// Ví dụ sử dụng ApiError
import { errors } from 'hz-shared';
throw errors.unauthorized();
```

## Các bước triển khai cụ thể

### Bước 1: Cài đặt môi trường

1. Đảm bảo PostgreSQL đang chạy
2. Tạo database mới cho User Service v2
3. Cập nhật file `.env` với thông tin kết nối database

### Bước 2: Cài đặt dependencies

```bash
cd services/user-service-skeleton-v2
npm install
```

### Bước 3: Chạy migration

```bash
npm run db:migrate
```

### Bước 4: Tùy chỉnh các thành phần

1. Cập nhật các controller trong `src/controllers/me.controller.ts` để xử lý logic nghiệp vụ
2. Cập nhật các service trong `src/services/me.service.ts` để thực hiện các thao tác nghiệp vụ
3. Cập nhật các repository trong `src/repositories/` để thực hiện các thao tác với database
4. Thêm xác thực và kiểm tra lỗi nếu cần

### Bước 5: Kiểm tra và chạy

1. Chạy service ở chế độ development:
```bash
npm run dev
```

2. Kiểm tra endpoint health: `http://localhost:3004/health`

3. Kiểm tra các endpoint API theo tài liệu

### Bước 6: Tích hợp với hệ thống

1. Cập nhật API Gateway để route các endpoint `/api/v1/me/*` đến User Service v2
2. Đảm bảo JWT được truyền đúng cách từ Gateway đến service
3. Kiểm tra tích hợp với các service khác nếu cần

## Lưu ý khi phát triển

- Luôn sử dụng UUID cho `user_id` thay vì auto-increment ID
- Không thực hiện JOIN với bảng `users` từ auth-service
- Chỉ lấy thông tin người dùng từ JWT claims
- Sử dụng các hàm từ Shared Library để đảm bảo tính nhất quán
- Tuân thủ các quy tắc đặt tên và kiểu dữ liệu như trong tài liệu
- Thêm logging và monitoring nếu cần thiết
- Viết unit test cho các module quan trọng

## Mở rộng trong tương lai

- Thêm các endpoint mới theo nhu cầu nghiệp vụ
- Tích hợp với các hệ thống bên ngoài (email, notification, etc.)
- Thêm các tính năng caching nếu cần
- Tối ưu hiệu suất và bảo mật
