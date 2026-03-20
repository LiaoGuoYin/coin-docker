.PHONY: list status up down update update-all logs

# Show all services and their ports
list:
	@printf "%-20s %s\n" "SERVICE" "PORTS"
	@printf "%-20s %s\n" "-------" "-----"
	@for d in */; do \
	  [ -f "$$d/docker-compose.yaml" ] || continue; \
	  name=$${d%/}; \
	  if grep -q 'network_mode.*host' "$$d/docker-compose.yaml" 2>/dev/null; then \
	    printf "%-20s %s\n" "$$name" "[host]"; \
	  else \
	    ports=$$(sed 's/"//g' "$$d/docker-compose.yaml" | sed 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}://' | grep -oE '[0-9]+:[0-9]+' | tr '\n' ' '); \
	    printf "%-20s %s\n" "$$name" "$${ports:--}"; \
	  fi; \
	done

# Show running services
status:
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Start a service: make up s=n8n
up:
	@cd $(s) && docker compose up -d

# Stop a service: make down s=n8n
down:
	@cd $(s) && docker compose down

# Update a service: make update s=n8n
update:
	@cd $(s) && docker compose pull && docker compose up -d

# Update all running services
update-all:
	@for d in */; do \
	  [ -f "$$d/docker-compose.yaml" ] || continue; \
	  (cd "$$d" && docker compose ps -q 2>/dev/null | grep -q . && \
	    echo "=== $${d%/} ===" && \
	    docker compose pull && docker compose up -d) || true; \
	done

# View logs: make logs s=n8n
logs:
	@cd $(s) && docker compose logs -f
