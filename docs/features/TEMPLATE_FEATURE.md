# Mẫu Mô Tả Tính Năng - Dự án AI Skincare Platform

## 1. Mục tiêu Tính năng (Feature Goal)

### Mục tiêu Chính
Mô tả ngắn gọn mục tiêu chính của tính năng này trong dự án AI Skincare Platform.

### Mục tiêu Phụ
Liệt kê các mục tiêu phụ hoặc cải tiến liên quan đến tính năng này.

---

## 2. Mô tả Chi tiết (Detailed Description)

### Bối cảnh
Mô tả lý do tại sao tính năng này cần được phát triển. Những vấn đề nào nó giải quyết?

### Người dùng Mục tiêu
Ai là người sẽ sử dụng tính năng này? (ví dụ: người dùng cuối, quản trị viên, chuyên gia skincare)

### Mô tả Chức năng
Mô tả chi tiết cách thức hoạt động của tính năng, các bước người dùng thực hiện, và các hành động hệ thống phản hồi.

---

## 3. Yêu cầu Kỹ thuật (Technical Requirements)

### API Endpoints
Liệt kê các endpoint API cần được tạo hoặc cập nhật:
- `POST /api/v1/feature-endpoint` - Mô tả chức năng
- `GET /api/v1/feature-endpoint/:id` - Mô tả chức năng
- `PUT /api/v1/feature-endpoint/:id` - Mô tả chức năng
- `DELETE /api/v1/feature-endpoint/:id` - Mô tả chức năng

### Database Schema
Mô tả các bảng/collection mới hoặc cập nhật:
```sql
CREATE TABLE feature_table (
 id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Công nghệ & Thư viện
Liệt kê các công nghệ, thư viện, framework cần sử dụng:
- Công nghệ phía backend
- Công nghệ phía frontend
- Các thư viện xử lý đặc thù

---

## 4. Thiết kế Giao diện (UI/UX Design)

### Wireframes
Chèn hình ảnh hoặc mô tả các wireframes cho tính năng này.

### Flowchart
Mô tả luồng tương tác người dùng với tính năng (có thể sử dụng biểu đồ hoặc văn bản).

---

## 5. Tiêu chí Hoàn thành (Acceptance Criteria)

### Chức năng Chính
- [ ] Tiêu chí 1: Mô tả chi tiết
- [ ] Tiêu chí 2: Mô tả chi tiết
- [ ] Tiêu chí 3: Mô tả chi tiết

### Chức năng Phụ
- [ ] Tiêu chí 4: Mô tả chi tiết
- [ ] Tiêu chí 5: Mô tả chi tiết

### Hiệu suất
- [ ] Tính năng phải xử lý xong trong thời gian < X ms
- [ ] Hỗ trợ tối thiểu Y người dùng đồng thời

### Bảo mật
- [ ] Xác thực người dùng được áp dụng
- [ ] Dữ liệu nhạy cảm được mã hóa

---

## 6. Kế hoạch Triển khai (Implementation Plan)

### Milestones
- [ ] Thiết kế hệ thống - Ngày hoàn thành: MM/DD/YYYY
- [ ] Phát triển backend - Ngày hoàn thành: MM/DD/YYYY
- [ ] Phát triển frontend - Ngày hoàn thành: MM/DD/YYYY
- [ ] Kiểm thử tích hợp - Ngày hoàn thành: MM/DD/YYYY
- [ ] Triển khai lên staging - Ngày hoàn thành: MM/DD/YYYY
- [ ] Triển khai sản xuất - Ngày hoàn thành: MM/DD/YYYY

### Nhóm phụ trách
- Backend: Tên thành viên
- Frontend: Tên thành viên
- QA: Tên thành viên
- DevOps: Tên thành viên

---

## 7. Rủi ro & Giải pháp

### Rủi ro Kỹ thuật
- Rủi ro 1: Mô tả rủi ro + Giải pháp đề xuất
- Rủi ro 2: Mô tả rủi ro + Giải pháp đề xuất

### Rủi ro Kinh doanh
- Rủi ro 1: Mô tả rủi ro + Giải pháp đề xuất
- Rủi ro 2: Mô tả rủi ro + Giải pháp đề xuất

---

## 8. Tài liệu Liên quan

- [Tên tài liệu](liên_kết_đến_tài_liệu)
- [Tên tài liệu](liên_kết_đến_tài_liệu)

---

## 9. Ghi chú Bổ sung

### Các tính năng liên quan
Liệt kê các tính năng khác có liên quan mà cần được xem xét khi phát triển tính năng này.

### Tương lai tính năng
Mô tả các cải tiến hoặc mở rộng có thể được thực hiện trong tương lai cho tính năng này.