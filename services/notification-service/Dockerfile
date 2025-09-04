FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY tsconfig.base.json ./
COPY common ./common
COPY services/notification-service ./services/notification-service

# Install all dependencies including dev for TS build
RUN npm install 

# Build common
WORKDIR /app/common
# produces common/dist
RUN npm run build

WORKDIR /app/services/notification-service
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
