FROM node:18-alpine

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl bash

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/product-service ./services/product-service

# Install all dependencies including dev for TS build
RUN npm install 

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
