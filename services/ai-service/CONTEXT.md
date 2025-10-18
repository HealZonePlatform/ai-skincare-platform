Context - AI Service (Python/FastAPI)

- Mục đích
  - Phân tích ảnh da bằng mô hình CV/ML, tiền xử lý ảnh, suy luận model, trả điểm/kết quả và gợi ý sơ bộ.

- Trạng thái hiện tại
  - `Dockerfile`, `requirements.txt` placeholder. Chưa có mã nguồn API/model.

- Kiến trúc dự kiến
  - FastAPI: `POST /analyze` nhận ảnh (multipart/base64), tiền xử lý, inference (TensorFlow/PyTorch), trả kết quả JSON.
  - `POST /feedback` để thu thập dữ liệu cải thiện model.

- Môi trường/ML
  - Quản lý model versioning, tải model từ storage (GCS/S3), tối ưu hoá (ONNX/TensorRT nếu cần).

- TODO/Gợi ý
  - Xác định pipeline inference, chuẩn input/output, kiểm thử hiệu năng, log/trace.
  - Bảo mật upload (kích thước/định dạng), hạn chế tốc độ.

