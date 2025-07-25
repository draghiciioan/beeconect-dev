@echo off
echo Starting infrastructure services...
docker-compose --env-file .env.development up --build -d traefik postgres-auth postgres-customers redis rabbitmq

echo.
echo Infrastructure services available:
echo   - Traefik Dashboard: http://localhost:8080
echo   - RabbitMQ Management: http://localhost:15672
echo   - PostgreSQL Auth: localhost:5432
echo   - PostgreSQL Customers: localhost:5433
echo   - Redis: localhost:6379