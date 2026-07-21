#!/bin/bash
# 版本更新脚本
# 用于将上游 new-api 的新版本合并到你的 fork
# 用法: ./scripts/update-version.sh [版本号]

set -e

VERSION=${1:-""}

echo "🔄 开始更新 new-api 版本..."

# 确保在 dev 分支
git checkout dev

# 拉取上游最新代码
echo "📥 拉取 upstream 最新代码..."
git fetch upstream

# 显示可用的标签
echo ""
echo "📋 可用的上游标签:"
git tag -l "v1.0.0*" | tail -10
echo ""

if [ -z "$VERSION" ]; then
    echo "请输入要合并的版本号（如 v1.0.0-rc.22）:"
    read VERSION
fi

# 合并指定版本
echo "🔀 合并 ${VERSION}..."
git merge ${VERSION} --no-edit

# 检查冲突
if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  存在冲突，请手动解决后运行: git add . && git commit"
    echo "冲突文件:"
    git diff --name-only --diff-filter=U
    exit 1
fi

echo ""
echo "✅ 版本 ${VERSION} 合并完成！"
echo ""
echo "📋 当前状态:"
git log --oneline -3
echo ""
echo "👉 下一步:"
echo "  1. 测试新版本"
echo "  2. 推送到 origin: git push origin dev"
echo "  3. 构建新镜像: ./scripts/build.sh ${VERSION}"
