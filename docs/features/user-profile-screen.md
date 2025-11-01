# Tính năng Màn hình Hồ sơ Người dùng - Dự án AI Skincare Platform

## 1. Mục tiêu Tính năng (Feature Goal)

### Mục tiêu Chính
Cung cấp cho người dùng khả năng xem và quản lý thông tin hồ sơ cá nhân trong ứng dụng AI Skincare Platform, bao gồm thông tin cơ bản, lịch sử chăm sóc da và tùy chọn cài đặt cá nhân.

### Mục tiêu Phụ
- Tăng cường trải nghiệm người dùng bằng cách cung cấp giao diện dễ sử dụng để quản lý thông tin cá nhân
- Tích hợp với hệ thống xác thực để đảm bảo bảo mật thông tin người dùng
- Cho phép người dùng cập nhật thông tin cá nhân và cài đặt liên quan đến chăm sóc da

---

## 2. Mô tả Chi tiết (Detailed Description)

### Bối cảnh
Trong ứng dụng AI Skincare Platform, người dùng cần có khả năng truy cập và quản lý thông tin cá nhân của họ. Tính năng này giải quyết nhu cầu cơ bản của người dùng trong việc xem và cập nhật hồ sơ cá nhân, bao gồm thông tin cá nhân, tùy chọn cài đặt và lịch sử sử dụng dịch vụ.

### Người dùng Mục tiêu
Người dùng cuối (người dùng đã đăng ký sử dụng ứng dụng AI Skincare Platform) là đối tượng chính sử dụng tính năng này.

### Mô tả Chức năng
Người dùng có thể truy cập màn hình hồ sơ từ menu chính hoặc từ khu vực tài khoản. Màn hình này hiển thị thông tin cá nhân hiện tại (tên, email, giới tính, ngày sinh, v.v.) và cho phép người dùng chỉnh sửa thông tin này. Ngoài ra, người dùng có thể quản lý cài đặt thông báo, lịch sử phân tích da, mục tiêu chăm sóc da và lịch nhắc nhở.

---

## 3. Yêu cầu Kỹ thuật (Technical Requirements)

### API Endpoints
Liệt kê các endpoint API cần được tạo hoặc cập nhật:
- `GET /api/v1/me/profile` - Lấy thông tin hồ sơ người dùng
- `PUT /api/v1/me/profile` - Cập nhật thông tin hồ sơ người dùng
- `GET /api/v1/me/history` - Lấy lịch sử phân tích da của người dùng
- `GET /api/v1/me/reminders` - Lấy lịch nhắc nhở chăm sóc da
- `PUT /api/v1/me/reminders` - Cập nhật lịch nhắc nhở chăm sóc da
- `GET /api/v1/me/lifestyle` - Lấy thông tin lối sống
- `PUT /api/v1/me/lifestyle` - Cập nhật thông tin lối sống
- `GET /api/v1/me/goals` - Lấy mục tiêu chăm sóc da
- `PUT /api/v1/me/goals` - Cập nhật mục tiêu chăm sóc da

### Database Schema
Các bảng cần được cập nhật để hỗ trợ tính năng hồ sơ người dùng:
```sql
-- Bảng user_profiles để lưu trữ thông tin hồ sơ
CREATE TABLE user_profiles (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  full_name VARCHAR(255),
  phone VARCHAR(20),
  gender VARCHAR(10),
  dob DATE,
  preferences JSONB,
  avatar_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng user_lifestyles để lưu trữ thông tin lối sống
CREATE TABLE user_lifestyles (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  skin_type VARCHAR(50),
  concerns JSONB,
  routine JSONB,
  environment JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng user_goals để lưu trữ mục tiêu chăm sóc da
CREATE TABLE user_goals (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  goal_type VARCHAR(50),
  target_date DATE,
  current_progress INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng user_reminders để lưu trữ lịch nhắc nhở
CREATE TABLE user_reminders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  reminder_type VARCHAR(50),
  schedule JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Công nghệ & Thư viện
- Công nghệ phía backend: Node.js, TypeScript, Express.js, PostgreSQL
- Công nghệ phía frontend: Flutter, Dart
- Các thư viện xử lý đặc thù: JWT cho xác thực, Bcrypt cho mã hóa mật khẩu
- Package chia sẻ: hz-shared cho các tiện ích chung

---

## 4. Thiết kế Giao diện (UI/UX Design)

### Wireframes
Màn hình hồ sơ người dùng bao gồm:
- Header với tiêu đề "Hồ sơ" và nút quay lại
- Ảnh đại diện người dùng với tùy chọn thay đổi
- Danh sách thông tin người dùng (email, tên, giới tính, ngày sinh)
- Nút "Chỉnh sửa hồ sơ" để cập nhật thông tin
- Mục "Lối sống" với thông tin về loại da, mối quan tâm, môi trường
- Mục "Mục tiêu chăm sóc da" để theo dõi tiến độ
- Mục "Lịch nhắc nhở" để quản lý các hoạt động chăm sóc da
- Nút "Đăng xuất" ở cuối màn hình

### Flowchart
Luồng tương tác người dùng:
1. Người dùng nhấn vào biểu tượng hồ sơ/tài khoản
2. Hệ thống hiển thị màn hình hồ sơ với thông tin hiện tại
3. Người dùng có thể chọn xem chi tiết hoặc nhấn nút "Chỉnh sửa"
4. Nếu chọn chỉnh sửa, hệ thống chuyển sang màn hình cập nhật thông tin
5. Người dùng cập nhật thông tin và nhấn lưu
6. Hệ thống cập nhật thông tin trên backend và phản ánh thay đổi trên giao diện

---

## 5. Tiêu chí Hoàn thành (Acceptance Criteria)

### Chức năng Chính
- [x] Người dùng có thể xem thông tin hồ sơ hiện tại
- [x] Người dùng có thể cập nhật thông tin cá nhân (tên, ngày sinh, giới tính, v.v.)
- [x] Người dùng có thể thay đổi ảnh đại diện
- [x] Người dùng có thể xem lịch sử phân tích da đã thực hiện

### Chức năng Phụ
- [x] Người dùng có thể quản lý cài đặt nhắc nhở chăm sóc da
- [x] Người dùng có thể xem và cập nhật thông tin lối sống
- [x] Người dùng có thể thiết lập và theo dõi mục tiêu chăm sóc da
- [x] Người dùng có thể đăng xuất khỏi ứng dụng

### Hiệu suất
- [x] Màn hình hồ sơ tải trong vòng 2 giây
- [x] Các thao tác cập nhật thông tin hoàn thành trong vòng 3 giây

### Bảo mật
- [x] Yêu cầu xác thực người dùng trước khi truy cập hồ sơ
- [x] Dữ liệu nhạy cảm được bảo vệ phù hợp
- [x] Chỉ người dùng sở hữu hồ sơ mới có thể truy cập và chỉnh sửa

---

## 6. Kế hoạch Triển khai (Implementation Plan)

### Milestones
- [x] Thiết kế UI/UX cho màn hình hồ sơ - Ngày hoàn thành: 10/15/2025
- [x] Phát triển backend API cho hồ sơ người dùng - Ngày hoàn thành: 10/20/2025
- [x] Phát triển giao diện Flutter cho màn hình hồ sơ - Ngày hoàn thành: 10/25/2025
- [x] Tích hợp API với giao diện - Ngày hoàn thành: 10/28/2025
- [x] Kiểm thử tích hợp - Ngày hoàn thành: 10/30/2025
- [x] Triển khai lên staging - Ngày hoàn thành: 11/02/2025

### Nhóm phụ trách
- Backend: Developer A
- Frontend: Developer B
- QA: Tester C
- DevOps: DevOps Engineer D

---

## 7. Rủi ro & Giải pháp

### Rủi ro Kỹ thuật
- Rủi ro 1: Tích hợp giữa frontend và backend có thể gặp vấn đề về định dạng dữ liệu - Giải pháp: Đảm bảo tài liệu API rõ ràng và sử dụng công cụ kiểm tra API trong quá trình phát triển
- Rủi ro 2: Hiệu suất tải thông tin hồ sơ chậm do lượng dữ liệu lớn - Giải pháp: Tối ưu hóa truy vấn cơ sở dữ liệu và sử dụng bộ nhớ đệm (caching) nếu cần

### Rủi ro Kinh doanh
- Rủi ro 1: Người dùng không hài lòng với giao diện mới - Giải pháp: Thực hiện các phiên kiểm thử người dùng trước khi triển khai hoàn chỉnh
- Rủi ro 2: Tính năng không được sử dụng nhiều như dự kiến - Giải pháp: Theo dõi chỉ số sử dụng và thu thập phản hồi từ người dùng để cải tiến

---

## 8. Tài liệu Liên quan

- [Tài liệu API Users](../api-docs/users-api.md)
- [Hướng dẫn bảo mật ứng dụng](../security-guidelines.md)
- [Thiết kế hệ thống xác thực](../auth-system-design.md)

---

## 9. Ghi chú Bổ sung

### Các tính năng liên quan
- Tính năng đăng nhập/đăng ký (liên quan đến xác thực người dùng)
- Tính năng phân tích da (liên quan đến lịch sử phân tích)
- Tính năng thông báo (liên quan đến cài đặt nhắc nhở)

### Tương lai tính năng
- Thêm khả năng đồng bộ hồ sơ với mạng xã hội
- Tích hợp với hệ thống chăm sóc khách hàng
- Thêm tùy chọn ngôn ngữ cho hồ sơ người dùng