@echo off
echo Stopping all services...

echo Stopping development services...
docker-compose --env-file .env.development down

echo Stopping production services...
docker-compose -f docker-compose.prod.yml --env-file .env.production down

echo All services stopped.