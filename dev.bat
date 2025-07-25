@echo off
echo Starting BeeConect development environment...
docker-compose --env-file .env.development up --build -d
echo.
echo Development services available:
echo   - Traefik Dashboard: http://localhost:8080
echo   - RabbitMQ Management: http://localhost:15672
echo   - Auth Service: http://localhost:8001
echo   - Customers Service: http://localhost:8016
echo   - Web Service: http://localhost:3001