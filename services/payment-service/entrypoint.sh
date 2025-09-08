#!/bin/sh
# entrypoint.sh
set -euo pipefail

# Waiting for common services
/app/scripts/wait-for-services.sh "Payment Service"

echo "🚀 Starting the payment-service..."
exec npm start
