.PHONY: help setup dev prod stop-dev stop-prod clean

help: ## Show help
	@echo 'BeeConect Commands:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Setup environment (both dev and prod)
	@echo "Setting up BeeConect..."
	@docker network create beeconect 2>/dev/null || true
	@mkdir -p letsencrypt 2>/dev/null || true

dev: ## Start all services in development mode
	@echo "Starting BeeConect development environment..."
	@docker-compose --env-file .env.development up --build -d
	@echo "Development services available:"
	@echo "  - Traefik Dashboard: http://localhost:8080"
	@echo "  - RabbitMQ Management: http://localhost:15672"
	@echo "  - Auth Service: http://localhost:8001"
	@echo "  - Customers Service: http://localhost:8016"
	@echo "  - Frontend Web Service: http://localhost:3001"

prod: ## Start all services in production mode
	@echo "Starting BeeConect production environment..."
	@docker-compose -f docker-compose.prod.yml --env-file .env.production up --build -d
	@echo "Production services available at:"
	@echo "  - Auth Service: https://auth.$(shell grep DOMAIN_NAME .env.production | cut -d '=' -f2)"
	@echo "  - Traefik Dashboard: https://traefik.$(shell grep DOMAIN_NAME .env.production | cut -d '=' -f2) (protected by basic auth)"

stop-dev: ## Stop development services
	@echo "Stopping development services..."
	@docker-compose --env-file .env.development down

stop-prod: ## Stop production services
	@echo "Stopping production services..."
	@docker-compose -f docker-compose.prod.yml --env-file .env.production down

stop: ## Stop all services (both dev and prod)
	@echo "Stopping all services..."
	@make stop-dev
	@make stop-prod

clean: ## Clean everything
	@echo "Cleaning up..."
	@docker-compose --env-file .env.development down -v
	@docker-compose -f docker-compose.prod.yml --env-file .env.production down -v
	@docker system prune -f