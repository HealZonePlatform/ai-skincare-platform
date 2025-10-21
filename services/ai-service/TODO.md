# TODO - AI Service - Cải Thiện và Nâng Cấp

## Mục Lục
- [Phân tích hiện trạng](#phân-tích-hiện-trạng)
- [Cải tiến cơ sở dữ liệu](#cải-tiến-cơ-sở-dữ-liệu)
- [Nâng cấp dịch vụ phân tích](#nâng-cấp-dịch-vụ-phân-tích)
- [Bảo mật và hiệu năng](#bảo-mật-và-hiệu-năng)
- [Kiến trúc hệ thống](#kiến-trúc-hệ-thống)
- [Kiểm thử và giám sát](#kiểm-thử-và-giám-sát)

## Phân tích hiện trạng

### Cơ sở dữ liệu (PostgreSQL)
- Schema hiện tại trong `database/init.sql` đã thiết kế bảng `skin_analyses` với các trường:
  - `id`, `user_id`, `image_url`, `analysis_result` (JSONB), `confidence_score`, `ai_model_version`
  - `recommendations` (JSONB), `severity_level`, `skin_concerns` (TEXT[]), `analysis_date`
  - `processed_by`, `processing_time_ms`, `metadata` (JSONB), `created_at`, `updated_at`
- Có các index GIN cho các cột JSONB và mảng để tối ưu truy vấn
- Có trigger tự động cập nhật `updated_at` cho các bảng chính

### Dịch vụ AI hiện tại
- Sử dụng Google Gemini API để phân tích ảnh da
- Có endpoint `/api/v1/analysis` để chạy phân tích mới
- Có endpoint `/api/v1/analysis/{analysis_id}` để lấy kết quả phân tích
- Có endpoint `/api/v1/analysis` để liệt kê các phân tích cho người dùng
- Có endpoint `/api/v1/analysis/{analysis_id}/feedback` để thu thập phản hồi

## Cải tiến cơ sở dữ liệu

### [x] Tích hợp với hệ thống chính
- [x] Tạo ràng buộc khóa ngoại giữa `skin_analyses.user_id` và bảng `users.id` trong hệ thống auth/user
- [x] Đảm bảo tính toàn vẹn dữ liệu giữa các dịch vụ (AI Service và User Service)

### [x] Cải thiện hiệu năng truy vấn
- [x] Tối ưu hóa các chỉ số (indexes) dựa trên các mẫu truy vấn thực tế
- [x] Xem xét thêm chỉ số cho các trường thường được dùng trong tìm kiếm như `ai_model_version`, `severity_level`
- [x] Bổ sung bộ lọc severity/model/time cho API liệt kê để tận dụng chỉ số hiện có
- [x] Đánh giá hiệu năng với lượng dữ liệu lớn và tối ưu hóa nếu cần

### [x] Quản lý dữ liệu lịch sử
- [x] Xem xét chiến lược lưu trữ dữ liệu lâu dài (archiving)
- [x] Triển khai cơ chế xóa dữ liệu cũ theo chính sách bảo mật

## Nâng cấp dịch vụ phân tích

### [x] Hỗ trợ nhiều mô hình AI
- [x] Thiết kế hệ thống có thể dễ dàng tích hợp với nhiều mô hình AI khác nhau (không chỉ Gemini)
- [x] Triển khai cơ chế chọn mô hình dựa trên loại ảnh đầu vào hoặc yêu cầu người dùng
- [x] Thêm khả năng so sánh kết quả giữa các mô hình

### [x] Tiền xử lý ảnh
- [x] Thêm module tiền xử lý ảnh để chuẩn hóa đầu vào trước khi phân tích
- [x] Thực hiện các bước như resize, normalize, crop vùng mặt
- [x] Hỗ trợ các định dạng ảnh khác nhau và kiểm tra chất lượng ảnh đầu vào

### [x] Phân tích đa chế độ
- [ ] Hỗ trợ phân tích từ ảnh, video hoặc chuỗi ảnh theo thời gian
- [x] Thêm khả năng so sánh kết quả phân tích qua thời gian để theo dõi tiến triển

### [x] Cải thiện chất lượng phân tích
- [x] Tinh chỉnh prompt cho mô hình AI để cải thiện độ chính xác
- [x] Thêm cơ chế xác thực chất lượng kết quả trước khi trả về cho người dùng
- [x] Triển khai cơ chế đánh giá độ tin cậy của kết quả phân tích

## Bảo mật và hiệu năng

### [ ] Bảo mật upload ảnh
- [x] Thêm kiểm tra kích thước file và định dạng ảnh được phép
- [x] Triển khai quét mã độc cho ảnh upload
- [x] Giới hạn số lượng request theo IP/user để tránh abuse

### [x] Quản lý API key
- [x] Triển khai cơ chế luân chuyển API key an toàn
- [x] Thêm cơ chế dự phòng nếu API key chính gặp sự cố

### [ ] Hiệu năng và độ tin cậy
- [x] Triển khai cơ chế retry khi gọi API bên ngoài thất bại
- [x] Thêm cơ chế cache kết quả phân tích để tránh gọi lại không cần thiết
- [x] Tối ưu hóa thời gian xử lý và giảm độ trễ phản hồi

### [ ] Quản lý tài nguyên
- [x] Triển khai cơ chế giới hạn đồng thời các tác vụ phân tích
- [x] Theo dõi và tối ưu hóa việc sử dụng bộ nhớ và CPU

## Kiến trúc hệ thống

### [x] Tích hợp với cơ sở dữ liệu chính thức
- [x] Thay thế bộ lưu trữ trong bộ nhớ (`AnalysisStore`) bằng kết nối trực tiếp với PostgreSQL
- [x] Đảm bảo tất cả dữ liệu phân tích được lưu trữ vĩnh viễn trong cơ sở dữ liệu
- [x] Triển khai các phương thức truy cập dữ liệu (DAO/Repository pattern)

### [ ] Tính mở rộng
- [ ] Thiết kế hệ thống có thể dễ dàng mở rộng để hỗ trợ nhiều loại phân tích khác nhau
- [ ] Chuẩn bị cho việc triển khai hàng đợi tác vụ (task queue) cho các phân tích dài hạn

### [x] Tích hợp với hệ sinh thái
- [x] Đảm bảo dữ liệu phân tích có thể được truy cập từ các dịch vụ khác như Recommendation Service
- [x] Triển khai webhook hoặc event system để thông báo kết quả phân tích cho các dịch vụ khác

## Kiểm thử và giám sát

### [ ] Bộ kiểm thử toàn diện
- [x] Viết unit test cho tất cả các thành phần dịch vụ
- [ ] Viết integration test cho các endpoint API
- [x] Thêm test cho các trường hợp biên và lỗi

### [ ] Giám sát và ghi nhật ký
- [x] Triển khai hệ thống logging chi tiết cho quá trình phân tích
- [x] Thêm metrics để theo dõi hiệu suất và chất lượng phân tích
- [ ] Thiết lập alert khi có lỗi hoặc hiệu suất giảm sút

### [ ] Đánh giá chất lượng mô hình
- [ ] Thiết lập quy trình đánh giá định kỳ chất lượng kết quả phân tích
- [ ] Thu thập và phân tích phản hồi từ người dùng để cải thiện mô hình
- [ ] So sánh kết quả phân tích với đánh giá của chuyên gia da liễu

## Tính năng nâng cao

### [x] Phân tích lịch sử và xu hướng
- [x] Thêm khả năng phân tích sự thay đổi của làn da theo thời gian
- [x] Tạo báo cáo xu hướng và tiến triển điều trị

### [ ] Tùy chỉnh theo người dùng
- [x] Cho phép người dùng điều chỉnh mức độ chi tiết của phân tích
- [ ] Tùy chỉnh ngôn ngữ và văn hóa trong kết quả phân tích
- [ ] Hỗ trợ phân tích dựa trên lịch sử y tế và dị ứng của người dùng
