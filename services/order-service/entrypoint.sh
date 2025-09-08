#!/bin/sh
# entrypoint.sh
set -euo pipefail

# Waiting for common services
/app/scripts/wait-for-services.sh  "Order Service"

echo "📦 Applying Prisma schema changes directly to the database..."
npx prisma db push

echo "🚀 Starting the order-service..."
exec npm start
