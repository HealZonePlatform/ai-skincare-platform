Context - Mobile App (Flutter)

- Mục đích
  - Ứng dụng di động cho người dùng cuối: đăng ký/đăng nhập, chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm, quản lý hồ sơ.

- Công nghệ chính
  - Flutter (Dart), Provider (state management), Dio (HTTP), Secure Storage (lưu token an toàn).

- Tệp/thư mục quan trọng
  - `frontend/mobile_app/lib/main.dart`: Khởi tạo app, theme, điều hướng dựa trên `AuthProvider.isLoggedIn`.
  - `frontend/mobile_app/lib/providers/auth_provider.dart`: Quản lý trạng thái xác thực, login/register, lưu token.
  - `frontend/mobile_app/lib/services/secure_storage_service.dart`: Lưu/đọc/xóa access/refresh token.
  - `frontend/mobile_app/lib/api/auth_api_service.dart`: API client cho auth (login/register/refresh), xử lý lỗi Dio.
  - `frontend/mobile_app/lib/utils/api_constants.dart`: Định nghĩa baseUrl/endpoints, timeout (đang hard-code IP cục bộ).
  - `frontend/mobile_app/lib/config/environment.dart`: Nguồn sự thật cho cấu hình runtime (API_BASE_URL, timeout, version).
  - `frontend/mobile_app/lib/screens/*`: Màn hình `auth/login`, `auth/register`, `home`, `profile/*`, `analyses/*`.

- Cấu hình/biến môi trường
  - Sử dụng `String.fromEnvironment('API_BASE_URL')` trong `environment.dart` để build-time inject endpoint.
  - Hiện tại `api_constants.dart` hard-code `192.168.56.1:3001` → khuyến nghị đồng bộ sang `Environment.apiBaseUrlWithVersion`.

- Chạy local
  - Flutter SDK + thiết bị/emulator.
  - `flutter pub get`, sau đó `flutter run` trong `frontend/mobile_app`.

- Luồng chính
  - Đăng nhập/đăng ký → nhận `accessToken`/`refreshToken` → lưu secure storage → `isLoggedIn=true` → vào `HomeScreen`.
  - API gọi tới Auth Service: `/api/v1/auth/*` (qua `AuthApiService`).

- Tích hợp backend
  - Phụ thuộc Auth Service (cổng `3001` theo mặc định docker-compose cho service auth).
  - Cần đồng bộ base URL với môi trường (dev/staging/prod).

- TODO/Gợi ý
  - Refactor `ApiConstants` dùng `Environment.apiBaseUrlWithVersion` để tránh hard-code.
  - Bổ sung interceptor tự động refresh token, attach Authorization header.
  - Thêm test widget và integration mock API.

