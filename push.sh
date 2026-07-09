#!/bin/bash

# --- GHI CHÚ CÁCH DÙNG ---
# 1. Để dùng, gõ: ./push.sh "nội dung commit"
# 2. Nếu chưa chạy được, gõ: chmod +x push.sh
# -------------------------

# Kiểm tra xem có truyền vào thông điệp commit không
if [ -z "$1" ]; then
    echo "Lỗi: Bạn chưa nhập thông điệp commit."
    echo "Cách dùng: ./push.sh \"thông điệp của bạn\""
    # Dừng chương trình nếu không có thông điệp
    exit 1
fi

# Quy trình đẩy code lên GitHub
echo "Đang chuẩn bị đẩy code lên GitHub..."

# 1. Thêm toàn bộ các file đã chỉnh sửa
git add .

# 2. Cam kết (commit) thay đổi với thông điệp bạn vừa nhập
git commit -m "$1"

# 3. Đẩy code lên nhánh main của GitHub
git push -u origin main

echo "Đã đẩy code lên GitHub thành công!"