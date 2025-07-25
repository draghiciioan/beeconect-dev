@echo off
echo Starting auth-service with dependencies...
docker-compose --env-file .env.development up --build -d postgres-auth redis rabbitmq auth-service

echo.
echo Auth service available at: http://localhost:8001
echo Dependencies available:
echo   - PostgreSQL Auth: localhost:5432
echo   - Redis: localhost:6379
echo   - RabbitMQ Management: http://localhost:15672