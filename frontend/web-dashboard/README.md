# HealZone Web Dashboard

Cổng quản trị dành cho chuyên gia và quản trị viên hệ thống HealZone. Ứng dụng cung cấp giao diện để theo dõi số liệu, quản lý người dùng, sản phẩm, phân tích da và các hoạt động tư vấn.

## Tính năng chính

- Dashboard thống kê và phân tích dữ liệu
- Quản lý hồ sơ chuyên gia và người dùng
- Theo dõi kết quả phân tích da
- Quản lý lịch tư vấn và cuộc hẹn
- Quản lý danh mục sản phẩm và khuyến nghị
- Công cụ hỗ trợ tư vấn chuyên gia

## Công nghệ sử dụng

- React với TypeScript
- Material UI hoặc Ant Design cho giao diện
- React Router cho điều hướng
- Redux hoặc React Query cho quản lý trạng thái
- Integration với API Gateway

## Cài đặt và phát triển

```bash
# Cài đặt dependencies
npm install

# Chạy ứng dụng ở chế độ phát triển
npm run dev

# Build cho môi trường production
npm run build
```

## Cấu hình môi trường

Tạo file `.env` từ mẫu `.env.example` và cấu hình các biến môi trường cần thiết.

## Docker

```bash
# Build Docker image
docker build -t healzone-web-dashboard .

# Chạy container
docker run --rm -p 3000:3000 --env-file .env healzone-web-dashboard
```

## Trạng thái hiện tại

Dự án đang trong giai đoạn phát triển ban đầu. Giao diện cơ bản và các tính năng chính đang được xây dựng.