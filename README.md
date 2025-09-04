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
```

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

4. **Run with Docker Compose**

```bash
docker compose up --build
```

All services will run in separate containers, connected via Kafka and PostgreSQL.

---

## 🛠️ Available Scripts

- `npm run build` – Build all TypeScript services.
- `npm run lint` – Run ESLint across all services.
- `npm run format` – Format code with Prettier.
- `npx prisma db push` – Push Prisma schema to the database.

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
