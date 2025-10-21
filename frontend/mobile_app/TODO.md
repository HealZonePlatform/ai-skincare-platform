# TODO - Mobile App (Flutter)

## Kiến trúc ứng dụng
- [x] Tách riêng rõ ràng các layer (presentation, domain, data)
- [x] Thêm lớp use case trong domain layer theo clean architecture
- [x] Tạo interface/abstract class cho các service để dễ test & mock

## Xử lý token tự động
- [x] Thêm interceptor tự động gắn Authorization header
- [x] Triển khai cơ chế refresh token tự động khi access token hết hạn
- [x] Xử lý trường hợp refresh token thất bại (đăng xuất người dùng)

## Quản lý API
- [x] Thay thế hard-code base URL bằng cấu hình môi trường linh hoạt
- [x] Thêm API interceptors để xử lý request/response chung
- [x] Triển khai retry mechanism cho các request thất bại
- [x] Thêm cấu hình timeout linh hoạt cho các loại request khác nhau

## Xử lý lỗi toàn cục
- [x] Thiết kế hệ thống xử lý lỗi toàn cục với UI thông báo thân thiện
- [x] Tạo custom exception handler cho các loại lỗi khác nhau
- [x] Hiển thị thông báo lỗi phù hợp với từng ngữ cảnh

## Kiểm thử
- [x] Thêm unit test cho các lớp business logic
- [x] Viết widget test cho các màn hình chính
- [x] Tạo integration test cho các flow chính (đăng nhập, phân tích da, v.v.)
- [ ] Thiết lập mock API cho việc test

## Tối ưu hiệu suất
- [x] Thêm lazy loading cho các danh sách dài (lịch sử phân tích da)
- [x] Tối ưu pagination cho danh sách lịch sử
- [ ] Cải thiện hiệu suất hiển thị hình ảnh lớn
- [x] Áp dụng caching hiệu quả hơn cho dữ liệu thường xuyên truy cập

## Kiểm tra và xác thực đầu vào
- [x] Thêm hệ thống validation tập trung cho form
- [x] Xác thực dữ liệu đầu vào trước khi gửi lên API
- [x] Hiển thị thông báo lỗi validation thân thiện với người dùng

## Logging và giám sát
- [x] Thêm hệ thống logging toàn cục
- [x] Tích hợp analytics (Google Analytics) dạng lightweight
- [x] Ghi log lỗi và hành vi người dùng để phân tích
- [ ] Thiết lập crash reporting (Firebase Crashlytics)

## Cấu hình môi trường
- [x] Thêm cơ chế cấu hình riêng cho các môi trường dev/staging/prod
- [ ] Tạo file cấu hình riêng biệt cho từng môi trường
- [x] Tự động chọn API base URL theo môi trường

## Tái sử dụng mã nguồn
- [ ] Thiết kế lại một số widget để tăng khả năng tái sử dụng
- [ ] Tạo thư viện widget chung cho toàn ứng dụng
- [ ] Tái sử dụng các component UI giữa các màn hình

## Tính năng mới cần phát triển
- [x] Thêm tính năng đa ngôn ngữ (i18n)
- [ ] Cải thiện trải nghiệm người dùng với animation/micro-interaction
- [x] Thêm cơ chế offline-first cho một số tính năng cơ bản
- [ ] Triển khai push notification cho lời nhắc chăm sóc da
- [ ] Thêm tính năng chia sẻ kết quả phân tích da

## Tối ưu UI/UX
- [ ] Cải thiện giao diện màn hình loading
- [ ] Thêm skeleton screen cho trải nghiệm mượt mà hơn
- [ ] Tối ưu layout cho các kích thước màn hình khác nhau
- [ ] Cải thiện trải nghiệm người dùng trong quá trình quét da

## Bảo mật
- [ ] Kiểm tra lỗi tiềm ẩn có thể bị khai thác (insecure storage, v.v.)
- [ ] Thêm kiểm tra bảo mật cho các API endpoints
- [ ] Đảm bảo dữ liệu nhạy cảm được mã hóa đúng cách
