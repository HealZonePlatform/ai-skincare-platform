# Tổng quan Hệ thống AI Skincare Platform

## Mục lục
- [Giới thiệu dự án](00_PROJECT_OVERVIEW.md)
- [Kiến trúc hệ thống](01_ARCHITECTURE.md)
- [Quy trình làm việc với Git](02_GITHUB_WORKFLOW.md)
- [Tiêu chuẩn lập trình](03_CODING_STANDARDS.md)
- [Hướng dẫn cài đặt](04_SETUP_GUIDE.md)
- [Kế hoạch phát triển Web Dashboard](05_WEB_DASHBOARD_PLAN.md)
- [Tài liệu tính năng](#tài-liệu-tính-năng)

## Mục tiêu dự án
AI Skincare Platform là một hệ thống tư vấn chăm sóc da thông minh sử dụng trí tuệ nhân tạo để phân tích tình trạng da và đưa ra các đề xuất sản phẩm phù hợp. Nền tảng kết hợp công nghệ AI tiên tiến với dịch vụ tư vấn chuyên gia để mang đến giải pháp chăm sóc da cá nhân hóa.

## Kiến trúc tổng quan
Hệ thống được xây dựng theo kiến trúc microservices bao gồm:
- **Client Layer**: Flutter Mobile App và Next.js Web Dashboard
- **API Gateway**: Node.js + Express làm điểm truy cập duy nhất
- **Microservices**: Auth Service, User Service, Product Service, Expert Service, AI Service, Recommendation Service
- **Data Layer**: PostgreSQL, MongoDB, Redis

## Công nghệ sử dụng
- **Ngôn ngữ lập trình**: TypeScript, Python, Dart
- **Framework**: Node.js, Express, FastAPI, Flutter, Next.js
- **Cơ sở dữ liệu**: PostgreSQL, MongoDB, Redis
- **Công cụ**: Docker, Docker Compose, Google Cloud Platform

## Tài liệu tính năng
- [Phân tích da AI](features/skin-analysis-ai.md)
- [Màn hình hồ sơ người dùng](features/user-profile-screen.md)
- [Mẫu tài liệu tính năng](features/TEMPLATE_FEATURE.md)

## Triển khai
Hệ thống hỗ trợ triển khai với Docker Compose cho môi trường phát triển, staging và production. Xem chi tiết trong [hướng dẫn cài đặt](04_SETUP_GUIDE.md).

## Phát triển Web Dashboard
Phần Web Dashboard đang trong giai đoạn lập kế hoạch và chưa được triển khai mã nguồn. Xem chi tiết trong [kế hoạch phát triển Web Dashboard](05_WEB_DASHBOARD_PLAN.md).

## Bảo trì và phát triển
Dự án sử dụng quy trình Git Flow để quản lý mã nguồn và đảm bảo chất lượng code thông qua các tiêu chuẩn lập trình được quy định trong [coding standards](03_CODING_STANDARDS.md).