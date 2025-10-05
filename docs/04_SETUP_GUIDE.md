# Setup Guide - Hướng dẫn cài đặt môi trường

## Tổng quan
Tài liệu này hướng dẫn chi tiết cách thiết lập môi trường phát triển cho dự án AI Skincare Platform. Hướng dẫn bao gồm cài đặt các công cụ cần thiết, cấu hình hệ thống và chạy các thành phần của ứng dụng.

## Yêu cầu hệ thống

### Hệ điều hành
- Windows 10/11, macOS 10.15+, hoặc Linux (Ubuntu 20.04+ được khuyến nghị)
- Bộ nhớ RAM tối thiểu: 8GB (16GB được khuyến nghị)
- Ổ cứng trống tối thiểu: 10GB

### Công cụ phát triển
- Git (>= 2.30.0)
- Node.js (>= 18.0.0)
- npm (>= 8.0.0) hoặc yarn (>= 1.22.0)
- Docker (>= 20.10.0)
- Docker Compose (>= 2.0.0)
- Flutter SDK (>= 3.0.0)
- Python (>= 3.9.0)
- pip (>= 21.0.0)

## Cài đặt công cụ phát triển

### 1. Git
1. Tải và cài đặt Git từ trang chủ: https://git-scm.com/
2. Cấu hình Git với thông tin cá nhân:
   ```
   git config --global user.name "Tên của bạn"
   git config --global user.email "email@domain.com"
   ```

### 2. Node.js và npm
1. Tải và cài đặt Node.js từ trang chủ: https://nodejs.org/
2. Kiểm tra phiên bản:
   ```
   node --version
   npm --version
   ```

### 3. Docker và Docker Compose
1. Cài đặt Docker Desktop theo hướng dẫn cho hệ điều hành của bạn:
   - Windows: https://docs.docker.com/desktop/install/windows-install/
   - macOS: https://docs.docker.com/desktop/install/mac-install/
   - Ubuntu: https://docs.docker.com/desktop/install/ubuntu/
2. Kiểm tra cài đặt:
   ```
   docker --version
   docker-compose --version
   ```

### 4. Flutter SDK
1. Tải Flutter SDK từ trang chủ: https://flutter.dev/
2. Giải nén và thêm đường dẫn Flutter vào biến môi trường PATH
3. Chạy lệnh để kiểm tra:
   ```
   flutter doctor
   ```
4. Cài đặt các công cụ cần thiết theo hướng dẫn của flutter doctor

### 5. Python
1. Tải và cài đặt Python 3.9 trở lên từ trang chủ: https://www.python.org/
2. Kiểm tra phiên bản:
   ```
   python --version
   pip --version
   ```

## Cài đặt dự án

### 1. Clone repository
```
git clone <repository-url>
cd ai-skincare-platform
```

### 2. Cấu hình môi trường
1. Copy file mẫu môi trường:
   ```
   cp .env.example .env
   ```
2. Chỉnh sửa file `.env` với các giá trị phù hợp cho môi trường phát triển

### 3. Cài đặt dependencies cho các service

#### Auth Service
```
cd services/auth-service
npm install
```

#### API Gateway
```
cd services/api-gateway
npm install
```

#### Expert Service
```
cd services/expert-service
npm install
```

#### Product Service
```
cd services/product-service
npm install
```

#### User Service
```
cd services/user-service
npm install
```

#### AI Service
```
cd services/ai-service
pip install -r requirements.txt
```

#### Recommendation Service
```
cd services/recommendation-service
pip install -r requirements.txt
```

#### Mobile App
```
cd frontend/mobile-app
flutter pub get
```

#### Web Dashboard
```
cd frontend/web-dashboard
npm install
```

## Cấu hình database

### 1. PostgreSQL
1. Đảm bảo PostgreSQL đã được cài đặt hoặc sử dụng Docker
2. Chạy script khởi tạo database:
   ```
   psql -U postgres -d ai_skincare_dev -f database/init.sql
   ```

### 2. MongoDB
1. Đảm bảo MongoDB đã được cài đặt hoặc sử dụng Docker
2. Cấu hình kết nối trong file `.env`

### 3. Redis
1. Đảm bảo Redis đã được cài đặt hoặc sử dụng Docker
2. Cấu hình kết nối trong file `.env`

## Chạy ứng dụng

### 1. Sử dụng Docker Compose (khuyến nghị)
```
docker-compose up --build
```

### 2. Chạy từng service riêng lẻ

#### Database và Redis
```
docker-compose up postgres redis mongo
```

#### Auth Service
```
cd services/auth-service
npm run dev
```

#### API Gateway
```
cd services/api-gateway
npm run dev
```

#### Expert Service
```
cd services/expert-service
npm run dev
```

#### Product Service
```
cd services/product-service
npm run dev
```

#### User Service
```
cd services/user-service
npm run dev
```

#### AI Service
```
cd services/ai-service
python app/main.py
```

#### Recommendation Service
```
cd services/recommendation-service
python app/main.py
```

#### Web Dashboard
```
cd frontend/web-dashboard
npm start
```

## Cấu hình Flutter Mobile App

### 1. Cấu hình API endpoint
1. Mở file `frontend/mobile-app/lib/utils/api_constants.dart`
2. Cập nhật các endpoint URL để trỏ đến API Gateway đang chạy

### 2. Chạy ứng dụng
```
cd frontend/mobile-app
flutter run
```

## Cấu hình môi trường phát triển

### 1. IDE Recommendations
- Visual Studio Code với các extension:
  - Dart và Flutter
  - Pylance cho Python
  - TypeScript và JavaScript
  - Docker
  - GitLens

### 2. Cấu hình ESLint và Prettier
1. Cài đặt các extension ESLint và Prettier trong IDE
2. Sử dụng cấu hình chuẩn trong project:
   - `.eslintrc.js`
   - `.prettierrc`
   - `pyproject.toml` (cho Python)

### 3. Cấu hình môi trường
Tạo file `.env.local` để ghi đè các biến môi trường cho môi trường phát triển cá nhân.

## Các lệnh hữu ích

### 1. Docker
- Xem trạng thái container: `docker-compose ps`
- Dừng tất cả services: `docker-compose down`
- Xem logs: `docker-compose logs <service-name>`
- Vào container: `docker exec -it <container-name> bash`

### 2. Database
- Backup PostgreSQL: `pg_dump -U postgres ai_skincare_dev > backup.sql`
- Restore PostgreSQL: `psql -U postgres ai_skincare_dev < backup.sql`

### 3. Testing
- Chạy test cho auth service: `cd services/auth-service && npm test`
- Chạy test cho web dashboard: `cd frontend/web-dashboard && npm test`
- Chạy test cho mobile app: `cd frontend/mobile-app && flutter test`

## Khắc phục sự cố

### 1. Port đã được sử dụng
- Kiểm tra các tiến trình đang sử dụng port: `lsof -i :<port-number>`
- Dừng tiến trình nếu cần: `kill -9 <process-id>`

### 2. Lỗi liên quan đến quyền truy cập
- Trên Linux/macOS, có thể cần chạy Docker với quyền sudo
- Kiểm tra quyền truy cập thư mục project

### 3. Lỗi liên quan đến network
- Reset Docker network: `docker network prune`
- Kiểm tra kết nối giữa các container

### 4. Lỗi Flutter
- Chạy `flutter clean` để xóa cache
- Chạy `flutter pub get` để tải lại dependencies
- Kiểm tra kết nối mạng nếu sử dụng emulator

## Môi trường staging và production

### 1. Cấu hình cho staging
- Tạo file `.env.staging` với các cấu hình staging
- Sử dụng Docker Compose override: `docker-compose -f docker-compose.yml -f docker-compose.staging.yml up`

### 2. Cấu hình cho production
- Tạo file `.env.prod` với các cấu hình production
- Sử dụng Docker Compose override: `docker-compose -f docker-compose.yml -f docker-compose.prod.yml up`

## Triển khai cơ bản

### 1. Build Docker images
```
docker-compose build
```

### 2. Chạy trong chế độ detached
```
docker-compose up -d
```

### 3. Kiểm tra trạng thái
```
docker-compose ps