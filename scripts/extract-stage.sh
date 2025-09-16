#!/bin/bash
set -e

#!/bin/bash
set -e

# =============================================================================
# extract-stage.sh
# =============================================================================
# This script extracts the /app filesystem from a specific Docker build stage
# of a service in a monorepo, and copies it to a local directory.
#
# It is useful for:
#   - Inspecting the build or production stage of a service
#   - Debugging compiled artifacts (e.g., TypeScript -> JavaScript)
#   - Retrieving the built service without running the container
#
# The script supports multi-stage Dockerfiles with build/prod stages.
#
# Usage:
#   ./extract-stage.sh <service_name> [stage] [output_dir] [remove_image]
#
# Parameters:
#   service_name  - Name of the service (required, e.g., user-service)
#   stage         - Dockerfile stage to extract (optional, default: build)
#   output_dir    - Local directory to copy files into (optional, default: ./$SERVICE_NAME)
#   remove_image  - Whether to remove the intermediate image after copying (optional, default: false)
#
# Examples:
#   ./extract-stage.sh user-service
#       # Copies build stage of 'user-service' to ./user-service, keeps image
#
#   ./extract-stage.sh user-service prod ./user-service-prod
#       # Copies prod stage to ./user-service-prod, keeps the generated image
#
#   ./extract-stage.sh user-service prod ./user-service-prod true
#       # Copies prod stage to ./user-service-prod and removes the generated image
#
# =============================================================================

SERVICE_NAME="$1"
STAGE="${2:-build}"        # default to build stage
OUTPUT_DIR="${3:-./$SERVICE_NAME-$STAGE}"
REMOVE_IMAGE="${4:-false}" # default: do NOT remove generated image

if [ -z "$SERVICE_NAME" ]; then
  echo "❌ You must provide a service name"
  exit 1
fi

IMAGE_NAME="${SERVICE_NAME}-${STAGE}-stage"
CONTAINER_NAME="${SERVICE_NAME}-${STAGE}-temp"

echo "🔨 Building Docker image for service '$SERVICE_NAME' stage '$STAGE'..."
docker build \
  --file Dockerfile \
  --target "$STAGE" \
  --build-arg SERVICE_NAME="$SERVICE_NAME" \
  --build-arg SKIP_PRISMA=false \
  -t "$IMAGE_NAME" .

echo "📦 Creating temporary container..."
docker create --name "$CONTAINER_NAME" "$IMAGE_NAME"

echo "📂 Copying /app to '$OUTPUT_DIR'..."
mkdir -p "$OUTPUT_DIR"
docker cp "$CONTAINER_NAME":/app "$OUTPUT_DIR"

echo "🧹 Cleaning up temporary container..."
docker rm "$CONTAINER_NAME"

if [ "$REMOVE_IMAGE" = "true" ]; then
  echo "🗑 Removing intermediate image '$IMAGE_NAME'..."
  docker rmi "$IMAGE_NAME"
fi

echo "✅ Done! Files from '$STAGE' stage of '$SERVICE_NAME' are in '$OUTPUT_DIR'"
