#!/bin/bash
# 更新补丁文件
# 当你修改了 adaptor.go 后，运行此命令重新生成补丁

set -e

echo "📝 更新补丁文件..."

cd "$(dirname "$0")/.."

# 生成补丁
git diff upstream/main -- relay/channel/task/kling/adaptor.go > patches/aiclub-kling.patch

echo "✅ 补丁已更新: patches/aiclub-kling.patch"
echo ""
echo "补丁内容:"
cat patches/aiclub-kling.patch | head -20
echo "..."
