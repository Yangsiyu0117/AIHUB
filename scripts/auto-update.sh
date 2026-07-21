#!/bin/bash
# 自动更新脚本 - 合并上游版本并应用补丁
# 用法: ./scripts/auto-update.sh [版本号]

set -e

VERSION=${1:-""}
PATCH_DIR="$(dirname "$0")/../patches"

echo "🔄 自动更新 new-api..."

# 1. 确保在 main 分支
git checkout main

# 2. 拉取上游
echo "📥 拉取 upstream..."
git fetch upstream

# 3. 显示可用版本
echo ""
echo "📋 最新上游标签:"
git tag -l "v1.0.0*" | sort -V | tail -5
echo ""

if [ -z "$VERSION" ]; then
    echo "请输入要合并的版本号（如 v1.0.0-rc.22）:"
    read VERSION
fi

# 4. 合并上游版本
echo "🔀 合并 ${VERSION}..."
git merge ${VERSION} --no-edit

# 5. 检查是否有冲突
if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  存在冲突，请手动解决"
    exit 1
fi

# 6. 应用补丁
echo ""
echo "🔧 应用 AIClub 补丁..."
if [ -f "${PATCH_DIR}/aiclub-kling.patch" ]; then
    git apply ${PATCH_DIR}/aiclub-kling.patch
    echo "✅ 补丁应用成功"
else
    echo "⚠️  未找到补丁文件，跳过"
fi

# 7. 提交补丁
git add relay/channel/task/kling/adaptor.go
git commit -m "feat: 应用 AIClub Kling 补丁" --no-verify

# 8. 构建测试
echo ""
echo "🔨 构建测试..."
docker build -t new-api:test . 2>&1 | tail -5

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 更新完成！"
    echo ""
    echo "📋 当前状态:"
    git log --oneline -3
    echo ""
    echo "👉 下一步:"
    echo "  1. 测试新版本"
    echo "  2. 推送: git push origin main --force"
    echo "  3. 构建生产镜像: ./scripts/build.sh"
else
    echo ""
    echo "❌ 构建失败，请检查补丁兼容性"
    exit 1
fi
