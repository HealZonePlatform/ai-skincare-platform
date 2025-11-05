Context - Web Dashboard (Next.js 14)

- Mục đích
  - Cổng quản trị/chuyên gia: theo dõi số liệu, duyệt phân tích, quản lý người dùng/sản phẩm, báo cáo.

- Trạng thái hiện tại
  - Đã hoàn thiện giao diện cơ bản với Next.js 14 App Router và Tailwind CSS
  - Đã có mock data và role-based routing cho partner, expert, admin
  - Đã hoàn thành các module: Partner (overview, product catalogue, insights), Expert (review queue, history), Admin (user management, approval queue, reports, settings)
  - Đang sử dụng dữ liệu mock, chờ tích hợp API thực tế
  - Đã có cấu hình lint, test, type checking sẵn sàng

- Mức độ hoàn thiện
  - Giao diện: ~80% - Đã có hầu hết các màn hình chính, chỉ còn thiếu một số form tạo sản phẩm và review submission
  - Chức năng: ~60% - Đã có UI hoàn chỉnh, đang chờ tích hợp backend
  - Xác thực: ~20% - Đang ở dạng mock, chưa tích hợp Auth Service

- Các chức năng đã có
  - Dashboard theo vai trò (partner, expert, admin)
  - Quản lý sản phẩm cho đối tác
  - Xem và duyệt review cho chuyên gia
 - Quản lý người dùng và phê duyệt cho admin
  - Báo cáo và thống kê
  - Hệ thống navigation và role switching

- Các điểm tích hợp với các module khác
 - API Gateway cho việc gọi backend services
  - Auth Service cho xác thực và phân quyền
  - Các service khác (product, user, expert, ai) thông qua API Gateway
  - React Query cho quản lý state và cache dữ liệu

- Các vấn đề cần giải quyết
  - Tích hợp xác thực JWT với refresh token từ Auth Service
  - Thay thế mock data bằng API calls thực tế
  - Thêm upload widgets cho hình ảnh và tài liệu
  - Viết test coverage cho các component và hooks
  - Hoàn thiện product creation wizard và review submission form

