FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/payment-service ./services/payment-service

# Install all dependencies including dev for TS build
RUN npm install 

# Build common/dist
WORKDIR /app/common
RUN npm run build

# Generate Prisma client
WORKDIR /app/services/payment-service
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
