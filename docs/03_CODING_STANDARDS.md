# Coding Standards - Quy chuẩn về code

## Tổng quan
Tài liệu này mô tả các quy chuẩn lập trình áp dụng cho toàn bộ dự án AI Skincare Platform. Việc tuân thủ các quy chuẩn này giúp đảm bảo chất lượng code, khả năng đọc hiểu và bảo trì hệ thống dễ dàng hơn.

## 1. Quy chuẩn chung

### 1.1. Ngôn ngữ lập trình
- **Backend Services**: TypeScript cho các service Node.js, Python cho các service AI
- **Frontend**: TypeScript cho React web dashboard, Dart cho Flutter mobile app
- **Database**: SQL cho PostgreSQL, JavaScript cho MongoDB queries
- **Infrastructure**: YAML cho Kubernetes configs, JSON cho config files

### 1.2. Quản lý phụ thuộc
- Sử dụng package managers chính thức (npm, yarn, pub, pip)
- Luôn cập nhật các thư viện đến phiên bản ổn định
- Tránh sử dụng các thư viện không được bảo trì hoặc có lỗ hổng bảo mật
- Ghi rõ lý do sử dụng mỗi thư viện trong README của module

## 2. Quy chuẩn cho từng ngôn ngữ

### 2.1. TypeScript/JavaScript
- Sử dụng ESLint và Prettier với cấu hình chuẩn
- Tuân thủ chuẩn Airbnb hoặc Standard
- Sử dụng type definitions cho tất cả các biến và hàm
- Tránh sử dụng `any` trừ khi thực sự cần thiết
- Sử dụng interface thay vì type khi có thể
- Sử dụng async/await thay vì callback
- Đặt tên biến và hàm theo chuẩn camelCase
- Đặt tên class theo chuẩn PascalCase
- Sử dụng const cho biến không thay đổi, let cho biến có thay đổi
- Tránh biến toàn cục, sử dụng module pattern hoặc dependency injection

### 2.2. Python
- Tuân thủ PEP 8 style guide
- Sử dụng Black cho code formatting
- Sử dụng type hints cho tất cả các hàm
- Sử dụng snake_case cho tên biến và hàm
- Sử dụng PascalCase cho tên class
- Tránh import wildcard (*)
- Sử dụng f-string thay vì .format() hoặc %
- Đặt tên biến mô tả rõ ràng mục đích
- Sử dụng docstring cho tất cả các hàm và class

### 2.3. Dart (Flutter)
- Tuân thủ Dart style guide
- Sử dụng effective_dart cho linting
- Sử dụng camelCase cho tên biến và hàm
- Sử dụng PascalCase cho tên class và enum
- Sử dụng snake_case cho tên file
- Tổ chức code theo pattern (MVC, BLoC, Provider)
- Sử dụng widget riêng biệt cho các thành phần UI phức tạp
- Quản lý state một cách rõ ràng và hiệu quả

### 2.4. SQL
- Sử dụng UPPER CASE cho từ khóa SQL (SELECT, FROM, WHERE, v.v.)
- Sử dụng LOWER CASE cho tên bảng và cột
- Sử dụng alias cho bảng khi truy vấn nhiều bảng
- Tránh SELECT * thay vào đó chỉ chọn các cột cần thiết
- Sử dụng index cho các cột thường xuyên được dùng trong WHERE clause
- Tránh các truy vấn N+1

## 3. Cấu trúc thư mục và tổ chức code

### 3.1. Backend Services
```
src/
├── controllers/     # Xử lý request/response
├── routes/          # Định nghĩa API routes
├── services/        # Business logic
├── models/          # Database models
├── middleware/      # Custom middleware
├── utils/           # Hàm tiện ích
├── config/          # Cấu hình ứng dụng
├── types/           # Type definitions
└── app.ts           # Entry point
```

### 3.2. Frontend React
```
src/
├── components/      # UI components
├── pages/           # Page components
├── hooks/           # Custom hooks
├── services/        # API calls
├── utils/           # Utility functions
├── types/           # Type definitions
├── styles/          # CSS/SCSS files
└── App.tsx          # Entry point
```

### 3.3. Frontend Flutter
```
lib/
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── models/          # Data models
├── services/        # API and business logic
├── providers/       # State management
├── utils/           # Utility functions
├── theme/           # UI theme
└── main.dart        # Entry point
```

## 4. Đặt tên (Naming Conventions)

### 4.1. Tên biến và hàm
- Sử dụng tên mô tả rõ ràng mục đích
- Tránh viết tắt trừ khi là từ viết tắt phổ biến
- Sử dụng tên động từ cho hàm (getUsers, validateInput)
- Sử dụng tên danh từ cho biến (userName, productList)

### 4.2. Tên file
- Sử dụng kebab-case cho tên file
- Tên file phản ánh nội dung chính
- Giữ tên file ngắn gọn nhưng mô tả

### 4.3. Tên thư mục
- Sử dụng lowercase cho tên thư mục
- Tên thư mục phản ánh chức năng
- Tránh sử dụng dấu cách và ký tự đặc biệt

## 5. Xử lý lỗi và logging

### 5.1. Xử lý lỗi
- Sử dụng try-catch khi cần thiết
- Xử lý lỗi một cách cụ thể thay vì bắt tất cả lỗi cùng một cách
- Không để lỗi không được xử lý lan ra ngoài hệ thống
- Trả về lỗi có cấu trúc cho client (error code, message, details)

### 5.2. Logging
- Sử dụng thư viện logging chuẩn (winston, loguru, v.v.)
- Ghi log với nhiều cấp độ (debug, info, warn, error)
- Bao gồm thông tin ngữ cảnh trong log (user ID, request ID, v.v.)
- Không ghi log thông tin nhạy cảm (password, token, v.v.)

## 6. Bảo mật

### 6.1. Xác thực và ủy quyền
- Sử dụng JWT tokens cho xác thực
- Áp dụng middleware xác thực cho các route cần bảo vệ
- Kiểm tra quyền truy cập trước khi thực hiện hành động

### 6.2. Xử lý đầu vào
- Luôn validate dữ liệu đầu vào
- Sử dụng thư viện validation chuyên dụng
- Tránh SQL injection bằng cách sử dụng parameterized queries
- Tránh XSS bằng cách escape output

### 6.3. Cấu hình bảo mật
- Không hardcode secrets trong code
- Sử dụng environment variables cho cấu hình nhạy cảm
- Sử dụng HTTPS cho tất cả các kết nối
- Áp dụng các header bảo mật cần thiết

## 7. Testing

### 7.1. Unit Testing
- Viết test cho tất cả các hàm xử lý logic quan trọng
- Đảm bảo coverage tối thiểu 80%
- Sử dụng các thư viện testing phù hợp (Jest, pytest, v.v.)

### 7.2. Integration Testing
- Kiểm thử các module làm việc cùng nhau
- Kiểm thử API endpoints
- Kiểm thử các tương tác với database

### 7.3. Naming Convention cho test
- Đặt tên test mô tả rõ ràng hành vi được kiểm thử
- Sử dụng format: "should [expected behavior] when [condition]"

## 8. Performance và Optimization

### 8.1. Database
- Sử dụng index cho các truy vấn thường xuyên
- Tránh N+1 queries
- Sử dụng connection pooling
- Pagination cho các danh sách lớn

### 8.2. API
- Sử dụng caching cho dữ liệu không thay đổi thường xuyên
- Pagination cho các danh sách lớn
- Compression cho response
- Rate limiting để bảo vệ hệ thống

### 8.3. Frontend
- Lazy loading cho các module lớn
- Code splitting để giảm kích thước bundle
- Caching cho các tài nguyên tĩnh
- Tối ưu hình ảnh và tài nguyên media

## 9. Documentation

### 9.1. Inline Comments
- Viết comment cho các đoạn code phức tạp
- Giải thích lý do của các quyết định thiết kế
- Tránh comment những điều hiển nhiên

### 9.2. Function Documentation
- Sử dụng JSDoc, Python docstrings, hoặc Dart doc cho tất cả các hàm công khai
- Mô tả rõ ràng tham số, giá trị trả về và lỗi có thể xảy ra

### 9.3. API Documentation
- Sử dụng OpenAPI/Swagger cho API documentation
- Cập nhật tài liệu khi thay đổi API
- Cung cấp ví dụ cho các endpoint

## 10. Best Practices

### 10.1. Clean Code
- Hàm nên làm một việc duy nhất (Single Responsibility)
- Giữ hàm ngắn gọn (dưới 20 dòng nếu có thể)
- Tránh code trùng lặp (DRY - Don't Repeat Yourself)
- Sử dụng cấu trúc dữ liệu phù hợp

### 10.2. SOLID Principles
- Áp dụng các nguyên lý SOLID khi thiết kế hệ thống
- Tránh phụ thuộc cứng, sử dụng dependency injection
- Mở rộng thay vì sửa đổi (Open/Closed Principle)

### 10.3. Error Handling
- Sử dụng custom error classes để phân biệt các loại lỗi
- Cung cấp thông tin lỗi đầy đủ cho việc debug
- Không tiết lộ thông tin nội bộ hệ thống cho client