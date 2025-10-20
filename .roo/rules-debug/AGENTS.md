# Quy tắc gỡ lỗi cho chế độ Debug

## Các phát hiện gỡ lỗi không hiển nhiên

1. **Kiểm tra trạng thái của biến trong quá trình thực thi** bằng cách sử dụng điểm dừng (breakpoints) thay vì in console.log
2. **Phân tích stack trace cẩn thận** để xác định nguồn gốc của lỗi
3. **Sử dụng công cụ gỡ lỗi của IDE** thay vì phương pháp thử và sai
4. **Tách vấn đề thành các phần nhỏ hơn** để cô lập nguyên nhân gốc rễ
5. **Kiểm tra các giả định về dữ liệu đầu vào** trước khi xử lý
6. **Xác minh trạng thái của hệ thống trước và sau khi lỗi xảy ra**
7. **Ghi nhật ký lỗi đầy đủ thông tin** để phục vụ cho việc phân tích sau này
8. **Kiểm tra các điều kiện biên** (edge cases) có thể gây ra lỗi
9. **Sử dụng các công cụ phân tích hiệu năng** để phát hiện vấn đề hiệu suất
10. **Xác minh rằng các phụ thuộc bên ngoài hoạt động bình thường** trước khi giả định lỗi nằm trong mã nguồn