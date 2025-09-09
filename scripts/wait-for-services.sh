#!/bin/bash
set -euo pipefail

# Usage: ./wait-for-services.sh <service-name>
SERVICE_NAME=${1:-"service"}

# Wait for Postgres
wait-for-it postgres:5432 --timeout=60 --strict -- echo "Postgres is up"

# Wait for Kafka
wait-for-it kafka:9092 --timeout=60 --strict -- echo "Kafka is up"

echo "$SERVICE_NAME has finished waiting for services... ✅"