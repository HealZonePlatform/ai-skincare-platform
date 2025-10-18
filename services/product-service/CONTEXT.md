Context - Product Service (Node.js/TypeScript + MongoDB)

- Mục đích
  - Quản lý danh mục sản phẩm, tra cứu/lọc theo loại da, mối quan tâm (concerns), xếp hạng/đánh giá, tồn kho.

- Trạng thái hiện tại
  - Mô hình `Mongoose` chi tiết tại `services/product-service/src/models/product.model.ts`.
  - Thiếu phần server/controller/route và kết nối MongoDB.

- Mô hình dữ liệu nổi bật
  - Sản phẩm gồm: `ingredients`, `price`, `ratings`, `availability`, `usage`, `specifications`.
  - Index nâng hiệu năng: text index, category, skinTypes, skinConcerns, price, ratings, flags.
  - Virtuals: `effectivePrice`, `stockStatus`.
  - Statics/methods: tìm theo skinType/concerns, kiểm tra phù hợp.

- Phụ thuộc
  - MongoDB (Atlas hoặc self-host), biến môi trường kết nối `MONGODB_URI`.

- API dự kiến
  - `GET /products` (filter/sort/paginate), `GET /products/:id`, `GET /categories`, `POST/PUT /products` (admin), review chuyên gia.

- TODO/Gợi ý
  - Khởi tạo server (Express/Fastify) + kết nối MongoDB.
  - Triển khai controller/route + validation + phân quyền (admin).
  - Đồng bộ với Recommendation Service để xếp hạng/đề xuất.

