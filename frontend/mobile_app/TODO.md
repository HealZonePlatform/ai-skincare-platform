# TODO - Mobile App (Flutter)

## Kiến trúc ứng dụng
- [ ] Tách biệt rõ ràng hơn giữa các layer (presentation, domain, data)
- [ ] Thêm lớp use cases trong domain layer để áp dụng clean architecture
- [ ] Tạo các interface và abstract class cho các lớp service để dễ dàng test và mock

## Xử lý token tự động
- [ ] Thêm interceptor tự động đính kèm Authorization header
- [ ] Triển khai cơ chế refresh token tự động khi access token hết hạn
- [ ] Xử lý trường hợp refresh token thất bại (đăng xuất người dùng)

## Quản lý API
- [ ] Thay thế hard-code base URL bằng cơ chế cấu hình môi trường linh hoạt
- [ ] Thêm API interceptors để xử lý request/response chung
- [ ] Triển khai retry mechanism cho các request thất bại
- [ ] Thêm timeout configuration linh hoạt cho các loại request khác nhau

## Xử lý lỗi toàn cục
- [ ] Thiết kế hệ thống xử lý lỗi toàn cục với UI thông báo thân thiện
- [ ] Tạo custom exception handler cho các loại lỗi khác nhau
- [ ] Hiển thị thông báo lỗi phù hợp với từng ngữ cảnh

## Kiểm thử
- [ ] Thêm unit test cho các lớp business logic
- [ ] Viết widget test cho các màn hình chính
- [ ] Tạo integration test cho các flow chính (đăng nhập, phân tích da, v.v.)
- [ ] Thiết lập mock API cho việc test

## Tối ưu hóa hiệu suất
- [ ] Thêm lazy loading cho các danh sách dài (lịch sử phân tích da)
- [ ] Tối ưu hóa pagination cho danh sách lịch sử
- [ ] Cải thiện hiệu suất hiển thị hình ảnh lớn
- [ ] Áp dụng caching hiệu quả hơn cho dữ liệu thường xuyên truy cập

## Kiểm tra và xác thực đầu vào
- [ ] Thêm hệ thống validation tập trung cho form
- [ ] Xác thực dữ liệu đầu vào trước khi gửi lên API
- [ ] Hiển thị thông báo lỗi validation thân thiện với người dùng

## Logging và giám sát
- [ ] Thêm hệ thống logging toàn cục
- [ ] Tích hợp analytics (Firebase Analytics hoặc Google Analytics)
- [ ] Ghi log lỗi và hành vi người dùng để phân tích
- [ ] Thiết lập crash reporting (Firebase Crashlytics)

## Cấu hình môi trường
- [ ] Thêm cơ chế cấu hình riêng cho các môi trường dev/staging/prod
- [ ] Tạo file cấu hình riêng biệt cho từng môi trường
- [ ] Tự động chọn API base URL theo môi trường

## Tái sử dụng mã nguồn
- [ ] Thiết kế lại một số widget để tăng khả năng tái sử dụng
- [ ] Tạo thư viện widget chung cho toàn ứng dụng
- [ ] Tái sử dụng các component UI giữa các màn hình

## Tính năng mới cần phát triển
- [ ] Thêm tính năng đa ngôn ngữ (i18n)
- [ ] Cải thiện trải nghiệm người dùng với animation và micro-interaction
- [ ] Thêm cơ chế offline-first cho một số tính năng cơ bản
- [ ] Triển khai push notification cho lời nhắc chăm sóc da
- [ ] Thêm tính năng chia sẻ kết quả phân tích da

## Tối ưu hóa UI/UX
- [ ] Cải thiện giao diện màn hình loading
- [ ] Thêm skeleton screen cho trải nghiệm mượt mà hơn
- [ ] Tối ưu hóa layout cho các kích thước màn hình khác nhau
- [ ] Cải thiện trải nghiệm người dùng trong quá trình quét da

## Bảo mật
- [ ] Kiểm tra lại toàn bộ các điểm có thể bị bảo mật (insecure storage, v.v.)
- [ ] Thêm kiểm tra bảo mật cho các API endpoints
- [ ] Đảm bảo dữ liệu nhạy cảm được mã hóa đúng cách