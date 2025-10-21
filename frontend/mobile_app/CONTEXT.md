# Context - Mobile App (Flutter)

## Tổng quan

Ứng dụng di động HealZone là một nền tảng chăm sóc da dựa trên AI, cho phép người dùng chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm phù hợp và quản lý hồ sơ chăm sóc da cá nhân. Ứng dụng được xây dựng bằng Flutter với kiến trúc dựa trên Provider cho quản lý trạng thái.

## Mục đích

- Ứng dụng di động cho người dùng cuối: đăng ký/đăng nhập, chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm, quản lý hồ sơ.
- Tích hợp với hệ thống backend để xử lý phân tích da bằng AI và cung cấp lời khuyên chăm sóc da cá nhân hóa.

## Công nghệ chính

- **Flutter (Dart)**: Framework đa nền tảng cho phát triển ứng dụng di động
- **Provider**: Quản lý trạng thái ứng dụng
- **Dio**: HTTP client cho các yêu cầu mạng
- **flutter_secure_storage**: Lưu trữ token xác thực an toàn
- **go_router**: Điều hướng và quản lý URL trong ứng dụng
- **image_picker**: Chọn ảnh từ thiết bị
- **cached_network_image**: Cache hình ảnh từ mạng

## Kiến trúc ứng dụng

### Cấu trúc thư mục
```
lib/
├── main.dart                 # Điểm vào ứng dụng, khởi tạo theme và router
├── config/                   # Cấu hình ứng dụng
│   └── environment.dart      # Cấu hình runtime
├── theme/                    # Theme và thiết kế
│   └── app_theme.dart        # Định nghĩa màu sắc, khoảng cách, kiểu dáng
├── models/                   # Model dữ liệu
│   └── user_profile.dart     # Định nghĩa UserProfile và SkinAnalysisHistory
├── providers/                # Provider quản lý trạng thái
│   ├── auth_provider.dart    # Quản lý trạng thái xác thực
│   └── user_profile_provider.dart # Quản lý hồ sơ người dùng
├── services/                 # Dịch vụ hệ thống
│   └── secure_storage_service.dart # Lưu trữ token an toàn
├── api/                      # API clients
│   ├── auth_api_service.dart # Dịch vụ xác thực
│   ├── user_profile_api_service.dart # Dịch vụ hồ sơ người dùng
│   └── analyses_api_service.dart # Dịch vụ phân tích da
├── screens/                  # Các màn hình ứng dụng
│   ├── auth/                 # Màn hình xác thực
│   ├── profile/              # Màn hình hồ sơ
│   ├── scan/                 # Màn hình quét da
│   └── ...                   # Các màn hình khác
├── widgets/                  # Widget tái sử dụng
│   ├── hz_buttons.dart       # Nút tùy chỉnh
│   └── shell_scaffold.dart   # Giao diện chính với bottom navigation
├── utils/                    # Tiện ích
│   ├── api_constants.dart    # Hằng số API
│   └── exceptions.dart       # Định nghĩa exception
└── router/                   # Định tuyến
    └── app_router.dart       # Cấu hình điều hướng
```

### Kiến trúc dữ liệu
- **UserProfile**: Thông tin người dùng (id, email, họ tên, số điện thoại, avatar, ngày tạo/cập nhật)
- **SkinAnalysisHistory**: Lịch sử phân tích da (id, userId, imageUrl, analysisResult, createdAt, status)

### Quản lý trạng thái
- **AuthProvider**: Quản lý trạng thái đăng nhập, xử lý đăng nhập/đăng ký
- **UserProfileProvider**: Quản lý thông tin hồ sơ người dùng và lịch sử phân tích da

## Tính năng chính

1. **Xác thực người dùng**
   - Đăng ký/đăng nhập
   - Quản lý token (access/refresh)
   - Demo account

2. **Quản lý hồ sơ**
   - Xem và cập nhật thông tin cá nhân
   - Upload avatar
   - Thay đổi mật khẩu
   - Xem lịch sử phân tích da

3. **Phân tích da**
   - Chụp ảnh da để phân tích
   - Xem kết quả phân tích
   - Theo dõi tiến trình qua thời gian

4. **Gợi ý sản phẩm**
   - Dựa trên kết quả phân tích
   - Đề xuất sản phẩm phù hợp

5. **Lịch sử và theo dõi**
   - Xem lịch sử phân tích
   - Theo dõi tiến trình chăm sóc da

## Cấu hình và môi trường

- **API Base URL**: Hiện tại hard-code là `http://192.168.56.1:3001/api/v1`
- **Thời gian timeout**: 30 giây cho connect, receive, và send
- **Token lưu trữ**: Sử dụng flutter_secure_storage để lưu access/refresh token

## Tích hợp backend

- **Auth Service**: Xử lý xác thực người dùng (cổng 3001)
- **AI Service**: Phân tích hình ảnh da
- **User Service**: Quản lý thông tin người dùng
- **Product Service**: Cung cấp thông tin sản phẩm

## So sánh với các repo Flutter nổi tiếng

### Điểm mạnh
- Kiến trúc đơn giản, dễ hiểu với Provider
- Có hệ thống xử lý lỗi chuyên nghiệp
- Sử dụng GoRouter cho điều hướng hiện đại
- Có theme system được thiết kế tốt
- Có secure storage để lưu token an toàn
- Có widget tái sử dụng

### So với các repo mẫu (flutter_architecture_samples, flutter_samples)
- Chưa có kiến trúc clean architecture rõ ràng với các lớp presentation, domain, data
- Thiếu lớp use cases trong domain layer
- Chưa có hệ thống test hoàn chỉnh
- Hard-code base URL thay vì cơ chế cấu hình môi trường linh hoạt

## Các phần cần cải thiện

### 1. Kiến trúc ứng dụng
- **Hiện trạng**: Kiến trúc chưa tuân theo mô hình clean architecture rõ ràng
- **Cải thiện**: Tách biệt rõ ràng hơn giữa các layer (presentation, domain, data), thêm lớp use cases

### 2. Xử lý token tự động
- **Hiện trạng**: Chưa có interceptor tự động đính kèm Authorization header và refresh token
- **Cải thiện**: Thêm interceptor tự động đính kèm token và cơ chế refresh token tự động

### 3. Quản lý API
- **Hiện trạng**: Hard-code base URL, thiếu retry mechanism
- **Cải thiện**: Sử dụng cơ chế môi trường cho cấu hình API, thêm API interceptors, retry cho request thất bại

### 4. Xử lý lỗi toàn cục
- **Hiện trạng**: Xử lý lỗi cục bộ trong từng provider
- **Cải thiện**: Thêm cơ chế xử lý lỗi toàn cục với UI thông báo thân thiện

### 5. Kiểm thử
- **Hiện trạng**: Thiếu unit test, widget test và integration test
- **Cải thiện**: Thêm bộ test hoàn chỉnh với mock API

### 6. Tối ưu hóa hiệu suất
- **Hiện trạng**: Pagination cho danh sách lịch sử chưa tối ưu
- **Cải thiện**: Thêm lazy loading cho các danh sách dài

### 7. Kiểm tra và xác thực đầu vào
- **Hiện trạng**: Thiếu validation đầu vào
- **Cải thiện**: Thêm hệ thống validation tập trung

### 8. Logging và giám sát
- **Hiện trạng**: Chưa có hệ thống logging toàn cục
- **Cải thiện**: Thêm logging và tích hợp analytics

### 9. Cấu hình môi trường
- **Hiện trạng**: Hard-code IP trong `api_constants.dart`
- **Cải thiện**: Thêm cơ chế cấu hình riêng cho các môi trường dev/staging/prod

### 10. Tái sử dụng mã nguồn
- **Hiện trạng**: Một số widget có thể được tối ưu hóa hơn
- **Cải thiện**: Thiết kế lại một số widget để tăng khả năng tái sử dụng

## Best practices đang được áp dụng

- Sử dụng camelCase cho biến và hàm, PascalCase cho class và enum (theo quy tắc Dart)
- Có hệ thống exception riêng biệt
- Sử dụng type definitions rõ ràng
- Có theme system nhất quán
- Có widget tái sử dụng
- Có phân tách rõ ràng giữa UI, business logic và data layer

## Hướng phát triển trong tương lai

- Áp dụng clean architecture hoàn chỉnh
- Thêm hệ thống test đầy đủ
- Tích hợp CI/CD
- Thêm tính năng đa ngôn ngữ
- Tối ưu hóa hiệu suất cho danh sách lớn
- Cải thiện trải nghiệm người dùng với animation và micro-interaction
- Thêm cơ chế offline-first cho một số tính năng

## Chạy ứng dụng

- Yêu cầu: Flutter SDK, thiết bị hoặc emulator
- Cài đặt: `flutter pub get`
- Chạy: `flutter run` trong thư mục `frontend/mobile_app`
- Build: `flutter build apk` hoặc `flutter build ios`

## Ghi chú quan trọng

- Hiện tại ứng dụng có tài khoản demo để dễ dàng thử nghiệm
- API base URL cần được cấu hình phù hợp với môi trường triển khai
- Token được lưu trữ an toàn bằng flutter_secure_storage
- Có cơ chế xử lý lỗi mạng và API toàn diện
