#!/bin/bash
# ============================================================
#  git-push.command
#  Double-click file này trên macOS để tự động add -> commit -> push.
#  Lần đầu chạy sẽ hỏi remote URL (GitHub/GitLab...), các lần sau
#  tự nhớ và không hỏi lại.
# ============================================================

# Luôn chạy đúng tại thư mục chứa file này (thư mục project của bạn)
cd "$(dirname "$0")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}==> Thư mục làm việc: $(pwd)${NC}"

# 1) Khởi tạo git nếu chưa có
if [ ! -d ".git" ]; then
  echo -e "${YELLOW}==> Chưa có git, đang git init...${NC}"
  git init
  git branch -M main
fi

# 2) Xác định remote "origin" — nếu chưa có thì hỏi 1 lần, lần sau tự nhớ
if ! git remote get-url origin >/dev/null 2>&1; then
  echo -e "${YELLOW}==> Chưa có remote 'origin'.${NC}"
  read -p "Dán link repo Git (VD: https://github.com/user/repo.git): " REPO_URL
  if [ -z "$REPO_URL" ]; then
    echo -e "${RED}Không có link repo, huỷ.${NC}"
    read -p "Nhấn Enter để đóng cửa sổ..." _
    exit 1
  fi
  git remote add origin "$REPO_URL"
  echo -e "${GREEN}==> Đã lưu remote, các lần sau sẽ không hỏi lại.${NC}"
fi

REMOTE_URL=$(git remote get-url origin)
echo -e "${YELLOW}==> Remote: $REMOTE_URL${NC}"

# 3) Add toàn bộ thay đổi
git add -A

# 4) Commit (nếu không có gì thay đổi thì bỏ qua, không báo lỗi)
if git diff --cached --quiet; then
  echo -e "${YELLOW}==> Không có thay đổi mới để commit.${NC}"
else
  MSG="Update $(date '+%Y-%m-%d %H:%M:%S')"
  git commit -m "$MSG"
  echo -e "${GREEN}==> Đã commit: $MSG${NC}"
fi

# 5) Xác định tên nhánh hiện tại rồi push
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${YELLOW}==> Đang push nhánh '$BRANCH' lên origin...${NC}"

if git push -u origin "$BRANCH"; then
  echo -e "${GREEN}==> XONG! Đã đẩy code lên Git thành công.${NC}"
else
  echo -e "${RED}==> Push thất bại. Kiểm tra lại kết nối mạng / quyền truy cập repo / xung đột (conflict).${NC}"
fi

echo ""
read -p "Nhấn Enter để đóng cửa sổ..." _
