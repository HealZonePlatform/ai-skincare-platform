# GitHub Workflow - Quy trình làm việc với Git

## Tổng quan
Tài liệu này mô tả quy trình làm việc với Git và GitHub cho dự án AI Skincare Platform. Quy trình này giúp đảm bảo chất lượng code, kiểm soát phiên bản hiệu quả và hợp tác nhóm thuận lợi.

## Git Workflow Model
Chúng tôi sử dụng mô hình Git Flow kết hợp với GitHub Flow để phù hợp với mô hình phát triển theo nhóm nhỏ.

## Branch Strategy

### 1. Main Branch
- **Tên nhánh**: `main`
- **Mô tả**: Chứa phiên bản sản phẩm ổn định, đã được kiểm thử hoàn tất
- **Quy tắc**: 
  - Chỉ được merge từ các release branch hoặc hotfix branch
  - Không commit trực tiếp vào nhánh này
  - Luôn đảm bảo code trên nhánh này có thể deploy

### 2. Develop Branch
- **Tên nhánh**: `develop`
- **Mô tả**: Chứa phiên bản phát triển mới nhất, tích hợp các tính năng đang được phát triển
- **Quy tắc**:
  - Là nhánh chính cho phát triển
  - Nhận merge từ các feature branch
 - Code trên nhánh này phải qua kiểm thử đơn vị

### 3. Feature Branches
- **Tên nhánh**: `feature/[tên-tính-năng]`
- **Mô tả**: Dùng để phát triển các tính năng mới
- **Quy tắc**:
  - Tạo từ nhánh `develop`
  - Merge trở lại `develop` sau khi hoàn thành
  - Tên nên mô tả rõ ràng tính năng (ví dụ: `feature/user-authentication`, `feature/skin-analysis-api`)

### 4. Release Branches
- **Tên nhánh**: `release/v[version-number]`
- **Mô tả**: Dùng để chuẩn bị phát hành phiên bản mới
- **Quy tắc**:
  - Tạo từ nhánh `develop`
  - Chỉ chứa sửa lỗi, không thêm tính năng mới
  - Merge vào `main` và `develop` khi hoàn tất

### 5. Hotfix Branches
- **Tên nhánh**: `hotfix/[tên-sửa-lỗi]`
- **Mô tả**: Dùng để sửa lỗi khẩn cấp trên sản phẩm
- **Quy tắc**:
 - Tạo từ nhánh `main`
  - Merge vào cả `main` và `develop`
  - Phải được kiểm thử kỹ lưỡng trước khi merge

## Quy trình làm việc chi tiết

### 1. Bắt đầu một tính năng mới
1. Cập nhật nhánh `develop`: `git checkout develop && git pull origin develop`
2. Tạo nhánh feature mới: `git checkout -b feature/[tên-tính-năng]`
3. Phát triển và commit thay đổi: `git add . && git commit -m "Mô tả thay đổi"`
4. Push nhánh lên remote: `git push origin feature/[tên-tính-năng]`

### 2. Tạo Pull Request (PR)
1. Truy cập GitHub và tạo PR từ nhánh feature đến nhánh develop
2. Mô tả chi tiết thay đổi trong PR
3. Gán người review và labels phù hợp
4. Đảm bảo các CI checks đều pass

### 3. Code Review
1. Người review kiểm tra code, logic, và tuân thủ tiêu chuẩn
2. Đưa ra góp ý nếu cần thiết
3. Phê duyệt PR nếu không có vấn đề
4. Tác giả cập nhật code theo góp ý (nếu có)

### 4. Merge Pull Request
1. Sau khi được phê duyệt, người có quyền merge sẽ thực hiện merge
2. Sử dụng "Squash and merge" để giữ lịch sử gọn gàng (nếu cần)
3. Xóa nhánh feature sau khi merge

### 5. Tạo Release
1. Tạo release branch từ develop: `git checkout -b release/v[version]`
2. Kiểm thử toàn diện và sửa lỗi nếu cần
3. Cập nhật version trong các file cấu hình
4. Tạo PR từ release vào main và develop
5. Sau khi merge, tạo GitHub Release với tag tương ứng

## Commit Message Convention

### Quy tắc đặt tên commit
- Sử dụng thì hiện tại, ví dụ: "Add feature" chứ không phải "Added feature"
- Viết hoa chữ cái đầu tiên
- Không chấm câu ở cuối dòng
- Giới hạn 50 ký tự cho dòng tiêu đề

### Tiền tố commit
- `feat`: Thêm tính năng mới
- `fix`: Sửa lỗi
- `docs`: Thay đổi tài liệu
- `style`: Thay đổi định dạng, không ảnh hưởng logic
- `refactor`: Thay đổi code không sửa lỗi hay thêm tính năng
- `test`: Thêm hoặc sửa test
- `chore`: Cập nhật build tasks, config, v.v.

### Ví dụ commit message
```
feat: Add user authentication service

- Implement JWT token generation
- Add login and registration endpoints
- Integrate with database models
```

## Pull Request Convention

### Tiêu đề PR
- Ngắn gọn, mô tả rõ mục đích
- Sử dụng cùng tiền tố như commit convention

### Mô tả PR
- Liệt kê các thay đổi chính
- Mô tả lý do thực hiện thay đổi
- Ghi rõ các vấn đề được giải quyết (liên kết issue nếu có)
- Hướng dẫn kiểm thử (nếu cần)

## Code Review Guidelines

### Người tạo PR cần đảm bảo
- Code đã được test đầy đủ
- Đã tuân thủ coding standards
- Đã kiểm tra không có hard-coded values
- Đã cập nhật tài liệu nếu cần

### Người review cần kiểm tra
- Logic có đúng không?
- Có vấn đề bảo mật nào không?
- Có tuân thủ tiêu chuẩn code không?
- Hiệu suất có bị ảnh hưởng không?
- Có cần thêm test không?

## Issue Management
- Tạo issue cho mỗi tính năng/lỗi cần xử lý
- Gán labels phù hợp (bug, feature, enhancement, v.v.)
- Gán assignee và milestone
- Liên kết issue với PR tương ứng

## Continuous Integration
- Tất cả các PR phải vượt qua các bước kiểm tra CI
- Bao gồm: linting, unit tests, security scans
- Không được merge PR nếu CI failed

## Best Practices
- Giữ các PR nhỏ và tập trung vào một mục tiêu cụ thể
- Cập nhật nhánh feature từ develop thường xuyên để tránh xung đột
- Viết test cho các thay đổi logic kinh doanh
- Sử dụng rebase cục bộ để giữ lịch sử commit sạch sẽ trước khi tạo PR