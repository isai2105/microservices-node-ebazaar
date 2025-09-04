FROM node:18-alpine

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl bash

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/order-service ./services/order-service

# Install all dependencies including dev for TS build
RUN npm install 

# Build common/dist
WORKDIR /app/common
RUN npm run build

# Generate Prisma client
WORKDIR /app/services/order-service
RUN npx prisma generate

RUN npm run build

EXPOSE 3000

# Use the entrypoint script
ENTRYPOINT ["sh", "/app/services/order-service/entrypoint.sh"]
