Context - Recommendation Service (Python)

- Mục đích
  - Gợi ý sản phẩm/chăm sóc dựa trên kết quả phân tích AI, hồ sơ người dùng, lịch sử, và danh mục sản phẩm.

- Trạng thái hiện tại
  - Đã có mã nguồn hoàn chỉnh với cấu trúc: main.py, config.py, schemas.py, services/recommendation.py
  - Đã có Dockerfile và requirements.txt hoàn chỉnh
  - Đã có mô hình gợi ý cơ bản được triển khai

- Hướng tiếp cận đề xuất
  - Rule-based + ML hybrid: kết hợp skin type/concerns với score từ AI, ràng buộc dị ứng/thành phần.
  - Personalization: học từ lịch sử/phản hồi.

- API dự kiến
  - `POST /recommend` đầu vào: userId/analysisId/preferences; đầu ra: danh sách sản phẩm + lý do.

- Tích hợp
  - Kéo dữ liệu từ Product Service (Mongo) và kết quả AI Service.

- TODO/Gợi ý
  - Xây dựng pipeline features, mô hình, A/B testing, feedback loop.
