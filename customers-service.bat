@echo off
echo Starting customers-service with dependencies...
docker-compose --env-file .env.development up --build -d postgres-customers rabbitmq customers-service

echo.
echo Customers service available at: http://localhost:8016
echo Dependencies available:
echo   - PostgreSQL Customers: localhost:5433
echo   - RabbitMQ Management: http://localhost:15672