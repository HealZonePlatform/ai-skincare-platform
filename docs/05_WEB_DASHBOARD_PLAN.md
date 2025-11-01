# Kế hoạch phát triển Web Dashboard - Dự án AI Skincare Platform

## Tổng quan
Web Dashboard là một phần quan trọng trong hệ sinh thái AI Skincare Platform, cung cấp giao diện quản trị cho các bên liên quan: đối tác kinh doanh (Partner), chuyên gia thẩm định (Expert) và quản trị viên hệ thống (Admin). Đây là một hệ thống riêng biệt với ứng dụng người dùng cuối (mobile app và landing page).

## Trạng thái hiện tại
- Thư mục: `frontend/web-dashboard/`
- Trạng thái: Chỉ có cấu trúc cơ bản (package.json, Dockerfile, README.md, CONTEXT.md)
- Thư mục `src/` đang trống
- Chưa có mã nguồn UI nào được triển khai

## Mục tiêu chính
Cung cấp một nền tảng web quản trị với các vai trò khác nhau để:
- Quản lý sản phẩm mỹ phẩm trên nền tảng
- Duyệt và đánh giá sản phẩm
- Quản lý người dùng trong hệ thống dashboard (Partner, Expert, Admin)
- Theo dõi hiệu suất và hoạt động hệ thống

## Các vai trò người dùng trong Dashboard

### 1. Partner (Đối tác kinh doanh)
Quản lý sản phẩm mỹ phẩm trên nền tảng với các chức năng:
- Xem tổng quan về sản phẩm (tổng số, đã duyệt, chờ duyệt, bị từ chối)
- Quản lý danh sách sản phẩm với filter, search, sort
- Thêm sản phẩm mới (tên, thương hiệu, hình ảnh, thành phần INCI, tài liệu chứng nhận)
- Xem thống kê hiệu suất (lượt xem, CTR, rating)
- Nhận thông báo và tin nhắn từ hệ thống

### 2. Expert (Chuyên gia thẩm định)
Duyệt và đánh giá sản phẩm với quy trình:
- Xem hàng đợi sản phẩm cần duyệt (có độ ưu tiên dựa trên AI)
- Xem chi tiết sản phẩm (thông tin, thành phần, tài liệu)
- Gửi đề xuất duyệt/từ chối kèm lý do cho Admin
- Xem lịch sử các đề xuất đã gửi và phản hồi từ Admin
- Truy cập cơ sở dữ liệu thành phần và tài liệu hướng dẫn

### 3. Admin (Quản trị viên)
Quản lý toàn bộ hệ thống:
- Xác nhận cuối cùng các đề xuất từ Expert (phê duyệt/từ chối)
- Quản lý người dùng (Partner, Expert, Admin)
- Quản lý sản phẩm toàn hệ thống
- Xem phân tích và thống kê tổng quan
- Cài đặt nền tảng và quy tắc duyệt

## Phân biệt với hệ thống người dùng hiện tại
Quan trọng: Web Dashboard là một hệ thống riêng biệt với:
- Ứng dụng di động (mobile_app): Dành cho người dùng cuối sử dụng dịch vụ phân tích da
- Trang landing page (deploy): Dành cho người dùng cuối tìm hiểu và truy cập dịch vụ
- API `/me`: Dành cho người dùng cuối, không liên quan đến dashboard quản trị

## Hiện trạng API hiện tại (liên quan đến dashboard)

### Auth Service
- `POST /api/v1/auth/register` - Đăng ký người dùng (chỉ cho các vai trò dashboard)
- `POST /api/v1/auth/login` - Đăng nhập dashboard
- `POST /api/v1/auth/refresh` - Làm mới token
- `POST /api/v1/auth/logout` - Đăng xuất
- `GET /api/v1/auth/profile` - Lấy thông tin hồ sơ người dùng dashboard
- `GET /api/v1/auth/verify-token` - Xác minh token
- `GET /api/v1/auth/token-info` - Lấy thông tin token

### Product Service (liên quan đến dashboard)
- `GET /api/v1/products` - Lấy danh sách sản phẩm
- `POST /api/v1/products` - Tạo sản phẩm mới
- `GET /api/v1/products/categories` - Lấy danh mục sản phẩm
- `GET /api/v1/products/:id` - Lấy chi tiết sản phẩm
- `PUT /api/v1/products/:id` - Cập nhật sản phẩm
- `DELETE /api/v1/products/:id` - Xóa sản phẩm

### Expert Service (liên quan đến dashboard)
- `GET /api/v1/experts` - Lấy danh sách chuyên gia
- `POST /api/v1/experts` - Tạo chuyên gia mới
- `GET /api/v1/experts/specialties` - Lấy chuyên môn của chuyên gia
- `GET /api/v1/experts/:id` - Lấy chi tiết chuyên gia
- `PUT /api/v1/experts/:id` - Cập nhật chuyên gia
- `DELETE /api/v1/experts/:id` - Xóa chuyên gia
- `GET /api/v1/experts/:id/reviews` - Lấy đánh giá của chuyên gia
- `POST /api/v1/experts/:id/reviews` - Thêm đánh giá
- `DELETE /api/v1/experts/:id/reviews/:reviewId` - Xóa đánh giá

### AI Service (liên quan đến dashboard - cho việc theo dõi phân tích)
- `GET /api/v1/analysis/:analysis_id` - Lấy chi tiết phân tích (admin)
- `GET /api/v1/analysis` - Lấy danh sách phân tích (admin)
- `GET /api/v1/analysis/trends` - Lấy xu hướng phân tích (admin)

## API cần phát triển cho Web Dashboard

### User Management APIs (cần phát triển)
Hiện tại hệ thống không có API quản lý người dùng dashboard, cần phát triển thêm:
```
GET    /api/v1/users                      // List all users (admin only)
GET    /api/v1/users/:id                  // Get user detail (admin only)
POST   /api/v1/users                      // Create user (admin only)
PUT    /api/v1/users/:id                  // Update user (admin only)
DELETE /api/v1/users/:id                  // Delete user (admin only)
PUT    /api/v1/users/:id/status           // Lock/unlock user (admin only)
PUT    /api/v1/users/:id/role             // Update user role (admin only)
```

### Product Management APIs (cần mở rộng)
Hiện tại có các API cơ bản, cần mở rộng cho quản trị:
```
PUT    /api/v1/products/:id/status        // Update product status (admin/expert only)
GET    /api/v1/products/pending           // List products pending review (expert/admin only)
GET    /api/v1/products/stats             // Product analytics (partner/admin only)
POST   /api/v1/products/:id/review        // Submit review for product (expert only)
GET    /api/v1/products/:id/analytics     // Product analytics detail (partner/admin only)
```

### Expert Review APIs (cần phát triển)
```
GET    /api/v1/reviews/queue              // Get review queue (expert only)
POST   /api/v1/reviews                    // Submit expert review (expert only)
GET    /api/v1/reviews                    // List reviews (admin only)
GET    /api/v1/reviews/:id                // Get review detail (admin/expert only)
PUT    /api/v1/reviews/:id/status         // Update review status (admin only)
```

### Admin APIs (cần phát triển)
```
GET    /api/v1/admin/analytics/overview   // System overview analytics (admin only)
GET    /api/v1/admin/analytics/users      // User analytics (admin only)
GET    /api/v1/admin/analytics/products   // Product analytics (admin only)
GET    /api/v1/admin/analytics/analysis   // Analysis analytics (admin only)
GET    /api/v1/admin/settings             // Platform settings (admin only)
PUT    /api/v1/admin/settings             // Update settings (admin only)
GET    /api/v1/admin/activities           // Activity logs (admin only)
GET    /api/v1/admin/users/roles          // Get users by role (admin only)
```

## Data Models dự kiến

### Product Model (dựa trên cấu trúc hiện tại và mở rộng)
```typescript
interface Product {
  id: string;
  partnerId: string;
  name: string;
  brand: string;
  images: string[];
  ingredients: string[];  // INCI list
  primaryUse?: string;
  purchaseLink: string;
  documents: {
    type: 'registration' | 'coa' | 'other';
    url: string;
    required: boolean;
  }[];
  status: 'pending_review' | 'pending_approval' | 'approved' | 'rejected';
  expertReview?: {
    expertId: string;
    recommendation: 'approve' | 'reject';
    notes: string;
    submittedAt: Date;
  };
  adminDecision?: {
    adminId: string;
    decision: 'approved' | 'rejected';
    overridden: boolean;
    notes?: string;
    decidedAt: Date;
  };
  analytics?: {
    views: number;
    clicks: number;
    ctr: number;
    rating: number;
  };
  createdAt: Date;
 updatedAt: Date;
}
```

### User Model (dành riêng cho dashboard)
```typescript
interface User {
  id: string;
  email: string;
  role: 'partner' | 'expert' | 'admin';
  profile: {
    name: string;
    avatar?: string;
    companyName?: string;  // For partners
    specialization?: string;  // For experts
  };
 status: 'active' | 'locked';
  lastActiveAt: Date;
  createdAt: Date;
}
```

### Review Model (dự kiến)
```typescript
interface Review {
  id: string;
  productId: string;
  expertId: string;
  recommendation: 'approve' | 'reject';
  complexity: 'low' | 'medium' | 'high';  // AI-generated
  notes: string;
  adminStatus: 'pending' | 'confirmed' | 'overridden';
  adminNotes?: string;
  submittedAt: Date;
  reviewedAt?: Date;
}
```

## Kiến trúc đề xuất

### Tech Stack
- Framework: Next.js 14 (App Router) hoặc React với TypeScript
- UI Library: Tailwind CSS + shadcn/ui hoặc Material UI
- State Management: Zustand hoặc React Query
- Charts: Chart.js hoặc Recharts
- Forms: React Hook Form + Zod validation
- API Client: Axios với interceptors

### Cấu trúc thư mục dự kiến
```
frontend/web-dashboard/
├── src/
│   ├── app/                        # Next.js App Router
│   │   ├── (auth)/                # Auth group (login, register)
│   │   │   ├── login/
│   │   │   └── layout.tsx
│   │   ├── (partner)/             # Partner dashboard
│   │   │   ├── dashboard/
│   │   │   ├── products/
│   │   │   ├── add-product/
│   │   │   ├── insights/
│   │   ├── messages/
│   │   │   └── layout.tsx
│   │   ├── (expert)/              # Expert dashboard
│   │   │   ├── dashboard/
│   │   │   ├── queue/
│   │   │   ├── review/[id]/
│   │   │   ├── history/
│   │   │   └── layout.tsx
│   │   ├── (admin)/               # Admin dashboard
│   │   │   ├── dashboard/
│   │   │   ├── users/
│   │   │   ├── products/
│   │   │   ├── analytics/
│   │   │   ├── approval-queue/
│   │   │   ├── settings/
│   │   │   └── layout.tsx
│   │   ├── api/                   # API routes (nếu cần)
│   │   └── layout.tsx
│   ├── components/                # React components
│   │   ├── ui/                    # shadcn/ui components
│   │   ├── layouts/
│   │   │   ├── Sidebar.tsx
│   │   │   ├── Header.tsx
│   │   │   └── DashboardLayout.tsx
│   │   ├── partner/
│   │   │   ├── ProductTable.tsx
│   │   │   ├── ProductForm.tsx
│   │   │   ├── StatsCard.tsx
│   │   │   └── PerformanceChart.tsx
│   │   ├── expert/
│   │   │   ├── QueueTable.tsx
│   │   │   ├── ReviewForm.tsx
│   │   │   └── ProductDetail.tsx
│   │   ├── admin/
│   │   │   ├── UserTable.tsx
│   │   │   ├── ApprovalQueue.tsx
│   │   │   └── SystemAnalytics.tsx
│   │   └── shared/
│   │       ├── DataTable.tsx
│   │       ├── FileUpload.tsx
│   │       ├── SearchBar.tsx
│   │       └── Pagination.tsx
│   ├── lib/                       # Utilities
│   │   ├── api/
│   │   ├── client.ts         # Axios instance
│   │   │   ├── auth.ts
│   │   │   ├── products.ts
│   │   │   ├── users.ts
│   │   │   └── reviews.ts
│   │   ├── hooks/
│   │   │   ├── useAuth.ts
│   │   │   ├── useProducts.ts
│   │   │   └── useReviews.ts
│   │   ├── store/
│   │   ├── authStore.ts
│   │   │   └── uiStore.ts
│   │   └── utils/
│   │       ├── validators.ts
│   │       ├── formatters.ts
│   │       └── constants.ts
│   ├── types/                     # TypeScript types
│   │   ├── auth.ts
│   │   ├── product.ts
│   │   ├── user.ts
│   │   └── review.ts
│   └── middleware.ts              # Auth middleware
├── public/
├── .env.local
├── next.config.js
├── tailwind.config.ts
└── tsconfig.json
```

## Workflow Duyệt Sản phẩm (cần phát triển backend)
```
Partner tạo sản phẩm
 ↓
Status: pending_review
 ↓
Vào hàng đợi Expert
 ↓
Expert review
  ↓
- Đề xuất Approve → Status: pending_approval
- Đề xuất Reject → Status: pending_approval
 ↓
Admin xác nhận
 ↓
- Confirm Approve → Status: approved → Hiển thị trên platform
- Confirm Reject → Status: rejected → Thông báo Partner
- Override → Status: approved/rejected → Kết quả tùy theo quyết định
```

## Implementation Roadmap

### Phase 1: Backend API Development (Tuần 1-3)
- Phát triển API quản lý người dùng dashboard (admin only)
- Mở rộng API sản phẩm với chức năng quản trị
- Phát triển API duyệt sản phẩm và quản lý hàng đợi
- Phát triển API analytics và thống kê

### Phase 2: Core Frontend Setup (Tuần 4-5)
- Setup Next.js project với TypeScript
- Cấu hình Tailwind CSS + shadcn/ui
- Setup routing và layout cho 3 vai trò
- Implement authentication flow
- Create shared components (Sidebar, Header, DataTable)

### Phase 3: Partner Dashboard (Tuần 6-7)
- Dashboard overview page
- Product listing với filter/search/pagination
- Add product form với validation
- Image và document upload
- Analytics/insights page

### Phase 4: Expert Dashboard (Tuần 8)
- Review queue page
- Product review detail page
- Review submission form
- History page với filter

### Phase 5: Admin Dashboard (Tuần 9-10)
- User management CRUD
- Product management view
- Approval queue
- System analytics
- Settings page

### Phase 6: Integration & Testing (Tuần 11-12)
- Connect với backend APIs
- End-to-end testing
- Performance optimization
- Security hardening

## Ghi chú quan trọng
- Web Dashboard là hệ thống riêng biệt với ứng dụng người dùng cuối
- Chỉ bao gồm 3 vai trò: Partner, Expert, Admin (không có người dùng cuối)
- Nhiều API cần được phát triển thêm để hỗ trợ đầy đủ chức năng dashboard
- Cần tích hợp với hệ thống API Gateway và các microservices hiện có
- Bảo mật và phân quyền là yếu tố quan trọng cần được thiết kế từ đầu
- Hiện tại, các service chỉ hỗ trợ các chức năng cơ bản, cần phát triển thêm nhiều endpoint để hỗ trợ quản trị