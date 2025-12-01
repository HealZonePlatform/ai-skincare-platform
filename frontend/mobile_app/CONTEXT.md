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
├── api/                                # Các service API
│   └── analyses_api_service.dart      # Service cho phân tích da
├── config/                            # Cấu hình ứng dụng
│   └── environment.dart               # Cấu hình runtime cho các môi trường
├── core/                              # Lõi hệ thống
│   ├── analytics/                     # Analytics service
│   │   └── analytics_service.dart     # Dịch vụ analytics
│   ├── config/                        # Cấu hình chung
│   ├── constants/                     # Hằng số ứng dụng
│   │   └── app_assets.dart            # Đường dẫn tài nguyên
│   ├── demo/                          # Chức năng demo
│   │   └── demo_session.dart          # Session demo
│   ├── error/                         # Xử lý lỗi toàn cục
│   │   └── global_error_notifier.dart # Notifier lỗi toàn cục
│   ├── logging/                       # Logging service
│   │   └── app_logger.dart            # Logger ứng dụng
│   ├── network/                       # Quản lý mạng
│   │   ├── api_client.dart           # API client singleton với interceptors
│   │   ├── network_config.dart       # Cấu hình mạng
│   │   └── interceptors/             # Các interceptor (retry, auth, logging)
│   │       ├── retry_interceptor.dart # Interceptor retry
│   │       └── security_interceptor.dart # Interceptor bảo mật
│   ├── notifications/                 # Quản lý thông báo
│   ├── security/                      # Bảo mật ứng dụng
│   │   └── secure_preferences.dart    # Lưu trữ an toàn
│   ├── session/                       # Quản lý phiên làm việc
│   │   └── auth_session_observer.dart # Observer cho các sự kiện phiên
│   ├── utils/                         # Tiện ích chung
│   └── validation/                    # Xác thực đầu vào
│       └── input_validators.dart      # Các hàm xác thực đầu vào
├── data/                              # Lớp dữ liệu (implement repositories, data sources)
│   ├── analysis/                      # Dữ liệu phân tích da
│   │   ├── datasources/               # Data sources cho phân tích
│   │   ├── models/                    # DTOs và models cho phân tích
│   │   └── repositories/              # Repository cho phân tích
│   ├── auth/                          # Xác thực data
│   │   ├── datasources/               # Remote và local data sources xác thực
│   │   │   ├── auth_remote_data_source.dart # Data source xác thực từ xa
│   │   │   └── token_local_data_source.dart # Data source token cục bộ
│   │   └── repositories/              # Implementation repositories xác thực
│   │       ├── auth_repository_impl.dart # Implementation repository xác thực
│   │       └── token_repository_impl.dart # Implementation repository token
│   ├── home/                          # Dữ liệu dashboard trang chủ
│   │   ├── datasources/               # Data sources cho trang chủ
│   │   │   └── home_remote_data_source.dart # Data source trang chủ từ xa
│   │   ├── models/                    # DTOs và models cho trang chủ
│   │   │   └── home_dashboard_dto.dart # DTO chuyển đổi từ API sang entity
│   │   ├── repositories/              # Repository cho trang chủ
│   │   │   └── home_repository_impl.dart # Implementation repository trang chủ
│   │   └── home_mock_data.dart        # Dữ liệu mẫu cho trang chủ (đã thay thế bằng API thực tế)
│   └── profile/                       # Hồ sơ người dùng data
│       ├── datasources/               # Remote và local data sources hồ sơ
│       │   ├── profile_local_cache.dart # Cache hồ sơ cục bộ
│       │   └── profile_remote_data_source.dart # Data source hồ sơ từ xa
│       └── repositories/              # Implementation repositories hồ sơ
│           └── profile_repository_impl.dart # Implementation repository hồ sơ
├── domain/                            # Lớp domain (entities, usecases, repositories)
│   ├── analysis/                      # Domain phân tích da
│   │   ├── entities/                  # Entities phân tích
│   │   ├── repositories/              # Interface repositories phân tích
│   │   └── usecases/                  # Use cases phân tích
│   ├── auth/                          # Xác thực domain
│   │   ├── entities/                  # Entities xác thực (AuthTokens, UserCredentials)
│   │   ├── repositories/              # Interface repositories xác thực
│   │   └── usecases/                  # Use cases xác thực (login, register, logout)
│   ├── common/                        # Các thành phần chung
│   ├── home/                          # Domain dashboard trang chủ
│   │   ├── entities/                  # Entities trang chủ (HomeDashboard, HomePulse, HomeInsight, v.v.)
│   │   ├── repositories/              # Interface repositories trang chủ
│   │   │   └── home_repository.dart   # Interface repository trang chủ
│   │   └── usecases/                  # Use cases trang chủ
│   │       └── get_home_dashboard_usecase.dart # Use case lấy dữ liệu dashboard trang chủ
│   └── profile/                       # Hồ sơ người dùng domain
│       ├── entities/                  # Entities hồ sơ (UserProfile, SkinAnalysisHistory)
│       ├── repositories/              # Interface repositories hồ sơ
│       └── usecases/                  # Use cases hồ sơ (get, update, change password)
├── l10n/                              # Hỗ trợ đa ngôn ngữ
│   └── app_localizations.dart         # Localization
├── presentation/                      # Lớp presentation (UI, providers, screens, widgets)
│   ├── providers/                     # Provider quản lý trạng thái
│   │   ├── auth_provider.dart         # Quản lý trạng thái xác thực
│   │   ├── home_provider.dart         # Quản lý trạng thái dashboard trang chủ
│   │   ├── onboarding_provider.dart   # Quản lý trạng thái onboarding
│   │   ├── theme_provider.dart        # Quản lý trạng thái theme
│   │   └── user_profile_provider.dart # Quản lý hồ sơ người dùng
│   ├── router/                        # Định tuyến
│   │   ├── app_router.dart            # Cấu hình điều hướng
│   │   └── router_observer.dart       # Observer cho router
│   ├── screens/                       # Các màn hình ứng dụng
│   │   ├── advice/                    # Màn hình lời khuyên
│   │   ├── auth/                      # Màn hình xác thực
│   │   ├── checkout/                  # Màn hình thanh toán
│   │   ├── community/                 # Màn hình cộng đồng
│   │   ├── history/                   # Màn hình lịch sử
│   │   ├── home/                      # Màn hình trang chủ
│   │   │   ├── home_screen.dart       # Màn hình chính
│   │   │   ├── models/                # Model cho UI trang chủ
│   │   │   │   └── home_models.dart   # Model chuyển đổi từ entity sang UI
│   │   │   └── widgets/               # Widget riêng cho trang chủ
│   │   │       ├── article_list.dart  # Danh sách bài viết
│   │   │       ├── coach_card.dart    # Thẻ tư vấn viên
│   │   │       ├── hero_header.dart   # Header chính
│   │   │       ├── insight_cards.dart # Thẻ thông tin chi tiết
│   │   │       ├── product_carousel.dart # Băng chuyền sản phẩm
│   │   │       ├── pulse_card.dart    # Thẻ chỉ số sức khỏe da
│   │   │       └── routine_carousel.dart # Băng chuyền lịch trình chăm sóc
│   │   ├── lifestyle/                 # Màn hình lối sống
│   │   ├── onboarding/                # Màn hình hướng dẫn
│   │   ├── paywall/                   # Màn hình thanh toán
│   │   ├── products/                  # Màn hình sản phẩm
│   │   ├── profile/                   # Màn hình hồ sơ
│   │   ├── routine/                   # Màn hình lịch trình
│   │   ├── scan/                      # Màn hình quét da
│   │   └── survey/                    # Màn hình khảo sát
│   ├── widgets/                       # Widget tái sử dụng
│   │   ├── app_loading_overlay.dart   # Overlay loading
│   │   ├── brand_logo.dart            # Logo thương hiệu
│   │   ├── hz_buttons.dart            # Nút tùy chỉnh
│   │   ├── hz_loading_skeleton.dart   # Skeleton loading
│   │   ├── hz_skeleton.dart           # Skeleton chung
│   │   ├── optimized_network_image.dart # Ảnh mạng tối ưu
│   │   ├── shell_scaffold.dart        # Giao diện chính với bottom navigation
│   │   └── ui_kit/                    # Bộ widget UI
│   │       ├── hz_responsive_layout.dart # Layout responsive
│   │       ├── hz_section_header.dart # Header section
│   │       ├── hz_stat_chip.dart      # Chip trạng thái
│   │       └── hz_surface_card.dart   # Card bề mặt
│   └── spec/                          # Spec cho UI components
├── theme/                             # Theme và thiết kế
│   └── app_theme.dart                 # Định nghĩa màu sắc, khoảng cách, kiểu dáng
└── utils/                             # Tiện ích
    ├── api_constants.dart             # Hằng số API
    ├── error_handler.dart             # Xử lý lỗi
    └── exceptions.dart                # Định nghĩa exception
```
├── main.dart                           # Điểm vào ứng dụng, khởi tạo theme và router
├── api/                                # Các service API
│   └── analyses_api_service.dart      # Service cho phân tích da
├── config/                            # Cấu hình ứng dụng
│   └── environment.dart               # Cấu hình runtime cho các môi trường
├── core/                              # Lõi hệ thống
│   ├── analytics/                     # Analytics service
│   │   └── analytics_service.dart     # Dịch vụ analytics
│   ├── config/                        # Cấu hình chung
│   ├── constants/                     # Hằng số ứng dụng
│   │   └── app_assets.dart            # Đường dẫn tài nguyên
│   ├── demo/                          # Chức năng demo
│   │   └── demo_session.dart          # Session demo
│   ├── error/                         # Xử lý lỗi toàn cục
│   │   └── global_error_notifier.dart # Notifier lỗi toàn cục
│   ├── logging/                       # Logging service
│   │   └── app_logger.dart            # Logger ứng dụng
│   ├── network/                       # Quản lý mạng
│   │   ├── api_client.dart           # API client singleton với interceptors
│   │   ├── network_config.dart       # Cấu hình mạng
│   │   └── interceptors/             # Các interceptor (retry, auth, logging)
│   │       ├── retry_interceptor.dart # Interceptor retry
│   │       └── security_interceptor.dart # Interceptor bảo mật
│   ├── notifications/                 # Quản lý thông báo
│   ├── security/                      # Bảo mật ứng dụng
│   │   └── secure_preferences.dart    # Lưu trữ an toàn
│   ├── session/                       # Quản lý phiên làm việc
│   │   └── auth_session_observer.dart # Observer cho các sự kiện phiên
│   ├── utils/                         # Tiện ích chung
│   └── validation/                    # Xác thực đầu vào
│       └── input_validators.dart      # Các hàm xác thực đầu vào
├── data/                              # Lớp dữ liệu (implement repositories, data sources)
│   ├── analysis/                      # Dữ liệu phân tích da
│   │   ├── datasources/               # Data sources cho phân tích
│   │   └── repositories/              # Repository cho phân tích
│   ├── auth/                          # Xác thực data
│   │   ├── datasources/               # Remote và local data sources xác thực
│   │   │   ├── auth_remote_data_source.dart # Data source xác thực từ xa
│   │   │   └── token_local_data_source.dart # Data source token cục bộ
│   │   └── repositories/              # Implementation repositories xác thực
│   │       ├── auth_repository_impl.dart # Implementation repository xác thực
│   │       └── token_repository_impl.dart # Implementation repository token
│   └── profile/                       # Hồ sơ người dùng data
│       ├── datasources/               # Remote và local data sources hồ sơ
│       │   ├── profile_local_cache.dart # Cache hồ sơ cục bộ
│       │   └── profile_remote_data_source.dart # Data source hồ sơ từ xa
│       └── repositories/              # Implementation repositories hồ sơ
│           └── profile_repository_impl.dart # Implementation repository hồ sơ
├── domain/                            # Lớp domain (entities, usecases, repositories)
│   ├── analysis/                      # Domain phân tích da
│   │   ├── entities/                  # Entities phân tích
│   │   ├── repositories/              # Interface repositories phân tích
│   │   └── usecases/                  # Use cases phân tích
│   ├── auth/                          # Xác thực domain
│   │   ├── entities/                  # Entities xác thực (AuthTokens, UserCredentials)
│   │   ├── repositories/              # Interface repositories xác thực
│   │   └── usecases/                  # Use cases xác thực (login, register, logout)
│   ├── common/                        # Các thành phần chung
│   └── profile/                       # Hồ sơ người dùng domain
│       ├── entities/                  # Entities hồ sơ (UserProfile, SkinAnalysisHistory)
│       ├── repositories/              # Interface repositories hồ sơ
│       └── usecases/                  # Use cases hồ sơ (get, update, change password)
├── l10n/                              # Hỗ trợ đa ngôn ngữ
│   └── app_localizations.dart         # Localization
├── presentation/                      # Lớp presentation (UI, providers, screens, widgets)
│   ├── providers/                     # Provider quản lý trạng thái
│   │   ├── auth_provider.dart         # Quản lý trạng thái xác thực
│   │   └── user_profile_provider.dart # Quản lý hồ sơ người dùng
│   ├── router/                        # Định tuyến
│   │   ├── app_router.dart            # Cấu hình điều hướng
│   │   └── router_observer.dart       # Observer cho router
│   ├── screens/                       # Các màn hình ứng dụng
│   │   ├── advice/                    # Màn hình lời khuyên
│   │   ├── auth/                      # Màn hình xác thực
│   │   ├── checkout/                  # Màn hình thanh toán
│   │   ├── community/                 # Màn hình cộng đồng
│   │   ├── history/                   # Màn hình lịch sử
│   │   ├── home_screen.dart           # Màn hình chính
│   │   ├── lifestyle/                 # Màn hình lối sống
│   │   ├── onboarding/                # Màn hình hướng dẫn
│   │   ├── paywall/                   # Màn hình thanh toán
│   │   ├── products/                  # Màn hình sản phẩm
│   │   ├── profile/                   # Màn hình hồ sơ
│   │   ├── routine/                   # Màn hình lịch trình
│   │   ├── scan/                      # Màn hình quét da
│   │   └── survey/                    # Màn hình khảo sát
│   ├── widgets/                       # Widget tái sử dụng
│   │   ├── app_loading_overlay.dart   # Overlay loading
│   │   ├── brand_logo.dart            # Logo thương hiệu
│   │   ├── hz_buttons.dart            # Nút tùy chỉnh
│   │   ├── hz_loading_skeleton.dart   # Skeleton loading
│   │   ├── hz_skeleton.dart           # Skeleton chung
│   │   ├── optimized_network_image.dart # Ảnh mạng tối ưu
│   │   ├── shell_scaffold.dart        # Giao diện chính với bottom navigation
│   │   └── ui_kit/                    # Bộ widget UI
│   │       ├── hz_responsive_layout.dart # Layout responsive
│   │       ├── hz_section_header.dart # Header section
│   │       ├── hz_stat_chip.dart      # Chip trạng thái
│   │       └── hz_surface_card.dart   # Card bề mặt
│   └── spec/                          # Spec cho UI components
├── theme/                             # Theme và thiết kế
│   └── app_theme.dart                 # Định nghĩa màu sắc, khoảng cách, kiểu dáng
└── utils/                             # Tiện ích
    ├── api_constants.dart             # Hằng số API
    ├── error_handler.dart             # Xử lý lỗi
    └── exceptions.dart                # Định nghĩa exception
```

### Kiến trúc dữ liệu

- **UserProfile**: Thông tin người dùng (id, email, họ tên, số điện thoại, avatar, ngày tạo/cập nhật)
- **SkinAnalysisHistory**: Lịch sử phân tích da (id, userId, imageUrl, analysisResult, createdAt, status)
- **AuthTokens**: Token xác thực (accessToken, refreshToken)
- **UserCredentials**: Thông tin đăng nhập (email, password)
- **HomeDashboard**: Dữ liệu dashboard trang chủ (greetingName, heroStats, pulse, pulseHighlights, insights, routines, articles, products)
- **HomePulse**: Chỉ số sức khỏe da (score, trend, delta, mood, updated)
- **HomeInsight**: Thông tin chi tiết (title, caption, icon, progress, iconColor)
- **HomeRoutine**: Lịch trình chăm sóc da (title, icon, steps, focus, minutes, bestMoment, accentColor)
- **HomeArticle**: Bài viết (title, subtitle, icon, readingTime, route, heroColor)
- **HomeProduct**: Sản phẩm (name, benefit, rating, icon, route, badge, color, imageUrl)

### Cấu trúc DTO và chuyển đổi

- **HomeDashboardDto**: DTO gốc từ API, chứa toàn bộ dữ liệu dashboard
- **HomeHeroStatDto**: DTO cho các chỉ số chính (label, value, icon, detail, color)
- **HomePulseDto**: DTO cho chỉ số sức khỏe da (score, trend, delta, mood, updated)
- **HomePulseHighlightDto**: DTO cho các điểm nổi bật (label, value, icon, color)
- **HomeInsightDto**: DTO cho thông tin chi tiết (title, caption, icon, progress, iconColor)
- **HomeRoutineDto**: DTO cho lịch trình chăm sóc (title, icon, steps, focus, minutes, bestMoment, accentColor)
- **HomeArticleDto**: DTO cho bài viết (title, subtitle, icon, readingTime, route, heroColor)
- **HomeProductDto**: DTO cho sản phẩm (name, benefit, rating, icon, route, badge, color, imageUrl)

Các DTO có phương thức `toEntity()` để chuyển đổi sang entity tương ứng và `fromJson()`/`toJson()` để xử lý serialization. Các phương thức helper như `_parseString()`, `_parseInt()`, `_parseDouble()`, `_parseColor()` giúp đảm bảo an toàn khi chuyển đổi dữ liệu từ API.

### Quản lý trạng thái
- **AuthProvider**: Quản lý trạng thái đăng nhập, xử lý đăng nhập/đăng ký, logout
- **UserProfileProvider**: Quản lý thông tin hồ sơ người dùng và lịch sử phân tích da
- **HomeProvider**: Quản lý trạng thái dashboard trang chủ (loading, loaded, error) và fetch dữ liệu dashboard
- **ThemeProvider**: Quản lý trạng thái theme (light/dark mode) và lưu trữ cài đặt theme người dùng
- **OnboardingProvider**: Quản lý trạng thái hoàn thành của quy trình hướng dẫn người dùng mới

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

6. **Dashboard trang chủ**
   - Hiển thị các chỉ số sức khỏe da (pulse, insights, stats)
   - Hiển thị lịch trình chăm sóc da gợi ý
   - Hiển thị bài viết và sản phẩm phù hợp
   - Có cơ chế refresh và xử lý lỗi

7. **Tùy chỉnh giao diện**
   - Hỗ trợ chuyển đổi giữa chế độ sáng và tối
   - Lưu trữ cài đặt theme người dùng

8. **Hướng dẫn người dùng mới**
   - Hiển thị quy trình hướng dẫn cho người dùng mới
   - Theo dõi trạng thái hoàn thành onboarding

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

### 11. Tích hợp backend cho dashboard
- **Hiện trạng**: Home screen hiện đang fetch dữ liệu từ HomeProvider, nhưng dữ liệu vẫn là mock
- **Cải thiện**: Kết nối với backend thực tế để lấy dữ liệu dashboard thay vì sử dụng mock data

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

## Đánh giá hiện trạng (theo đánh giá chi tiết)

### ✅ **Điểm mạnh ấn tượng**

**1. Kiến trúc Clean & Professional** ⭐⭐⭐⭐⭐
- Clean Architecture 3 layer (Presentation → Domain → Data) cực kỳ rõ ràng
- Dependency Injection pattern đúng chuẩn
- Separation of concerns tốt, dễ maintain và scale

**2. UI/UX Design Xuất Sắc** ⭐⭐⭐⭐⭐
- **Home screen** có design system cực kỳ hiện đại, sánh ngang các app premium
- Glass morphism effects, gradient backgrounds, micro-interactions đều được implement tinh tế
- Component reusability cao với UI Kit riêng
- Responsive layout support (mobile/tablet/desktop)

**3. State Management & Network Layer** ⭐⭐⭐⭐
- Provider pattern implementation tốt
- ApiClient singleton với interceptors (retry, auth, logging)
- Auto refresh token mechanism
- Global error handling với `GlobalErrorNotifier`

**4. Developer Experience** ⭐⭐⭐⭐
- File structure rõ ràng, dễ navigate
- Documentation tốt (README, CONTEXT, ASSETS)
- Demo account cho testing
- Environment configuration system

### ❌ **Vấn đề cần cải thiện**

#### 1. Đã kết nối backend thực tế
- Home screen hiện đã fetch dữ liệu từ HomeProvider, sử dụng API thực tế thay vì mock data
- HomeRemoteDataSource đã được cập nhật để gọi `/api/v1/dashboard` và có cơ chế xử lý lỗi
- Đã có offline cache fallback cho dashboard data

#### 2. Đã hỗ trợ Dark Mode
- Parameter `isDark` trong `AppTheme.build()` đã được sử dụng
- Có ThemeProvider và ThemePreferences để quản lý cài đặt theme người dùng
- Có cơ chế lưu trữ và áp dụng theme giữa các phiên

#### 3. Đã cải thiện cấu trúc Home Screen
- Home screen đã được tách thành nhiều widget nhỏ hơn (article_list, coach_card, hero_header, insight_cards, product_carousel, pulse_card, routine_carousel)
- Có cơ chế xử lý lỗi và skeleton loading cho dashboard
- Có RefreshIndicator để pull-to-refresh dữ liệu dashboard

#### 4. Đã tối ưu hiệu suất
- Đã refactor `product_carousel.dart` và `routine_carousel.dart` để tránh nested `ListView`
- Sử dụng `SliverList` và `CustomScrollView` với `itemExtent` và `cacheExtent`
- Đã cập nhật `optimized_network_image.dart` với cache sizes dựa trên device pixel ratio
- Đã thêm cache width/height cho các `CachedNetworkImage` và `Image.asset`

#### 5. Đã cải thiện bảo mật và session handling
- Đã thêm encryption layer cho `flutter_secure_storage` với `SecureTokenStorage`
- Có cơ chế xử lý refresh-fail và logout khi token hết hạn
- Đảm bảo concurrent refresh attempts được xử lý an toàn
- Đã thêm single flight mechanism cho token refresh

#### 6. Đã có Onboarding Flow
- Có OnboardingProvider và OnboardingPreferences để quản lý trạng thái hoàn thành onboarding
- Có màn hình hướng dẫn người dùng mới

#### 7. Đã cải thiện scan flow và navigation
- Đã thêm permission screen cho camera
- Đã sửa lỗi bottom navigation để highlight đúng các nested routes
- Đã thêm `WillPopScope` cho scan screens để xử lý back button đúng cách
- FAB đã được làm contextual với icon/behavior phù hợp từng context

#### 8. Đã có offline cache
- Đã thêm local caches cho dashboard, profile, và history
- Có cơ chế serve cached data khi offline và hiển thị offline indicator

#### 9. Chưa hoàn thiện Testing
- Vẫn còn thiếu unit tests cho các providers, use cases và repositories
- Cần bổ sung widget tests cho UI components và integration tests cho các flows chính
- Folder `integration_test` đã có nhưng cần hoàn thiện

#### 10. Chưa hoàn thiện Theme System
- Theme system chưa được wire hoàn chỉnh với `ThemeProvider` trong `main.dart`
- Chưa có quick toggle cho dark mode và theme changes chưa propagate mà không cần restart

### 🎯 **Roadmap phát triển ưu tiên**

#### Phase 1: Fixes Critical (Tuần 1-2)
1. Hoàn thiện unit tests cho các providers và components
2. Wire theme system hoàn chỉnh và thêm quick toggle
3. Thêm real-time validation cho các form

#### Phase 2: Enhanced Features (Tuần 3-4)
4. Accessibility (semantic labels, screen readers)
5. Analytics event catalog và crash reporting integration
6. Push notifications (FCM setup và scheduling)

#### Phase 3: User Experience (Tuần 5-6)
7. Advanced Features (infinite scroll, search)
8. Offline support hoàn chỉnh với queue retry cho pending actions
9. Tối ưu hóa animations và CPU usage

#### Phase 4: Polish (Tuần 7-8)
10. Micro-interactions (haptic feedback, animations)
11. Social Features (reviews, ratings, sharing)
12. CI/CD workflow và coverage reporting

### 📊 **Tình trạng hiện tại: 8.5/10**

- Đã có foundation rất tốt với kiến trúc clean và UI/UX hiện đại
- Home screen đã được cải thiện với việc tách module và có cơ chế xử lý lỗi
- Backend integration đã hoàn thiện cho dashboard
- Performance và security đã được cải thiện đáng kể
- Vẫn còn thiếu testing đầy đủ và một số tính năng UX cần hoàn thiện
- Sau khi hoàn thiện các ưu tiên, ứng dụng có thể đạt mức 9/10
