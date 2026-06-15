# CLAUDE.md

Guidance for Claude Code working in this repository.

## What This Repo Is

A collection of **independent** Docker Compose configs for self-hosted services.
Each service is its own directory, deployed independently. No shared orchestration.

## Common Commands

Via Makefile (repo root): `make list | status | up s=n8n | down s=n8n | update s=n8n | update-all | logs s=n8n`

Per service: `cd <name> && cp .env.example .env && docker compose up -d`

## Adding a Service

1. Fetch upstream's **real** `docker-compose.yml` / `.env.example` (don't guess).
2. `mkdir <name>` — specific, prefer upstream project name (not generic like `wechat`).
3. Write `docker-compose.yaml` (see Patterns). Keep minimal — don't copy upstream defaults.
4. Only if the user must set secrets/keys/uid: add `.env.example`, one comment per var.
5. Validate: `printf 'K=v\n' >/tmp/c.env && docker compose --env-file /tmp/c.env config -q`
6. Tell the user to start it: `make up s=<name>`.

## Patterns

- No `version:`; `restart: always` on every service (even if upstream uses `unless-stopped`).
- Ports: literal, unquoted, no `0.0.0.0:` (e.g. `- 8080:80`) — `make list` greps `n:n`.
- Env: list style `- KEY=value`. Only user-set values (secrets/keys/uid) use `${VAR}` + `.env.example`; fixed values and ports stay literal.
- Volumes: unquoted. Put persistent state under `./data/...` (gitignored via `*/data/*`).
- Images: pinned to `latest` (enables `make update-all`).
- Networking: infra/proxy (nginxproxy, tailscale, zerotier, snell, derper, home-assistant, ttyd, chrome) use `network_mode: host`; apps use bridge + explicit ports.
- `docker.sock` mount = host-root-equivalent — warn the user (LAN-only, change passwords).

## Service Categories

- **Networking/proxy:** `nginxproxy`, `tailscale`, `zerotier-one`, `zerotier-moon`, `snell`, `derper`, `v2ray`
- **Remote access:** `rustdesk`, `code-server`, `ttyd`, `chrome`, `wechat-on-cloud`
- **Productivity:** `n8n`, `hedgedoc`, `memos`, `paperless-ngx`, `drawio`
- **Media:** `metube`, `handbrake`, `moontv`
- **Dev tools:** `fuclaude`, `it-tools`, `shellngn`
- **Smart home:** `home-assistant`
- **Other:** `cloudsaver`, `libre`, `nullbr115`, `syncthing`
