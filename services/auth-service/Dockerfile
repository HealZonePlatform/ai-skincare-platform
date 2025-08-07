# Filename: services/auth-service/Dockerfile

# ---- Stage 1: Build ----
# Stage này cài đặt tất cả dependencies, tạo ra package-lock.json nếu cần,
# và biên dịch mã nguồn TypeScript thành JavaScript.
FROM node:18-alpine AS builder

WORKDIR /app

# Sao chép file package.json và package-lock.json (nếu có)
COPY package*.json ./

# Chạy 'npm install'. Lệnh này sẽ cài đặt tất cả dependencies (bao gồm dev)
# và quan trọng là sẽ tạo/cập nhật file package-lock.json.
RUN npm install

# Sao chép toàn bộ mã nguồn còn lại của service
COPY . .

# Chạy lệnh build để biên dịch TypeScript
RUN npm run build

# ---- Stage 2: Production ----
# Stage này tạo ra image cuối cùng, chỉ chứa những gì cần thiết để chạy.
FROM node:18-alpine

WORKDIR /app

# Sao chép package.json VÀ package-lock.json đã được tạo/cập nhật từ stage builder.
# Đây là bước quan trọng để đảm bảo stage production có lockfile chính xác.
COPY --from=builder /app/package*.json ./

# Chạy 'npm install --omit=dev'. Lệnh này sẽ đọc package-lock.json
# và chỉ cài đặt các dependencies cần thiết cho production một cách nhất quán.
RUN npm install --omit=dev

# Sao chép thư mục 'dist' đã được biên dịch từ stage 'builder'
COPY --from=builder /app/dist ./dist

# Expose port mà ứng dụng sẽ lắng nghe
EXPOSE 3001

# Lệnh để khởi động ứng dụng
CMD [ "node", "dist/app.js" ]