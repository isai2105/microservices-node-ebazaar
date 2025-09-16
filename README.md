# Microservices Node.js Boilerplate

A production-ready **Node.js microservices boilerplate** built with TypeScript, npm workspaces, Prisma, PostgreSQL, Kafka (KRaft mode), and Docker Compose. This project includes separate services for orders, products, users, payments, and notifications, plus a shared `common` package for cross-service logic. Preconfigured with ESLint, Prettier, and Prisma migrations for rapid development.

---

## 🚀 Features

- **Microservices architecture**: Independent services communicating via Kafka.
- **TypeScript & Node.js**: Strongly typed and modern JavaScript features.
- **Database**: PostgreSQL with Prisma ORM.
- **Messaging**: Kafka (KRaft mode, no Zookeeper required).
- **Authentication**: JWT-based auth and bcryptjs password hashing.
- **Dockerized**: Each service runs in its own container with Docker Compose.
- **Monorepo**: Managed with npm workspaces for shared packages (`common`) and service isolation.
- **Code quality**: ESLint and Prettier configurations at root level.

---

## 🏗️ Project Structure

```
microservices-node-demo/
├─ package.json        # Root workspace config + scripts
├─ tsconfig.base.json  # Shared TypeScript configuration
├─ docker-compose.yml  # Services + Kafka + Postgres orchestration
├─ .env.example        # Shared environment variables
├─ common/             # Shared utilities and modules
│  ├─ package.json
│  └─ src/
├─ services/
│  ├─ user-service/
│  ├─ product-service/
│  ├─ order-service/
│  ├─ payment-service/
│  └─ notification-service/
├─ scripts/
│  ├─ commit.sh.       # Tool commit changes using a standard process (npm run commit)
```

---

## 🟢 Service Startup & Health Checks

This project uses a **“wait-for-it”** pattern together with Docker Compose health checks to make sure dependent services are fully ready before each microservice starts:

- **PostgreSQL** and **Kafka** containers expose health checks so Docker Compose can mark them as healthy.
- Each microservice runs a small startup script (via [`wait-for-it.sh`](https://github.com/vishnubob/wait-for-it)) that blocks until its dependencies (for example Postgres on port 5432 or Kafka on port 9092) are reachable before running its main process.
- This prevents “connection refused” errors at startup and ensures a predictable boot sequence.

---

## ⚡ Getting Started

1. **Clone the repo**

```bash
git clone https://github.com/isai2105/microservices-node-ebazaar.git
cd microservices-node-ebazaar
```

2. **Set up environment variables**

Copy `.env.example` to `.env` and fill in your credentials:

```bash
cp .env.example .env
```

3. **Install dependencies**

```bash
npm install
```

4. **Run with npm 'start:services' script**

```bash
# Start services in development mode (default)
npm run start:services

# Explicitly start services in development mode
npm run start:services:dev

# Start services in development mode with debug enabled
npm run start:services:dev:debug

# Start services in production mode
npm run start:services:prod
```

5. **Commit any changes**

First, manually add any changes to git

```bash
npm run commit
```

---

## 🛠️ Available Scripts

- `npm run build` – Build all TypeScript services.
- `npm run lint` – Run ESLint across all services.
- `npm run format` – Format code with Prettier.
- `npx prisma db push` – Push Prisma schema to the database.
- `npm run validate` – Runs ESlint code validation and prettier format check.
- `npm run fix` – Runs ESlint to fix any linting issues and Prettier to fix any format issues.
- `npm run commit` – Runs custom commit.sh script to keep commit messages in an standard style & process.
- `npm run push` – Runs 'git push'.
- `npm run start:services` – Runs `sh scripts/startup.sh`. Default environment is `dev` if no parameter is provided.
- `npm run start:services:dev` – Start all services in **development mode**.
- `npm run start:services:dev:debug` – Start all services in **development mode with debugging enabled**.
- `npm run start:services:prod` – Start all services in **production mode**.

---

## 💻 Debugging with VS Code

You can configure VS Code to debug each microservice using a `launch.json` file in the `.vscode` folder.

Example `launch.json` file:

```
{
  "configurations": [

    {
      "name": "User Service",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "outFiles": [
        "${workspaceFolder}/**/dist/**/*.js"
      ],
      "sourceMaps": true,
      "restart": true,
      "timeout": 30000,
      "trace": true
    },
    {
      "name": "Product Service",
      "type": "node",
      "request": "attach",
      "port": 9230,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "outFiles": [
        "${workspaceFolder}/**/dist/**/*.js"
      ],
      "sourceMaps": true,
      "restart": true,
      "timeout": 30000,
      "trace": true
    },
    {
      "name": "Order Service",
      "type": "node",
      "request": "attach",
      "port": 9231,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "outFiles": [
        "${workspaceFolder}/**/dist/**/*.js"
      ],
      "skipFiles": [
          "${workspaceFolder}/node_modules/**/*.js",
          "${workspaceFolder}\\node_modules\\**\\*.js",
          "<node_internals>/**/*.js",
          "<node_internals>\\**\\*.js"
      ],
      "sourceMaps": true,
      "restart": true,
      "timeout": 30000,
      "trace": true
    },
    {
      "name": "Payment Service",
      "type": "node",
      "request": "attach",
      "port": 9232,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "outFiles": [
        "${workspaceFolder}/**/dist/**/*.js"
      ],
      "skipFiles": [
          "${workspaceFolder}/node_modules/**/*.js",
          "${workspaceFolder}\\node_modules\\**\\*.js",
          "<node_internals>/**/*.js",
          "<node_internals>\\**\\*.js"
      ],
      "sourceMaps": true,
      "restart": true,
      "timeout": 30000,
      "trace": true
    },
    {
      "name": "Notification Service",
      "type": "node",
      "request": "attach",
      "port": 9233,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "outFiles": [
        "${workspaceFolder}/**/dist/**/*.js"
      ],
      "skipFiles": [
          "${workspaceFolder}/node_modules/**/*.js",
          "${workspaceFolder}\\node_modules\\**\\*.js",
          "<node_internals>/**/*.js",
          "<node_internals>\\**\\*.js"
      ],
      "sourceMaps": true,
      "restart": true,
      "timeout": 30000,
      "trace": true
    },
  ],
  "compounds": [
    {
      "name": "Debug All Services",
      "configurations": [
        "User Service",
        "Product Service",
        "Order Service",
        "Payment Service",
        "Notification Service"
      ]
    }
  ]
}
```

---

## 🧹 Cleaning Up Stale Docker Networks

If you see an error like this when starting the stack:

Error response from daemon: failed to set up container networking: network <id> not found

it usually means Docker left behind an **unused network** from a previous run (for example after switching between `dev` and `prod` Compose files).

To remove all unused (dangling) networks, run:

```
docker network prune -f
```

After pruning, simply start your containers again.

---

## 📝 Notes

- **Prisma**: Each service uses its own Prisma schema and client.
- **Kafka**: Running in KRaft mode, no Zookeeper required.
- **Docker**: Services expose ports 3000–3004 by default. Adjust in `docker-compose.yml`.
- **Shared Code**: Use `common` workspace for utilities or cross-service logic.

---

## 📄 License

This project is licensed under **Apache-2.0** — see the [LICENSE](https://github.com/isai2105/microservices-node-ebazaar#Apache-2.0-1-ov-file) file for details.

---

## 👀 Recommended Next Steps

- Add **integration tests** for each service.
- Implement **authentication across services** using JWT.
- Add **OpenAPI / Swagger docs** for each service.
- Extend Kafka with **multiple topics and consumers** for event-driven flows.
