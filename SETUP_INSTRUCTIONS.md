# BeeConect Microservices Setup Instructions

## Overview

This document explains how all microservices have been connected in the beeconect-dev environment, allowing you to run them from a central location. The following microservices are now integrated:

1. **Auth Service** (bee_auth_services)
2. **Customers Service** (bee_customers_service)
3. **Frontend Web Service** (bee_frontend_web_service)

## Changes Made

The following changes were made to connect all microservices:

1. **Updated docker-compose.yml**:
   - Added service definitions for customers-service and frontend-web-service
   - Added a PostgreSQL database for the customers service
   - Configured network settings for all services
   - Set up volume mappings for databases
   - Configured environment variables for all services

2. **Created Dockerfile for Frontend Web Service**:
   - Set up a multi-stage build process
   - First stage builds the React application
   - Second stage serves the built application using Nginx

3. **Updated .env.development**:
   - Added environment variables for the customers service
   - Added environment variables for the frontend service
   - Updated CORS settings to include all service URLs

4. **Updated Makefile**:
   - Added information about the new services in the output messages

## How to Use

### Starting All Services

To start all services in development mode, run:

```bash
cd beeconect-dev
make dev
```

This will start all services and display URLs for accessing them:
- Traefik Dashboard: http://localhost:8080
- RabbitMQ Management: http://localhost:15672
- Auth Service: http://localhost:8001
- Customers Service: http://localhost:8016
- Frontend Web Service: http://localhost:3001

### Stopping All Services

To stop all services, run:

```bash
cd beeconect-dev
make stop-dev
```

### Cleaning Up

To clean up all containers and volumes, run:

```bash
cd beeconect-dev
make clean
```

## Service URLs and Ports

| Service | URL | Internal Port | External Port |
|---------|-----|---------------|--------------|
| Auth Service | http://localhost:8001 | 8000 | 8001 |
| Customers Service | http://localhost:8016 | 8007 | 8016 |
| Frontend Web Service | http://localhost:3001 | 80 | 3001 |
| Traefik Dashboard | http://localhost:8080 | 8080 | 8080 |
| RabbitMQ Management | http://localhost:15672 | 15672 | 15672 |
| PostgreSQL Auth | localhost:5432 | 5432 | 5432 |
| PostgreSQL Customers | localhost:5433 | 5432 | 5433 |
| Redis | localhost:6379 | 6379 | 6379 |
| RabbitMQ | localhost:5672 | 5672 | 5672 |

## Troubleshooting

If you encounter any issues:

1. Check that Docker is running
2. Ensure all ports are available (not used by other applications)
3. Check the logs for each service:
   ```bash
   docker-compose logs auth-service
   docker-compose logs customers-service
   docker-compose logs frontend-web-service
   ```
4. If database connection issues occur, you may need to wait a few seconds for the databases to initialize

## Next Steps

As more microservices are developed, they can be added to the docker-compose.yml file following the same pattern:

1. Add a database service if needed
2. Add the microservice with appropriate environment variables
3. Update the .env.development file with any new environment variables
4. Update the Makefile to include information about the new service