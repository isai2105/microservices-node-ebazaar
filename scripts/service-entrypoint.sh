#!/bin/sh
set -euo pipefail

SERVICE_DIR="/app/services/${SERVICE_NAME}"
SCRIPTS_DIR="/app/scripts"
SKIP_PRISMA="${SKIP_PRISMA:-false}"
NODE_OPTIONS="${NODE_OPTIONS:-}"

if [ "$NODE_ENV" = "development" ]; then
    echo "Starting TypeScript compilation for common/..."
    npx tsc -w -p /app/common/tsconfig.json &
    echo "Starting TypeScript compilation for $SERVICE_NAME/..."
    npx tsc -w -p /app/services/$SERVICE_NAME/tsconfig.json &
fi

# Waiting for common services
${SCRIPTS_DIR}/wait-for-services.sh $SERVICE_NAME

echo "🚀 Starting the ${SERVICE_NAME}..."

if [ "$SKIP_PRISMA" != "true" ]; then
    PRISMA_DIR="/app/services/${SERVICE_NAME}/prisma"

    if [ -d "$PRISMA_DIR" ]; then
        if [ -d "$PRISMA_DIR/migrations" ] && [ "$(ls -A "$PRISMA_DIR/migrations" 2>/dev/null)" ]; then
            echo "🔹 Migrations found — running migrate deploy"
            npx prisma migrate deploy --schema="$PRISMA_DIR/schema.prisma"
        elif [ -f "$PRISMA_DIR/schema.prisma" ]; then
            echo "⚠️ No migrations found — using db push instead"
            npx prisma db push --schema="$PRISMA_DIR/schema.prisma"
        else
            echo "❌ Prisma folder exists but schema.prisma not found — skipping"
        fi
    else
        echo "⚠️ Prisma folder not found — skipping migrations/db push"
    fi
else
    echo "⏭️ SKIP_PRISMA is true — skipping Prisma migrations and db push"
fi


if [ -n "$NODE_OPTIONS" ]; then
    echo "🔧 Starting with custom options: $NODE_OPTIONS"
fi


exec node $NODE_OPTIONS ${SERVICE_DIR}/dist/index.js