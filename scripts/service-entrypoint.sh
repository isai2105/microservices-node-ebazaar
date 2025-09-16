#!/bin/sh
set -euo pipefail

SERVICE_DIR="/app/services/${SERVICE_NAME}"
SCRIPTS_DIR="/app/scripts"
SKIP_PRISMA="${SKIP_PRISMA:-false}"
NODE_OPTIONS="${NODE_OPTIONS:-}"

# Waiting for common services
${SCRIPTS_DIR}/wait-for-services.sh $SERVICE_NAME

echo "🚀 Starting the ${SERVICE_NAME}..."


if [ "$SKIP_PRISMA" != "true" ]; then
    PRISMA_DIR="/app/services/${SERVICE_NAME}/prisma"

    if [ -d "$PRISMA_DIR/migrations" ] && [ "$(ls -A "$PRISMA_DIR/migrations")" ]; then
        echo "🔹 Migrations found — running migrate deploy"
        npx prisma migrate deploy --schema="$PRISMA_DIR/schema.prisma"
    else
        echo "⚠️ No migrations found — using db push instead"
        npx prisma db push --schema="$PRISMA_DIR/schema.prisma"
    fi
else
    echo "⏭️ SKIP_PRISMA is true — skipping Prisma migrations and db push"
fi


if [ -n "$NODE_OPTIONS" ]; then
    echo "🔧 Starting with custom options: $NODE_OPTIONS"
fi


exec node $NODE_OPTIONS ${SERVICE_DIR}/dist/index.js