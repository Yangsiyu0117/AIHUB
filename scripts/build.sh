#!/bin/bash
# new-api 构建脚本
# 用法: ./scripts/build.sh [版本号]

set -e

VERSION=${1:-$(cat VERSION 2>/dev/null || echo "dev")}
IMAGE_NAME="new-api"
FULL_IMAGE="${IMAGE_NAME}:${VERSION}"

echo "🔨 开始构建 new-api ${VERSION}..."

# 构建 Docker 镜像
docker build -t ${FULL_IMAGE} -t ${IMAGE_NAME}:latest .

echo "✅ 构建完成: ${FULL_IMAGE}"
echo ""
echo "📋 镜像信息:"
docker images | grep ${IMAGE_NAME} | head -3
