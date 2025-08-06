import os

base_path = "services/auth-service"

folders = [
    "src/config",
    "src/controllers",
    "src/services",
    "src/routes",
    "src/middlewares",
    "src/models",
    "src/interfaces",
    "src/utils",
    "src/validators",
    "src/types",
]

files = {
    "src/config/database.ts": "// Cấu hình kết nối database\n",
    "src/config/redis.ts": "// Cấu hình Redis\n",

    "src/controllers/auth.controller.ts": "// Xử lý request login/register\n",
    "src/services/auth.service.ts": "// Logic xử lý xác thực\n",

    "src/routes/auth.routes.ts": "// Định nghĩa router cho auth\n",

    "src/middlewares/auth.middleware.ts": "// Middleware xác thực token\n",
    "src/middlewares/validation.middleware.ts": "// Middleware validate dữ liệu\n",
    "src/middlewares/error.middleware.ts": "// Middleware xử lý lỗi toàn cục\n",

    "src/models/user.model.ts": "// Định nghĩa schema user\n",

    "src/interfaces/auth.interface.ts": "// Interface cho auth\n",
    "src/interfaces/user.interface.ts": "// Interface cho user\n",

    "src/utils/jwt.util.ts": "// Hàm tạo và xác minh JWT\n",
    "src/utils/password.util.ts": "// Mã hóa và so sánh mật khẩu\n",
    "src/utils/response.util.ts": "// Format response\n",

    "src/validators/auth.validator.ts": "// Validate dữ liệu đăng ký, đăng nhập\n",

    "src/types/index.ts": "// Các custom type dùng toàn app\n",

    "src/app.ts": "// Tạo app express\n",
    "src/server.ts": "// Khởi chạy server\n",

    ".env.example": "PORT=3000\nJWT_SECRET=your_jwt_secret\nMONGO_URI=mongodb://localhost:27017/yourdb\n",
    ".gitignore": "node_modules/\ndist/\n.env\n",
    "package.json": '{\n  "name": "auth-service",\n  "main": "dist/server.js"\n}\n',
    "tsconfig.json": '{\n  "compilerOptions": {\n    "target": "ES6",\n    "module": "commonjs",\n    "outDir": "dist",\n    "strict": true,\n    "esModuleInterop": true\n  }\n}\n',
    "README.md": "# Auth Service\n\nDịch vụ xác thực người dùng cho hệ thống AI Skincare Platform.\n",
}

# Tạo thư mục
for folder in folders:
    os.makedirs(os.path.join(base_path, folder), exist_ok=True)

# Tạo file
for path, content in files.items():
    full_path = os.path.join(base_path, path)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content)

print("✅ Auth-service đã được nâng cấp với cấu trúc chuẩn.")
