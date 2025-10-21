# Context - Mobile App (Flutter)

## Tổng quan

Ứng dụng di động HealZone là một nền tảng chăm sóc da dựa trên AI, cho phép người dùng chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm phù hợp và quản lý hồ sơ chăm sóc da cá nhân. Ứng dụng được xây dựng bằng Flutter với kiến trúc clean architecture rõ ràng, bao gồm 3 layer: presentation, domain và data.

## Mục đích

- Ứng dụng di động cho người dùng cuối: đăng ký/đăng nhập, chụp ảnh da, nhận phân tích AI, gợi ý sản phẩm, quản lý hồ sơ.
- Tích hợp với hệ thống backend để xử lý phân tích da bằng AI và cung cấp lời khuyên chăm sóc da cá nhân hóa.
- Cung cấp trải nghiệm người dùng mượt mà với cơ chế xác thực và quản lý trạng thái nâng cao.

## Công nghệ chính

- **Flutter (Dart)**: Framework đa nền tảng cho phát triển ứng dụng di động
- **Provider**: Quản lý trạng thái ứng dụng
- **Dio**: HTTP client cho các yêu cầu mạng với interceptor
- **flutter_secure_storage**: Lưu trữ token xác thực an toàn
- **go_router**: Điều hướng và quản lý URL trong ứng dụng
- **image_picker**: Chọn ảnh từ thiết bị
- **cached_network_image**: Cache hình ảnh từ mạng
- **shared_preferences**: Lưu trữ dữ liệu cục bộ
- **flutter_localizations**: Hỗ trợ đa ngôn ngữ

## Kiến trúc ứng dụng

### Cấu trúc thư mục
```
lib/
├── main.dart                           # Điểm vào ứng dụng, khởi tạo theme và router
├── config/                           # Cấu hình ứng dụng
│   └── environment.dart              # Cấu hình runtime cho các môi trường
├── core/                             # Lõi hệ thống
│   ├── network/                      # Quản lý mạng
│   │   ├── api_client.dart          # API client singleton với interceptors
│   │   └── interceptors/            # Các interceptor (retry, auth, logging)
│   ├── session/                      # Quản lý phiên làm việc
│   │   └── auth_session_observer.dart # Observer cho các sự kiện phiên
│   ├── analytics/                    # Analytics service
│   ├── error/                        # Xử lý lỗi toàn cục
│   │   └── global_error_notifier.dart # Notifier lỗi toàn cục
│   └── validation/                   # Xác thực đầu vào
├── theme/                            # Theme và thiết kế
│   └── app_theme.dart                # Định nghĩa màu sắc, khoảng cách, kiểu dáng
├── domain/                           # Lớp domain (entities, usecases, repositories)
│   ├── auth/                         # Xác thực domain
│   │   ├── entities/                 # Entities xác thực (AuthTokens, UserCredentials)
│   │   ├── repositories/             # Interface repositories xác thực
│   │   └── usecases/                 # Use cases xác thực (login, register, logout)
│   └── profile/                      # Hồ sơ người dùng domain
│       ├── entities/                 # Entities hồ sơ (UserProfile, SkinAnalysisHistory)
│       ├── repositories/             # Interface repositories hồ sơ
│       └── usecases/                 # Use cases hồ sơ (get, update, change password)
├── data/                             # Lớp dữ liệu (implement repositories, data sources)
│   ├── auth/                         # Xác thực data
│   │   ├── datasources/              # Remote và local data sources xác thực
│   │   └── repositories/             # Implementation repositories xác thực
│   └── profile/                      # Hồ sơ người dùng data
│       ├── datasources/              # Remote và local data sources hồ sơ
│       └── repositories/             # Implementation repositories hồ sơ
├── presentation/                     # Lớp presentation (UI, providers, screens, widgets)
│   ├── providers/                    # Provider quản lý trạng thái
│   │   ├── auth_provider.dart        # Quản lý trạng thái xác thực
│   │   └── user_profile_provider.dart # Quản lý hồ sơ người dùng
│   ├── screens/                      # Các màn hình ứng dụng
│   │   ├── auth/                     # Màn hình xác thực
│   │   ├── profile/                  # Màn hình hồ sơ
│   │   ├── scan/                     # Màn hình quét da
│   │   └── ...                       # Các màn hình khác
│   ├── widgets/                      # Widget tái sử dụng
│   │   ├── hz_buttons.dart           # Nút tùy chỉnh
│   │   └── shell_scaffold.dart       # Giao diện chính với bottom navigation
│   └── router/                       # Định tuyến
│       └── app_router.dart           # Cấu hình điều hướng
├── utils/                            # Tiện ích
│   ├── api_constants.dart            # Hằng số API
│   └── exceptions.dart               # Định nghĩa exception
└── l10n/                             # Hỗ trợ đa ngôn ngữ
    └── app_localizations.dart        # Localization
```

### Kiến trúc dữ liệu
- **UserProfile**: Thông tin người dùng (id, email, họ tên, số điện thoại, avatar, ngày tạo/cập nhật)
- **SkinAnalysisHistory**: Lịch sử phân tích da (id, userId, imageUrl, analysisResult, createdAt, status)
- **AuthTokens**: Token xác thực (accessToken, refreshToken)
- **UserCredentials**: Thông tin đăng nhập (email, password)

### Quản lý trạng thái
- **AuthProvider**: Quản lý trạng thái đăng nhập, xử lý đăng nhập/đăng ký, logout
- **UserProfileProvider**: Quản lý thông tin hồ sơ người dùng và lịch sử phân tích da

## Tính năng chính

1. **Xác thực người dùng**
   - Đăng ký/đăng nhập
   - Quản lý token (access/refresh) với cơ chế tự động refresh
   - Demo account
   - Xử lý lỗi xác thực toàn cục

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

- **API Base URL**: Có thể cấu hình theo môi trường (development, staging, production)
- **Thời gian timeout**: Có thể cấu hình theo môi trường
- **SSL**: Có thể cấu hình strict SSL theo môi trường
- **Token lưu trữ**: Sử dụng flutter_secure_storage để lưu access/refresh token

## Tích hợp backend

- **Auth Service**: Xử lý xác thực người dùng (cổng 3001)
- **User Service**: Quản lý thông tin người dùng
- **AI Service**: Phân tích hình ảnh da
- **API Gateway**: Điều phối các request đến các services khác
- **hz-shared**: Thư viện chia sẻ giữa các services (JWT, error handling)

## So sánh với các phần khác trong dự án

### Tính nhất quán với backend services:
- Mobile app sử dụng mô hình clean architecture tương tự như cách tổ chức trong các services (auth-service, user-service)
- Cấu trúc thư mục theo mô hình clean: domain, data, presentation tương tự như cách tổ chức trong các services
- Các entity trong mobile app (UserProfile, AuthTokens) phù hợp với các interface trong auth-service (IUser, IAuthTokens)
- API endpoints trong mobile app phù hợp với các route trong backend services

### Tính nhất quán với quy ước dự án:
- Mobile app tuân thủ các quy tắc lập trình trong `AGENTS.md`:
  - Sử dụng camelCase cho biến và hàm trong Dart
  - Có cơ chế xác thực JWT với refresh token
  - Sử dụng Provider pattern cho quản lý state
  - Có logging và error handling

### Tính tương thích với hệ sinh thái:
- API client trong mobile app sử dụng cùng cấu trúc URL và xác thực như các services
- Refresh token mechanism trong mobile app phù hợp với auth-service
- Headers và cấu trúc request/response phù hợp với API gateway

## Các phần cần cải thiện

### 1. Kiến trúc ứng dụng
- **Hiện trạng**: Đã có kiến trúc clean architecture rõ ràng
- **Cải thiện**: Có thể thêm lớp data mapping giữa remote và local data nếu cần

### 2. Xử lý token tự động
- **Hiện trạng**: Có cơ chế tự động đính kèm Authorization header và refresh token
- **Cải thiện**: Có thể thêm cơ chế tự động logout khi token refresh thất bại

### 3. Quản lý API
- **Hiện trạng**: Có retry mechanism, logging, error handling
- **Cải thiện**: Có thể thêm cache cho các endpoint không thay đổi thường xuyên

### 4. Xử lý lỗi toàn cục
- **Hiện trạng**: Có cơ chế xử lý lỗi toàn cục với GlobalErrorNotifier
- **Cải thiện**: Có thể thêm reporting lỗi đến service theo dõi

### 5. Kiểm thử
- **Hiện trạng**: Có một số test đơn vị
- **Cải thiện**: Thêm bộ test đầy đủ hơn (unit test, widget test, integration test)

### 6. Tối ưu hóa hiệu suất
- **Hiện trạng**: Có local cache, pagination cho danh sách lịch sử
- **Cải thiện**: Có thể thêm lazy loading cho các danh sách dài hơn

### 7. Kiểm tra và xác thực đầu vào
- **Hiện trạng**: Có validation đầu vào ở cả UI và tầng service
- **Cải thiện**: Có thể tập trung validation hơn nữa

### 8. Logging và giám sát
- **Hiện trạng**: Có logging và tích hợp analytics
- **Cải thiện**: Có thể thêm logging chi tiết hơn cho việc debug

### 9. Cấu hình môi trường
- **Hiện trạng**: Có cơ chế cấu hình riêng cho các môi trường dev/staging/prod
- **Cải thiện**: Có thể thêm cơ chế build-time configuration

### 10. Tái sử dụng mã nguồn
- **Hiện trạng**: Có nhiều widget tái sử dụng
- **Cải thiện**: Có thể tạo package chung cho các thành phần chia sẻ nếu cần

## Best practices đang được áp dụng

- Sử dụng camelCase cho biến và hàm, PascalCase cho class và enum (theo quy tắc Dart)
- Có hệ thống exception riêng biệt
- Sử dụng type definitions rõ ràng
- Có theme system nhất quán
- Có widget tái sử dụng
- Có phân tách rõ ràng giữa các layer (presentation, domain, data)
- Có cơ chế tự động refresh token
- Có local cache để cải thiện trải nghiệm người dùng
- Có error handling toàn cục
- Có logging và analytics integration
- Có retry mechanism cho các request thất bại

## Hướng phát triển trong tương lai

- Thêm tính năng đa ngôn ngữ
- Tối ưu hóa hiệu suất cho danh sách lớn
- Cải thiện trải nghiệm người dùng với animation và micro-interaction
- Thêm cơ chế offline-first cho một số tính năng
- Tích hợp CI/CD nâng cao
- Thêm A/B testing framework
- Tích hợp push notification
- Thêm tính năng social (cộng đồng chăm sóc da)

## Chạy ứng dụng

- Yêu cầu: Flutter SDK, thiết bị hoặc emulator
- Cài đặt: `flutter pub get`
- Chạy: `flutter run` trong thư mục `frontend/mobile_app`
- Build: `flutter build apk` hoặc `flutter build ios`
- Build với môi trường: `flutter run --dart-define=APP_ENV=production`

## Ghi chú quan trọng

- Hiện tại ứng dụng có tài khoản demo để dễ dàng thử nghiệm
- API base URL có thể được cấu hình theo môi trường
- Token được lưu trữ an toàn bằng flutter_secure_storage
- Có cơ chế xử lý lỗi mạng và API toàn diện
- Có cơ chế tự động refresh token khi hết hạn
- Có local cache để cải thiện trải nghiệm người dùng ngay cả khi mạng yếu
- Có phân trang cho danh sách lịch sử phân tích da
- Có kiểm tra và xác thực đầu vào
- Có tích hợp analytics để theo dõi hành vi người dùng
