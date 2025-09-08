FROM node:18-alpine

# Install OpenSSL for Prisma, Bash shell
RUN apk add --no-cache openssl bash

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/product-service ./services/product-service

# Install all dependencies including dev for TS build
RUN npm install 

WORKDIR /app/scripts
# Copy the 'wait-for-it' script
COPY scripts/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it
# Copy the 'wait-for-services' script
COPY scripts/wait-for-services.sh ./
RUN chmod +x /app/scripts/wait-for-services.sh

# Build common/dist
WORKDIR /app/common
RUN npm run build

# Generate Prisma client
WORKDIR /app/services/product-service
RUN npx prisma generate

RUN npm run build

EXPOSE 3000

# Use the entrypoint script
ENTRYPOINT ["sh", "/app/services/product-service/entrypoint.sh"]
