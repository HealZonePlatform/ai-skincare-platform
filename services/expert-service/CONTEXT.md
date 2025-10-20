Context - Expert Service (Node.js/TypeScript + MongoDB)

- Mục đích
  - Quản lý chuyên gia, đặt lịch tư vấn, đánh giá/nhận xét, xác minh chuyên gia, tích hợp lịch/video.

- Trạng thái hiện tại
  - ĐÃ IMPLEMENT XONG:
    - Mô hình `Mongoose` chi tiết tại `services/expert-service/src/models/expert.model.ts`.
    - Server Express tại `services/expert-service/src/app.ts` và `services/expert-service/src/server.ts`.
    - Kết nối MongoDB được thiết lập tại `services/expert-service/src/config/database.ts`.
    - Controller xử lý nghiệp vụ tại `services/expert-service/src/controllers/expert.controller.ts`.
    - Route API tại `services/expert-service/src/routes/expert.routes.ts`.
    - Service xử lý logic nghiệp vụ tại `services/expert-service/src/services/expert.service.ts`.

- Mô hình dữ liệu nổi bật
  - Chuyên gia gồm: `specialties`, `languages`, `consultationOptions`, `availability`, `rating`, `certifications`, `education`, `reviews`.
  - Index nâng hiệu năng: text index, location (2dsphere), rating.
  - Tính năng: tạo slug tự động, tính toán đánh giá trung bình.

- Phụ thuộc
  - MongoDB (Atlas hoặc self-host), biến môi trường kết nối `MONGODB_URI`.

- API đã implement
  - `GET /experts` (filter/sort/paginate), `GET /experts/:id`, `GET /specialties`, `POST/PUT /experts` (admin), `GET/POST/DELETE /experts/:id/reviews`.

- Ghi chú
  - Service đã hoàn chỉnh phần CRUD chuyên gia và các chức năng đánh giá, lọc tìm kiếm nâng cao.

