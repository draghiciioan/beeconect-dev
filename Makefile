.PHONY: help setup dev stop clean

help: ## Show help
	@echo 'BeeConect Development Commands:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Setup development environment
	@echo "Setting up BeeConect..."
	@docker network create beeconect 2>/dev/null || true

dev: ## Start all services
	@echo "Starting BeeConect development..."
	@docker-compose up --build -d
	@echo "Services available:"
	@echo "  - Traefik Dashboard: http://localhost:8080"
	@echo "  - RabbitMQ Management: http://localhost:15672"
	@echo "  - Auth Service: http://localhost:8001"

stop: ## Stop all services
	@docker-compose down

clean: ## Clean everything
	@docker-compose down -v
	@docker system prune -f