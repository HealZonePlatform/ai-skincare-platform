# AI Skincare Platform - Project Overview

## Tổng quan dự án
AI Skincare Platform là một hệ thống tư vấn chăm sóc da thông minh sử dụng trí tuệ nhân tạo để phân tích tình trạng da và đưa ra các đề xuất sản phẩm phù hợp. Nền tảng kết hợp công nghệ AI tiên tiến với dịch vụ tư vấn chuyên gia để mang đến giải pháp chăm sóc da cá nhân hóa.

## Mục tiêu chính
- **Phân tích da thông minh**: Sử dụng computer vision và machine learning để phân tích tình trạng da từ hình ảnh
- **Đề xuất cá nhân hóa**: Gợi ý sản phẩm và liệu trình chăm sóc da phù hợp với từng cá nhân
- **Tư vấn chuyên gia**: Kết nối người dùng với các chuyên gia da liễu để được tư vấn chuyên sâu
- **Trải nghiệm đa nền tảng**: Hỗ trợ cả ứng dụng di động và web dashboard (USER dùng mobile, các vai trò khác dùng web)

## Tính năng chính
### Cho người dùng cuối
- Phân tích da AI: Upload hình ảnh và nhận kết quả phân tích chi tiết về tình trạng da
- Tạo Lộ trình Chăm sóc da: Tự động tạo lộ trình chăm sóc da buổi sáng và buổi tối dựa trên kết quả phân tích
- Đề xuất sản phẩm: Nhận gợi ý sản phẩm chăm sóc da dựa trên kết quả phân tích
- Theo dõi tiến trình: Lưu trữ lịch sử phân tích để theo dõi sự thay đổi của da theo thời gian
- Tư vấn chuyên gia: Đặt lịch hẹn và tư vấn trực tiếp với chuyên gia da liễu
- Quản lý hồ sơ: Cập nhật thông tin cá nhân và sở thích chăm sóc da

### Cho chuyên gia
- Dashboard quản lý: Giao diện web để quản lý lịch hẹn và tư vấn khách hàng
- Công cụ phân tích: Truy cập kết quả phân tích AI để hỗ trợ tư vấn
- Quản lý hồ sơ: Theo dõi hồ sơ và tiến trình điều trị của khách hàng

### Cho đối tác kinh doanh
- Tích hợp sản phẩm: API để tích hợp catalog sản phẩm và quản lý tồn kho
- Phân tích dữ liệu: Thống kê về xu hướng sử dụng và hiệu quả sản phẩm

## Stack công nghệ
- **Mobile App**: Flutter (iOS/Android)
- **Web Dashboard**: Next.js với TypeScript
- **API Gateway**: Node.js + Express
- **Microservices**: Node.js + TypeScript, Python + FastAPI
- **AI/ML**: Python với Google Gemini API, TensorFlow, OpenCV
- **Database**: PostgreSQL, MongoDB, Redis
- **Infrastructure**: Docker + Docker Compose, Google Cloud Platform

## Kiến trúc hệ thống
Hệ thống được xây dựng theo kiến trúc microservices bao gồm:

- **Auth Service**: Xử lý xác thực và quản lý phiên làm việc
- **User Service**: Quản lý thông tin người dùng, hồ sơ, lịch sử phân tích
- **Product Service**: Quản lý catalog sản phẩm chăm sóc da
- **Expert Service**: Quản lý chuyên gia và lịch hẹn tư vấn
- **AI Service**: Phân tích hình ảnh da và đưa ra nhận định bằng Google Gemini
- **Recommendation Service**: Gợi ý sản phẩm dựa trên kết quả phân tích da
- **API Gateway**: Định tuyến và xác thực yêu cầu từ client

## Lộ trình phát triển
### Phase 1 - MVP (Tháng 1-3)
- Thiết lập môi trường phát triển
- Phát triển core AI analysis engine sử dụng Google Gemini
- Xây dựng Flutter mobile app
- API Gateway và User Service
- Tích hợp cơ bản với product catalog

### Phase 2 - Enhanced Features (Tháng 4-5)
- Tích hợp recommendation engine
- Expert consultation system
- Web dashboard cho chuyên gia
- Advanced UI/UX improvements
- Security hardening và performance optimization

### Phase 3 - Full Platform (Tháng 6+)
- Tính năng cộng đồng
- Real-time chat system
- Payment integration
- Advanced analytics dashboard
- Multi-language support

## Đặc điểm nổi bật
- **Tích hợp AI tiên tiến**: Sử dụng Google Gemini để phân tích hình ảnh da và đưa ra khuyến nghị (mock AI services - sẽ tự implement AI model trong tương lai)
- **Hệ thống microservices**: Kiến trúc linh hoạt, dễ mở rộng và bảo trì
- **Đa nền tảng**: Hỗ trợ cả mobile app và web dashboard
- **Tích hợp chuyên gia**: Kết nối người dùng với chuyên gia da liễu thực sự
- **Cá nhân hóa cao**: Gợi ý sản phẩm dựa trên đặc điểm da riêng biệt của từng người dùng