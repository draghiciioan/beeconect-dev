.PHONY: help setup dev prod stop-dev stop-prod stop clean infrastructure auth-service customers-service frontend-web-service

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

infrastructure: ## Start only infrastructure services (traefik, postgres, redis, rabbitmq)
	@echo "Starting infrastructure services..."
	@docker-compose --env-file .env.development up --build -d traefik postgres-auth postgres-customers redis rabbitmq
	@echo "Infrastructure services available:"
	@echo "  - Traefik Dashboard: http://localhost:8080"
	@echo "  - RabbitMQ Management: http://localhost:15672"
	@echo "  - PostgreSQL Auth: localhost:5432"
	@echo "  - PostgreSQL Customers: localhost:5433"
	@echo "  - Redis: localhost:6379"

auth-service: ## Start auth-service with its dependencies
	@echo "Starting auth-service with dependencies..."
	@docker-compose --env-file .env.development up --build -d postgres-auth redis rabbitmq auth-service
	@echo "Auth service available at: http://localhost:8001"
	@echo "Dependencies available:"
	@echo "  - PostgreSQL Auth: localhost:5432"
	@echo "  - Redis: localhost:6379"
	@echo "  - RabbitMQ Management: http://localhost:15672"

customers-service: ## Start customers-service with its dependencies
	@echo "Starting customers-service with dependencies..."
	@docker-compose --env-file .env.development up --build -d postgres-customers rabbitmq customers-service
	@echo "Customers service available at: http://localhost:8016"
	@echo "Dependencies available:"
	@echo "  - PostgreSQL Customers: localhost:5433"
	@echo "  - RabbitMQ Management: http://localhost:15672"

frontend-web-service: ## Start frontend-web-service with its dependencies
	@echo "Starting frontend-web-service with dependencies..."
	@docker-compose --env-file .env.development up --build -d auth-service customers-service frontend-web-service
	@echo "Frontend web service available at: http://localhost:3001"
	@echo "Dependencies available:"
	@echo "  - Auth Service: http://localhost:8001"
	@echo "  - Customers Service: http://localhost:8016"

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