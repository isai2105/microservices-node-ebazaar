#!/bin/sh
set -euo pipefail

MODE=${1:-dev}

echo "Starting services in $MODE mode..."

if [ "$MODE" = "prod" ]; then
  docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
else
  docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
fi
