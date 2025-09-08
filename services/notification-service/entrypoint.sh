#!/bin/sh
# entrypoint.sh
set -euo pipefail

# Waiting for common services
/app/scripts/wait-for-services.sh "Notification Service"

echo "🚀 Starting the notification-service..."
exec npm start
