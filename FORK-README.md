# AIHUB - new-api Fork

这是 new-api 的 Fork 版本，包含 AIClub Kling 代理接口兼容性补丁。

## 补丁内容

- `relay/channel/task/kling/adaptor.go` - AIClub Kling 适配器兼容性修改

## 快速开始

### 开发环境

```bash
# 启动开发环境
make dev

# 或分别启动
make dev-api    # 启动后端 (Docker)
make dev-web    # 启动前端
```

### 生产部署

```bash
# 1. 配置环境变量
cp .env.prod.example .env.prod
# 编辑 .env.prod 填入你的配置

# 2. 构建镜像
./scripts/build.sh

# 3. 部署
./scripts/deploy-prod.sh
```

## 版本更新

当上游 new-api 发布新版本时：

```bash
# 1. 更新到指定版本
./scripts/update-version.sh v1.0.0-rc.22

# 2. 解决冲突（如果有）
# 3. 测试
# 4. 推送
git push origin dev
```

## 脚本说明

| 脚本 | 用途 |
|------|------|
| `scripts/build.sh [版本]` | 构建 Docker 镜像 |
| `scripts/deploy-prod.sh [版本]` | 部署到生产环境 |
| `scripts/update-version.sh [版本]` | 更新上游版本 |

## 分支策略

- `main` - 跟踪上游 official new-api
- `dev` - 开发分支，包含你的补丁
- 生产部署从 `dev` 分支构建

## GitHub Actions

推送到 `dev` 或 `main` 分支会自动构建 Docker 镜像并推送到 GitHub Container Registry。

## 常见问题

### 更新后有冲突怎么办？

1. 查看冲突文件：`git diff --name-only --diff-filter=U`
2. 手动解决冲突
3. `git add . && git commit`
4. 测试通过后推送

### 如何回滚？

```bash
# 回滚到上一个版本
git revert HEAD
git push origin dev
```
