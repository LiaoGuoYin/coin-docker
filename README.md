# Coin Docker Services

一个基于 Docker Compose 的自托管服务集合，包含多种实用的开源应用服务。

## 项目概览

本项目提供了一系列预配置的 Docker Compose 配置文件，用于快速部署各种自托管服务。每个服务都有独立的目录和配置，可以根据需要选择性部署。

## 包含的服务

### 协作与笔记

- **[HedgeDoc](https://hedgedoc.org/)** - 实时协作的 Markdown 笔记平台

  - 端口：13000
  - 目录：`./hedgedoc`
- **[Memos](https://www.usememos.com/)** - 开源的知识管理和协作平台

  - 端口：5230
  - 目录：`./memos`

### 网络工具

- **[Nginx Proxy Manager](https://nginxproxymanager.com/)** - 易用的反向代理管理界面

  - 端口：使用 host 网络模式
  - 目录：`./nginxproxy`
- **[Derper](https://tailscale.com/kb/1118/custom-derp-servers/)** - Tailscale DERP 中继服务器

  - 目录：`./derper`
- **[ZeroTier Moon](https://www.zerotier.com/)** - ZeroTier 私有根服务器

  - 目录：`./zerotier-moon`
- **[RustDesk](https://rustdesk.com/)** - 开源远程桌面软件服务端

  - 端口：21115-21119（使用 host 网络模式）
  - 目录：`./rustdesk`
- **[Snell](https://github.com/surge-networks/snell)** - 高性能的加密代理服务

  - 端口：10086（使用 host 网络模式）
  - 目录：`./snell`

### 其他服务

- **[CookieCloud](https://github.com/easychen/CookieCloud)** - Cookie 同步服务

  - 目录：`./cookiecloud`
- **[MetuBe](https://github.com/alexta69/metube)** - 基于 youtube-dl 的 Web UI

  - 目录：`./metube`
- **[ShellNGN](https://github.com/shellngn/shellngn)** - Web Shell 管理工具

  - 目录：`./shellngn`
- **[FuClaude](https://github.com/wangyuche/FuClaude)** - Claude API 中转服务

  - 目录：`./fuclaude`

## 快速开始

### 前置要求

- Docker Engine 20.10+
- Docker Compose v2.0+
- 足够的磁盘空间用于数据存储

### 部署步骤

1. 克隆本仓库

```bash
git clone https://github.com/yourusername/coin-docker.git
cd coin-docker
```

2. 选择要部署的服务，进入对应目录

```bash
cd <service-name>
```

3. 根据需要修改 docker-compose.yml 中的配置

   - 注意标记为 `# VAR` 的行需要根据实际情况修改
   - 检查端口是否冲突
   - 配置数据卷路径
4. 启动服务

```bash
docker-compose up -d
```

5. 查看服务状态

```bash
docker-compose ps
docker-compose logs -f
```

## 配置说明

所有服务的数据都通过 Docker volumes 挂载到本地目录，确保数据持久化：

- 配置文件通常在 `./data` 目录
- 日志文件在 `./logs` 目录（如适用）
- 大部分服务使用桥接网络模式
- RustDesk 和 Nginx Proxy Manager 使用 host 网络模式以获得更好的性能

### 备份数据

定期备份各服务的 data 目录，特别是：

- 数据库文件（如 memos 的 SQLite 数据库）
- 配置文件
- SSL 证书（nginxproxy/letsencrypt）

### 更新服务

```bash
# 停止服务
docker-compose down

# 拉取最新镜像
docker-compose pull

# 重新启动服务
docker-compose up -d
```

### 查看日志

```bash
# 查看特定服务的日志
docker-compose logs -f <service-name>

# 查看所有服务的日志
docker-compose logs -f
```

## Deprecated/Experimental

以下服务曾经集成过，现已废除：

* **[Wr.do](https://wr.do/)** - 网页快照和存档服务
* alist - 云盘挂载
* code-server - vscode 服务器
* cookiecloud - cookie 浏览器同步服务端

**注意**：使用这些服务时，请遵守相关法律法规和服务条款。

## 其他

所有 docker-compose.yaml 使用环境变量引用（${VAR_NAME}）

可以复制 .env.example 为 .env 并填写实际值，这样可以安全地分享配置而不暴露私有信息
