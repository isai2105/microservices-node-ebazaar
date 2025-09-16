# =========================
# Stage 1: Build
# =========================
FROM node:18-alpine AS build

ARG SERVICE_NAME
ARG SKIP_PRISMA=false

# Install build dependencies
RUN apk add --no-cache openssl bash

WORKDIR /app

# Copy package files for deterministic install
COPY package.json package-lock.json tsconfig.base.json ./

# Copy common and service source code
COPY common ./common
COPY services/${SERVICE_NAME} ./services/${SERVICE_NAME}
COPY services/${SERVICE_NAME}/entrypoint.sh ./services/${SERVICE_NAME}/entrypoint.sh

# Install all dependencies including dev for building
RUN npm install

# Build common package
WORKDIR /app/common
RUN npm run build

# Generate Prisma client and build the service TypeScript
WORKDIR /app/services/${SERVICE_NAME}
RUN if [ "$SKIP_PRISMA" != "true" ]; then \
        ls -la prisma || echo "no prisma folder found"; \
        npx prisma generate; \
    fi

# Always ensure the prisma folder exists in the build stage
# To prevent an error dyring the production stage when copying files
RUN mkdir -p /app/services/${SERVICE_NAME}/prisma

RUN npm run build


# =========================
# Stage 2: Production
# =========================
FROM node:18-alpine AS prod

ARG SERVICE_NAME
ARG SKIP_PRISMA=false

# Install runtime dependencies
RUN apk add --no-cache openssl bash

# Set NODE_ENV to production
ENV NODE_ENV=production

WORKDIR /app

# Copy built artifacts from build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/common/dist ./common/dist
COPY --from=build /app/services/${SERVICE_NAME}/dist ./services/${SERVICE_NAME}/dist
COPY --from=build /app/services/${SERVICE_NAME}/prisma ./services/${SERVICE_NAME}/prisma
COPY --from=build /app/services/${SERVICE_NAME}/entrypoint.sh ./services/${SERVICE_NAME}/entrypoint.sh

WORKDIR /app/scripts
# Copy the 'wait-for-it' script
COPY scripts/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it
# Copy the 'wait-for-services' script
COPY scripts/wait-for-services.sh ./
RUN chmod +x /app/scripts/wait-for-services.sh
# Copy the 'common service entrypoint' script
COPY scripts/service-entrypoint.sh ./
RUN chmod +x /app/scripts/service-entrypoint.sh

# Generate wrapper entrypoint
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -euo pipefail' >> /app/entrypoint.sh && \
    echo "exec sh /app/services/${SERVICE_NAME}/entrypoint.sh \"\$@\"" >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

# Optional: run as non-root user for security
RUN addgroup -S app && adduser -S app -G app
USER app

EXPOSE 3000

ENTRYPOINT ["/app/entrypoint.sh"]
