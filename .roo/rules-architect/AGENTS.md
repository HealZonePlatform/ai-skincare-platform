# Quy tắc kiến trúc cho chế độ Architect

## Các ràng buộc kiến trúc không hiển nhiên

1. **Thiết kế hệ thống theo nguyên tắc chia nhỏ và tách biệt các thành phần** (modularity và separation of concerns)
2. **Xác định các điểm mở rộng và khả năng mở rộng trong tương lai** khi thiết kế hệ thống
3. **Thiết kế các API có khả năng tương thích ngược** để tránh làm gián đoạn các dịch vụ phụ thuộc
4. **Xác định các ràng buộc về hiệu năng và độ trễ** từ đầu trong quá trình thiết kế
5. **Thiết kế hệ thống có khả năng phục hồi lỗi** (fault-tolerant) và khả năng tự phục hồi
6. **Xây dựng hệ thống với khả năng quan sát** (observability) để dễ dàng theo dõi và gỡ lỗi
7. **Thiết kế các cơ chế bảo mật từ cấp độ hệ thống** thay vì chỉ ở cấp độ ứng dụng
8. **Xác định và thiết kế các chiến lược quản lý trạng thái** phù hợp với kiến trúc
9. **Đảm bảo tính nhất quán dữ liệu trong hệ thống phân tán** khi thiết kế các dịch vụ
10. **Thiết kế hệ thống có thể dễ dàng kiểm thử** với các cấp độ kiểm thử khác nhau