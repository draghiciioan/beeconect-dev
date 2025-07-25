@echo off
echo Starting BeeConect production environment...
docker-compose -f docker-compose.prod.yml --env-file .env.production up --build -d

echo.
echo Production services available at:
for /f "tokens=2 delims==" %%a in ('findstr "DOMAIN_NAME" .env.production') do (
    echo   - Auth Service: https://auth.%%a
    echo   - Traefik Dashboard: https://traefik.%%a (protected by basic auth)
)