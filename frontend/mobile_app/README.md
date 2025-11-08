# HealZone Mobile App

Ứng dụng di động HealZone là một nền tảng chăm sóc da dựa trên AI, cho phép người dùng chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm phù hợp và quản lý hồ sơ chăm sóc da cá nhân.

## Tính năng chính

- **Phân tích da bằng AI**: Chụp ảnh da và nhận phân tích chi tiết về tình trạng da
- **Xác thực người dùng**: Đăng ký/đăng nhập với cơ chế bảo mật cao
- **Quản lý hồ sơ**: Xem và cập nhật thông tin cá nhân, lịch sử phân tích da
- **Gợi ý sản phẩm**: Đề xuất sản phẩm chăm sóc da phù hợp dựa trên phân tích
- **Theo dõi tiến trình**: Theo dõi sự cải thiện của làn da theo thời gian
- **Tự động refresh token**: Cơ chế xác thực tự động với refresh token
- **Local cache**: Cải thiện trải nghiệm người dùng với cache dữ liệu cục bộ

## Kiến trúc

Ứng dụng được xây dựng theo mô hình clean architecture với 3 layer:

- **Presentation**: UI, providers, screens, widgets
- **Domain**: Entities, use cases, repositories interfaces
- **Data**: Repository implementations, data sources

## Công nghệ sử dụng

- **Flutter**: Framework đa nền tảng
- **Dart**: Ngôn ngữ lập trình
- **Provider**: Quản lý trạng thái
- **Dio**: HTTP client với interceptor
- **flutter_secure_storage**: Lưu trữ token an toàn
- **go_router**: Điều hướng
- **cached_network_image**: Cache hình ảnh

## Cài đặt

1. Đảm bảo bạn đã cài đặt Flutter SDK
2. Clone repository
3. Di chuyển đến thư mục `frontend/mobile_app`
4. Chạy lệnh `flutter pub get` để cài đặt các dependency

## Chạy ứng dụng

```bash
# Chạy ứng dụng với môi trường development (mặc định)
flutter run

# Chạy với môi trường cụ thể
flutter run --dart-define=APP_ENV=staging
flutter run --dart-define=APP_ENV=production
```

## Cấu hình môi trường

Ứng dụng hỗ trợ 3 môi trường:
- `development` (mặc định): http://192.168.56.1:3001
- `staging`: https://staging-api.healzone.app
- `production`: https://api.healzone.app

Bạn có thể ghi đè các giá trị cấu hình qua các biến môi trường:
- `API_BASE_URL`: Ghi đè URL cơ sở
- `API_VERSION`: Phiên bản API (mặc định: v1)
- `API_CONNECT_TIMEOUT_MS`: Timeout kết nối (mặc định: 15000ms)
- `API_RECEIVE_TIMEOUT_MS`: Timeout nhận dữ liệu (mặc định: 15000ms)
- `API_SEND_TIMEOUT_MS`: Timeout gửi dữ liệu (mặc định: 15000ms)
- `API_STRICT_SSL`: Bật/tắt xác minh SSL (mặc định: true với production)

## Cấu trúc thư mục

```
lib/
├── main.dart                           # Điểm vào ứng dụng
├── config/                            # Cấu hình runtime
│   └── environment.dart               # Cấu hình theo môi trường
├── core/                              # Lõi hệ thống
│   ├── network/                       # Quản lý mạng
│   ├── session/                       # Quản lý phiên làm việc
│   ├── analytics/                     # Analytics
│   ├── error/                         # Xử lý lỗi toàn cục
│   └── validation/                    # Xác thực đầu vào
├── domain/                            # Lớp domain
│   ├── auth/                          # Xác thực domain
│   └── profile/                       # Hồ sơ người dùng domain
├── data/                              # Lớp dữ liệu
│   ├── auth/                          # Xác thực data
│   └── profile/                       # Hồ sơ người dùng data
├── presentation/                      # Lớp presentation
│   ├── providers/                     # Provider quản lý trạng thái
│   ├── screens/                       # Màn hình ứng dụng
│   └── widgets/                       # Widget tái sử dụng
├── theme/                             # Theme và thiết kế
├── utils/                             # Tiện ích
└── l10n/                              # Hỗ trợ đa ngôn ngữ
```

## Tích hợp backend

Ứng dụng tích hợp với hệ sinh thái HealZone bao gồm:
- **Auth Service**: Xử lý xác thực người dùng
- **User Service**: Quản lý thông tin người dùng
- **AI Service**: Phân tích hình ảnh da
- **API Gateway**: Điều phối các request

## Best Practices

- Clean architecture với 3 layer rõ ràng
- Dependency injection
- Error handling toàn cục
- Logging và analytics
- Validation đầu vào
- Tự động refresh token
- Local cache để cải thiện hiệu suất

## Đóng góp

1. Fork repository
2. Tạo branch cho tính năng mới (`git checkout -b feature/amazing-feature`)
3. Commit thay đổi (`git commit -m 'Add some amazing feature'`)
4. Push lên branch (`git push origin feature/amazing-feature`)
5. Tạo pull request

## Giấy phép

Dự án này được cấp phép theo giấy phép MIT - xem tệp [LICENSE](LICENSE) để biết thêm chi tiết.

## Demo login (local only)

Để kiểm tra nhanh UI/UX mà không cần backend, dùng tài khoản mẫu:

- **Email**: `demo@healzone.app`
- **Mật khẩu**: `Demo123`

Tài khoản này chạy hoàn toàn offline, dữ liệu (hồ sơ + lịch sử phân tích) được mock ngay trong app. Đừng quên xoá đoạn demo này trước khi phát hành production.

