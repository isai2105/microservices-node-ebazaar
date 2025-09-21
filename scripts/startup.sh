#!/bin/sh
set -euo pipefail

MODE=${1:-dev}
DEBUG=${2:-false}

echo "Starting services in $MODE mode..."

if [ "$DEBUG" = "true" ] || [ "$DEBUG" = "debug" ]; then
    echo "DEBUG mode enabled - exposing debug ports"
    export DEBUG_MODE=true
fi

if [ "$MODE" = "prod" ]; then
    if [ "$DEBUG" = "true" ] || [ "$DEBUG" = "debug" ]; then
        echo "Warning: Debug mode ON but will not be used in production"
    fi
    # Build images without cache
    docker compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache
    # Start containers
    docker compose -f docker-compose.yml -f docker-compose.prod.yml up
else
    if [ "$DEBUG" = "true" ] || [ "$DEBUG" = "debug" ]; then

        # Build each service by running npm run build inside its folder
        for service in services/*; do
        if [ -f "$service/package.json" ]; then
            echo "Building $service..."
            (cd "$service" && \
            if [ -f "prisma/schema.prisma" ]; then
                echo "Generating Prisma client for $service..."
                npx prisma generate --schema="./prisma/schema.prisma"
            fi && \
            npm run build)
                fi
                done

        # dev:debug override compose files
        docker compose -f docker-compose.yml -f docker-compose.dev.yml -f docker-compose.debug.yml up --build
    else
        docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
    fi
fi