# AI Skincare Platform - System Architecture (Rút gọn)

## Tổng quan kiến trúc
AI Skincare Platform được thiết kế theo mô hình microservices với kiến trúc phân tán, đảm bảo khả năng mở rộng, bảo trì và hiệu suất cao. Hệ thống bao gồm các thành phần chính: Client Applications, API Gateway, Microservices, và Data Layer.

## Kiến trúc tổng thể

### 1. Client Layer (Tầng ứng dụng khách)
- **Flutter Mobile App**: Ứng dụng di động chính cho người dùng cuối, hỗ trợ camera integration, AI analysis interface, product recommendation, expert consultation booking
- **React Web Dashboard**: Portal quản lý cho chuyên gia và admin, cung cấp dashboard, analytics, user management, product catalog management

### 2. API Gateway
- **Node.js + Express Gateway**: Single entry point cho tất cả client requests, thực hiện request routing, authentication, rate limiting, logging, load balancing

### 3. Microservices Layer
- **AI Service**: Python + FastAPI, xử lý skin image analysis, machine learning model inference, image preprocessing
- **User Service**: Node.js + TypeScript, quản lý user registration/auth, profile management, analysis history
- **Product Service**: Node.js + TypeScript, quản lý product catalog, inventory, partner integration
- **Expert Service**: Node.js + TypeScript, quản lý expert profiles, consultation scheduling, review system
- **Routine Service**: Node.js + TypeScript, tạo personalized skincare routines dựa trên kết quả phân tích AI
- **Recommendation Service**: Python + FastAPI, ML-based product recommendations với collaborative và content-based filtering

### 4. Data Layer
- **PostgreSQL**: Dữ liệu quan hệ với ACID compliance (users, analyses, consultations, reviews)
- **MongoDB**: Dữ liệu dạng document với schema linh hoạt (products, categories, brands, ingredients)
- **Redis**: Caching hiệu suất cao và session storage
- **Cloud Storage**: Object storage cho hình ảnh và tài nguyên

### 5. Infrastructure & DevOps
- **Google Cloud Platform**: GKE cho container orchestration, Cloud SQL, Cloud Storage, Cloud Memorystore
- **Containerization**: Docker + Kubernetes với auto-scaling, rolling deployments, health checks
- **CI/CD Pipeline**: GitHub Actions với automated testing, security scanning, deployment staging
- **Monitoring**: Prometheus + Grafana, ELK Stack, Jaeger cho distributed tracing

### 6. Security Architecture
- **Multi-layered Security**: Network (VPC, firewall), Application (mTLS, JWT), Data (encryption)
- **Authentication & Authorization**: JWT tokens, refresh tokens, MFA, OAuth integration
- **Data Protection**: AES-256 encryption, GDPR-compliant processing, audit logging

### 7. Performance Optimization
- **Caching Strategy**: Multi-level caching (browser, CDN, API Gateway, Database)
- **Database Optimization**: Indexing, connection pooling, read replicas, query optimization
- **API Performance**: Response compression, pagination, async processing, rate limiting

### 8. Scalability Design
- **Horizontal Scaling**: Independent scaling per service, load balancing, auto-scaling
- **Database Scaling**: MongoDB sharding, PostgreSQL read replicas, Redis cluster
- **Global Distribution**: CDN, multi-region deployment, edge computing

Kiến trúc này được thiết kế để đảm bảo scalability, reliability, security và maintainability cho AI Skincare Platform, có thể xử lý từ MVP đến production scale.