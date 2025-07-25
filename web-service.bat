@echo off
echo Starting web-service with dependencies...
docker-compose --env-file .env.development up --build -d auth-service customers-service web-service

echo.
echo Web Service available at: http://localhost:3001
echo Dependencies available:
echo   - Auth Service: http://localhost:8001
echo   - Customers Service: http://localhost:8016