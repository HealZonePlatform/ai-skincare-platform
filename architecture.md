# AI Skincare Platform - System Architecture

## Tổng quan kiến trúc

AI Skincare Platform được thiết kế theo mô hình microservices với kiến trúc phân tán, đảm bảo khả năng mở rộng, bảo trì và hiệu suất cao. Hệ thống bao gồm các thành phần chính: Client Applications, API Gateway, Microservices, và Data Layer.

## Kiến trúc tổng thể

### 1. Client Layer (Tầng ứng dụng khách)

#### Flutter Mobile App 📱
- **Mục đích**: Ứng dụng di động chính cho người dùng cuối
- **Công nghệ**: Flutter framework (Dart)
- **Tính năng**:
  - Camera integration cho chụp ảnh da
  - AI analysis interface
  - Product recommendation display
  - Expert consultation booking
  - User profile management
  - Offline capability cho basic features

#### React Web Dashboard 💻
- **Mục đích**: Portal quản lý cho chuyên gia và admin
- **Công nghệ**: React với TypeScript
- **Tính năng**:
  - Expert dashboard
  - Admin panel
  - Analytics và reporting
  - User management
  - Product catalog management

### 2. API Gateway 🚪

#### Node.js + Express Gateway
- **Vai trò**: Single entry point cho tất cả client requests
- **Chức năng chính**:
  - Request routing đến appropriate microservices
  - Authentication và authorization
  - Rate limiting và throttling
  - Request/response logging
  - Load balancing
  - API versioning
- **Security Features**:
  - JWT token validation
  - CORS handling
  - Input sanitization
  - Request size limiting

### 3. Microservices Layer

#### AI Service 🤖
- **Technology Stack**: Python + FastAPI
- **Primary Functions**:
  - Skin image analysis sử dụng computer vision
  - Machine learning model inference
  - Image preprocessing và enhancement
  - Result interpretation và scoring
- **Key APIs**:
  - `POST /analyze` - Phân tích hình ảnh da
  - `POST /recommend` - AI-based product recommendations
  - `POST /feedback` - Thu thập user feedback để improve models
- **ML Components**:
  - TensorFlow/PyTorch models
  - OpenCV cho image processing
  - Custom CNN models cho skin analysis
  - Model versioning và A/B testing

#### User Service 👤  
- **Technology Stack**: Node.js + TypeScript
- **Primary Functions**:
  - User registration và authentication
  - Profile management
  - Analysis history tracking
  - Preference management
- **Key APIs**:
  - `POST/GET /users` - User CRUD operations
  - `GET/PUT /profile` - Profile management
  - `GET /history` - Analysis history retrieval
- **Data Management**:
  - PostgreSQL cho user data
  - Redis cho session caching
  - Encrypted sensitive data storage

#### Product Service 🛍️
- **Technology Stack**: Node.js + TypeScript  
- **Primary Functions**:
  - Product catalog management
  - Inventory tracking
  - Partner integration
  - Category và brand management
- **Key APIs**:
  - `GET /products` - Product listing với filtering
  - `GET /categories` - Category hierarchy
  - `POST/PUT /partners` - Partner management
- **Features**:
  - MongoDB cho flexible product schema
  - Search và filtering capabilities
  - Price tracking và comparison
  - Stock level monitoring

#### Expert Service 👨‍⚕️
- **Technology Stack**: Node.js + TypeScript
- **Primary Functions**:
  - Expert profile management
  - Consultation scheduling
  - Review và rating system
  - Communication facilitation
- **Key APIs**:
  - `GET /experts` - Expert directory
  - `POST /consultations` - Booking management
  - `POST/GET /reviews` - Review system
- **Features**:
  - Calendar integration
  - Video consultation support
  - Expert verification system
  - Payment processing integration

#### Routine Service 📅
- **Technology Stack**: Node.js + TypeScript
- **Primary Functions**:
  - Generate personalized morning/night skincare routines.
  - Combine AI analysis results with user preferences.
  - Select appropriate products from the catalog for each step of the routine.
  - Allow users to customize and save their routines.
- **Key APIs**:
  - `POST /routines/generate` - Tạo một lộ trình mới dựa trên kết quả phân tích.
  - `GET /routines/{userId}` - Lấy lộ trình hiện tại của người dùng.
  - `PUT /routines/{routineId}` - Cập nhật/tùy chỉnh một lộ trình.
- **Logic Integration**:
  - Fetches analysis score from **AI Service**.
  - Fetches product data from **Product Service**.
  - Fetches user profile (skin type, allergies) from **User Service**.

#### Recommendation Service 🎯
- **Technology Stack**: Python + FastAPI
- **Primary Functions**:
  - ML-based product recommendations
  - Collaborative filtering
  - Content-based filtering
  - Hybrid recommendation algorithms
- **Key APIs**:
  - `POST /recommend` - Generate recommendations
  - `POST /feedback` - Collect recommendation feedback
- **ML Features**:
  - Graph-based recommendations (Neo4j)
  - Real-time recommendation updates
  - A/B testing cho recommendation algorithms

## 4. Data Layer

### PostgreSQL 🐘
- **Use Cases**: Relational data với ACID compliance
- **Key Tables**:
  - `users` - User account information
  - `user_profiles` - Detailed user profiles
  - `skin_analyses` - Analysis results và metadata
  - `experts` - Expert profiles và credentials
  - `consultations` - Appointment và consultation data
  - `reviews` - User reviews và ratings
- **Features**:
  - JSONB columns cho flexible data
  - Full-text search capabilities
  - Row-level security
  - Automated backups

### MongoDB 🍃
- **Use Cases**: Document-based data với flexible schema
- **Key Collections**:
  - `products` - Product catalog với rich metadata
  - `categories` - Hierarchical category structure
  - `brands` - Brand information và assets
  - `ingredients` - Ingredient database với properties
  - `partners` - Partner business data
  - `inventory` - Stock levels và warehouse data
- **Features**:
  - Aggregation pipeline cho complex queries
  - GridFS cho large files
  - Sharding support cho scalability

### Redis 🔴
- **Use Cases**: High-performance caching và session storage
- **Data Types**:
  - `user_sessions` - Session data với TTL
  - `api_cache` - Cached API responses
  - `rate_limits` - Rate limiting counters
  - `ml_results` - Temporary ML analysis results
  - `product_cache` - Hot product data
- **Features**:
  - Pub/Sub cho real-time notifications
  - Lua scripts cho atomic operations
  - Cluster mode cho high availability

### Cloud Storage ☁️
- **Use Cases**: Object storage cho files và assets
- **Buckets**:
  - `user-images` - User-uploaded skin images
  - `ml-models` - Trained ML model files
  - `product-images` - Product catalog images
  - `static-assets` - Application static files
  - `backups` - Database backup files
- **Features**:
  - CDN integration cho fast delivery
  - Lifecycle management cho cost optimization
  - Versioning cho critical files

## 5. Infrastructure & DevOps

### Google Cloud Platform ☁️
- **Compute**: Google Kubernetes Engine (GKE)
- **Databases**: Cloud SQL (PostgreSQL), MongoDB Atlas
- **Storage**: Google Cloud Storage
- **Caching**: Cloud Memorystore (Redis)
- **Networking**: Cloud Load Balancer, VPC
- **Security**: IAM, Cloud KMS, Security Groups

### Containerization 🐳
- **Docker**: All services containerized
- **Kubernetes**: Container orchestration
- **Features**:
  - Auto-scaling based on load
  - Rolling deployments
  - Health checks và self-healing
  - Service discovery
  - ConfigMaps và Secrets management

### Monitoring & Observability 📊
- **Metrics**: Prometheus + Grafana
- **Logging**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Tracing**: Jaeger cho distributed tracing
- **Alerting**: Prometheus Alertmanager
- **Custom Dashboards**: Performance, business metrics

### CI/CD Pipeline 🔄
- **Source Control**: GitHub
- **CI/CD**: GitHub Actions
- **Stages**:
  1. Code commit → Automated testing
  2. Test pass → Docker image build
  3. Image push → Container registry
  4. Deployment → Staging environment
  5. Manual approval → Production deployment
- **Features**:
  - Automated testing (unit, integration, e2e)
  - Security scanning
  - Performance testing
  - Database migration management

## 6. Security Architecture 🔒

### Multi-layered Security
- **Network Level**: VPC, firewall rules, DDoS protection
- **Application Level**: mTLS, JWT authentication, input validation
- **Data Level**: Encryption at rest và in transit
- **Access Control**: RBAC, principle of least privilege

### Authentication & Authorization
- **JWT Tokens**: Stateless authentication
- **Refresh Tokens**: Secure token renewal
- **Multi-factor Authentication**: Optional 2FA
- **OAuth Integration**: Social login support

### Data Protection
- **Encryption**: AES-256 cho sensitive data
- **PII Handling**: GDPR-compliant data processing
- **Audit Logging**: Comprehensive audit trails
- **Backup Encryption**: Encrypted backup storage

## 7. Performance Optimization

### Caching Strategy
- **Multi-level Caching**: Browser, CDN, API Gateway, Database
- **Cache Invalidation**: Event-driven cache updates
- **Cache Warming**: Proactive cache population

### Database Optimization
- **Indexing Strategy**: Optimized indexes cho common queries
- **Connection Pooling**: Efficient database connections
- **Read Replicas**: Read scaling cho heavy queries
- **Query Optimization**: Regular query performance reviews

### API Performance
- **Response Compression**: Gzip compression
- **Pagination**: Efficient data pagination
- **Async Processing**: Background jobs cho heavy operations
- **Rate Limiting**: Prevent API abuse

## 8. Scalability Design

### Horizontal Scaling
- **Microservices**: Independent scaling per service
- **Load Balancing**: Traffic distribution
- **Auto-scaling**: Kubernetes HPA based on metrics

### Database Scaling
- **Sharding**: MongoDB horizontal partitioning
- **Read Replicas**: PostgreSQL read scaling
- **Caching**: Redis cluster cho distributed caching

### Global Distribution
- **CDN**: Content delivery optimization
- **Multi-region**: Future multi-region deployment
- **Edge Computing**: AI inference tại edge locations

## 9. Disaster Recovery & High Availability

### Backup Strategy
- **Automated Backups**: Daily incremental, weekly full
- **Cross-region Replication**: Geographic redundancy
- **Point-in-time Recovery**: Database restoration capabilities

### High Availability
- **Multi-zone Deployment**: Service distribution across zones
- **Health Checks**: Automated failure detection
- **Failover Mechanisms**: Automatic service recovery
- **Circuit Breakers**: Prevent cascade failures

### Business Continuity
- **Recovery Time Objective (RTO)**: < 4 hours
- **Recovery Point Objective (RPO)**: < 1 hour
- **Disaster Recovery Testing**: Regular DR drills
- **Documentation**: Comprehensive runbooks

## 10. API Design Principles

### RESTful Design
- **Resource-oriented URLs**: Clear resource naming
- **HTTP Methods**: Proper verb usage (GET, POST, PUT, DELETE)
- **Status Codes**: Meaningful HTTP status codes
- **Versioning**: URL-based API versioning (/api/v1/)

### API Standards
- **OpenAPI Specification**: Comprehensive API documentation
- **Consistent Response Format**: Standardized error/success responses
- **Pagination**: Limit/offset và cursor-based pagination
- **Filtering & Sorting**: Query parameter standards

### Error Handling
- **Structured Errors**: Consistent error response format
- **Error Codes**: Application-specific error codes
- **Debugging Information**: Detailed error context cho development
- **User-friendly Messages**: Clear error messages cho end users

Kiến trúc này được thiết kế để đảm bảo scalability, reliability, security và maintainability cho AI Skincare Platform, có thể xử lý từ MVP đến production scale với hàng triệu người dùng.