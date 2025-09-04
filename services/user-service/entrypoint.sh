#!/bin/sh
# entrypoint.sh

echo "📦 Applying Prisma schema changes directly to the database..."
npx prisma db push

echo "🚀 Starting the user-service..."
exec npm start
