Context - Product Service (Node.js/TypeScript + MongoDB)

- Mục đích
  - Quản lý danh mục sản phẩm, tra cứu/lọc theo loại da, mối quan tâm (concerns), xếp hạng/đánh giá, tồn kho.

- Trạng thái hiện tại
  - ĐÃ IMPLEMENT XONG:
    - Mô hình `Mongoose` chi tiết tại `services/product-service/src/models/product.model.ts`.
    - Server Express tại `services/product-service/src/app.ts` và `services/product-service/src/server.ts`.
    - Kết nối MongoDB được thiết lập tại `services/product-service/src/config/database.ts`.
    - Controller xử lý nghiệp vụ tại `services/product-service/src/controllers/product.controller.ts`.
    - Route API tại `services/product-service/src/routes/product.routes.ts`.
    - Service xử lý logic nghiệp vụ tại `services/product-service/src/services/product.service.ts`.

- Mô hình dữ liệu nổi bật
  - Sản phẩm gồm: `ingredients`, `price`, `ratings`, `availability`, `usage`, `specifications`.
  - Index nâng hiệu năng: text index, category, skinTypes, skinConcerns, price, ratings, flags.
  - Virtuals: `effectivePrice`, `stockStatus`.
  - Statics/methods: tìm theo skinType/concerns, kiểm tra phù hợp.

- Phụ thuộc
  - MongoDB (Atlas hoặc self-host), biến môi trường kết nối `MONGODB_URI`.

- API đã implement
  - `GET /products` (filter/sort/paginate), `GET /products/:id`, `GET /categories`, `POST/PUT /products` (admin), review chuyên gia.

- Ghi chú
  - Service đã hoàn chỉnh phần CRUD sản phẩm và các chức năng lọc, tìm kiếm nâng cao theo nhiều tiêu chí.

