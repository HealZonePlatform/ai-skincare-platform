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
│   │   ├── auth_remote_data_source.dart # Data source xác thực từ xa
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
│   │       ├── article_list.dart  # Danh sách bài viết
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
│   │   ├── confetti_overlay.dart      # Overlay confetti celebration
│   │   ├── hz_buttons.dart            # Nút tùy chỉnh
│   │   ├── hz_loading_skeleton.dart   # Skeleton loading
│   │   ├── hz_skeleton.dart           # Skeleton chung
│   │   ├── illustrated_message.dart   # Thông báo với minh họa
│   │   ├── optimized_network_image.dart # Ảnh mạng tối ưu
│   │   ├── shell_scaffold.dart        # Giao diện chính với bottom navigation
│   │   ├── star_rating.dart           # Widget đánh giá sao
│   │   ├── skin_concern_badge.dart    # Badge vấn đề da
│   │   ├── skin_compatibility_indicator.dart # Chỉ số tương thích sản phẩm
│   │   ├── icons/                     # Icon skincare
│   │   │   ├── skin_type_icons.dart   # Icon loại da (oily, dry, combination, ...)
│   │   │   └── ingredient_icons.dart  # Icon thành phần (niacinamide, retinol, ...)
│   │   ├── routine/                   # Widget quy trình chăm sóc
│   │   │   ├── routine_step_card.dart # Card bước chăm sóc với timeline
│   │   │   ├── routine_progress.dart  # Progress tracker dạng tròn
│   │   │   ├── routine_timeline.dart  # Timeline có thể reorder
│   │   │   └── routine_widgets.dart   # Barrel export
│   │   ├── community/                 # Widget cộng đồng
│   │   │   ├── community_post_card.dart # Card bài viết với before/after
│   │   │   ├── product_review_card.dart # Card review sản phẩm
│   │   │   ├── routine_sharing_card.dart # Card chia sẻ quy trình
│   │   │   └── community_widgets.dart # Barrel export
│   │   ├── premium/                   # Widget premium tier
│   │   │   ├── premium_badge.dart     # Badge 5 tier (Free→Diamond)
│   │   │   ├── premium_features.dart  # Feature cards, banners
│   │   │   └── premium_widgets.dart   # Barrel export
│   │   ├── education/                 # Widget giáo dục
│   │   │   ├── skincare_tips.dart     # Card tips (6 categories)
│   │   │   ├── skin_calendar.dart     # Calendar tracking, streak
│   │   │   └── education_widgets.dart # Barrel export
│   │   ├── form/                      # Widget form
│   │   │   └── requirement_checklist.dart # Checklist requirements
│   │   ├── illustrations/             # Illustrations
│   │   │   └── skincare_illustration.dart # SVG illustrations
│   │   └── ui_kit/                    # Bộ widget UI
│   │       ├── hz_responsive_layout.dart # Layout responsive
│   │       ├── hz_section_header.dart # Header section
│   │       ├── hz_stat_chip.dart      # Chip trạng thái
│   │       └── hz_surface_card.dart   # Card bề mặt
│   └── spec/                          # Spec cho UI components
├── theme/                             # Theme và thiết kế
│   ├── app_colors.dart                # Định nghĩa màu sắc
│   ├── app_dimensions.dart            # Kích thước và khoảng cách
│   ├── app_theme.dart                 # Định nghĩa theme tổng thể
│   └── app_typography.dart            # Định nghĩa typography
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

## Cải tiến nổi bật

### 1. Giao diện người dùng (UI/UX)
- **Color System**: Đổi sang bảng màu chăm sóc da với tông màu hồng nhạt, tím nhẹ, xanh bạc hà và kem ấm
- **Illustrations**: Thêm minh họa tùy chỉnh cho các trạng thái trống (empty states)
- **Animations**: Thêm hiệu ứng chuyển động mượt mà và hiệu ứng mừng khi hoàn thành mục tiêu
- **Haptic Feedback**: Tích hợp phản hồi xúc giác cho các tương tác người dùng
- **Celebration Screens**: Màn hình chúc mừng khi đạt được thành tích

### 2. Trải nghiệm người dùng (UX)
- **Hero Sections**: Cải thiện phần tiêu đề chính với hiệu ứng hạt, chỉ số da động
- **Visual Hierarchy**: Cải thiện hệ thống typography và phân cấp thông tin
- **Brand Identity**: Thiết kế mạnh mẽ hơn với nhận diện thương hiệu chăm sóc da
- **Empty States**: Trạng thái trống được cải thiện với minh họa và thông tin hướng dẫn

### 3. Hiệu suất và bảo mật
- **Token Management**: Cải thiện quản lý token với cơ chế làm mới tự động
- **Offline Cache**: Thêm cơ chế lưu trữ cục bộ cho dữ liệu dashboard
- **Image Optimization**: Tối ưu hóa hiển thị hình ảnh với bộ nhớ đệm
- **Error Handling**: Cải thiện xử lý lỗi toàn cục và hiển thị thân thiện

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
