@echo off
echo Setting up BeeConect...
docker network create beeconect 2>nul || echo Network beeconect already exists.
mkdir letsencrypt 2>nul || echo Directory letsencrypt already exists.
echo Setup completed successfully.