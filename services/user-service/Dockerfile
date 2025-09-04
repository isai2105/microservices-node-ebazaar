FROM node:18-alpine

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl bash

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/user-service ./services/user-service

# Install all dependencies including dev for TS build
RUN npm install 

# Runs the build script defined in common/package.json to 
# compile TypeScript into JavaScript (dist/ folder)
WORKDIR /app/common
RUN npm run build

# Generate Prisma client
WORKDIR /app/services/user-service
RUN npx prisma generate

# Builds the user-service TypeScript code into JavaScript (dist/ folder).
RUN npm run build

EXPOSE 3000

# Use the entrypoint script
ENTRYPOINT ["sh", "/app/services/user-service/entrypoint.sh"]
