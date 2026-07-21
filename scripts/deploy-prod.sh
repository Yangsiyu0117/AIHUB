#!/bin/bash
# 生产环境部署脚本
# 用法: ./scripts/deploy-prod.sh [版本号]

set -e

VERSION=${1:-"latest"}
IMAGE_NAME="new-api"

echo "🚀 部署 new-api ${VERSION} 到生产环境..."

# 检查 .env.prod 文件
if [ ! -f .env.prod ]; then
    echo "❌ 未找到 .env.prod 文件"
    echo "请先创建: cp .env.prod.example .env.prod"
    exit 1
fi

# 停止旧容器
echo "⏹️  停止旧容器..."
docker compose -f docker-compose.prod.yml down

# 拉取新镜像（如果是本地构建则跳过）
if [[ "$VERSION" != "latest" ]]; then
    echo "📥 拉取镜像 ${IMAGE_NAME}:${VERSION}..."
    docker pull ${IMAGE_NAME}:${VERSION} 2>/dev/null || echo "使用本地镜像"
fi

# 启动新容器
echo "▶️  启动新容器..."
docker compose -f docker-compose.prod.yml up -d

# 检查状态
echo ""
echo "📊 容器状态:"
docker compose -f docker-compose.prod.yml ps

echo ""
echo "✅ 部署完成！"
echo "🌐 访问地址: http://localhost:${PORT:-3000}"
