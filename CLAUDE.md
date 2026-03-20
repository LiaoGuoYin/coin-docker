# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A collection of independent Docker Compose configurations for self-hosted services. Each service lives in its own directory and is deployed independently. No shared orchestration layer — services are standalone.

## Common Commands

Via Makefile (from repo root):

```bash
make list              # Show all services and their ports
make status            # Show running services
make up s=n8n          # Start a service
make down s=n8n        # Stop a service
make update s=n8n      # Pull latest image and restart
make update-all        # Update all running services
make logs s=n8n        # Tail logs
```

Or directly from a service directory:

```bash
cd <service-name>
cp .env.example .env   # first time only — fill in actual values
docker compose up -d
```

## Adding a New Service

1. Create a new directory: `mkdir <service-name>`
2. Add `docker-compose.yaml` following the patterns below
3. If the service needs secrets/env vars, add `.env.example` with placeholders
4. Update `README.md` service list

## Key Patterns

**Compose file style (unified):**
- No `version:` field (Docker Compose v2)
- `restart: always` on every service
- Ports: unquoted, no `0.0.0.0:` prefix (e.g., `- 8080:80`)
- Environment variables: list style `- KEY=value` (not map style `KEY: value`)
- Volumes: unquoted (e.g., `- ./data:/app/data`)

**Environment variables:** All variable values use `${VAR_NAME}` syntax. Copy `.env.example` → `.env` and fill in real values. The `.env` file is gitignored.

**Gitignored directories:** `data/`, `config/`, `logs/` inside each service dir are excluded from git — all runtime state lives there.

**Image versions:** Standardized to `latest` across all services to enable automatic update detection.

**Networking:**
- Infrastructure/proxy services (Nginx Proxy Manager, RustDesk, Home Assistant, Tailscale, ZeroTier, Snell, TTYD, Chrome) use `network_mode: host`
- Application services use default bridge networking with explicit port mappings

## Service Categories

- **Networking/proxy:** `nginxproxy`, `tailscale`, `zerotier-one`, `zerotier-moon`, `snell`, `derper`, `v2ray`
- **Remote access:** `rustdesk`, `code-server`, `ttyd`, `chrome`, `wechat`
- **Productivity:** `n8n`, `hedgedoc`, `memos`, `paperless-ngx`, `drawio`
- **Media:** `metube`, `handbrake`, `moontv`
- **Dev tools:** `fuclaude`, `it-tools`, `shellngn`
- **Smart home:** `home-assistant`
- **Other:** `cloudsaver`, `libre`, `nullbr115`
