# 📦 Monorepo Workflow & Best Practices

This guide explains how I organize and run full-stack monorepos using NPM or pnpm workspaces.

---

## 🏗️ Monorepo Architecture

I organize full-stack monorepos with dedicated directories for apps, shared packages, and system documentation:

```text
my-project/
├── .github/                     # CI/CD workflows (GitHub Actions)
├── apps/
│   ├── api/                     # NestJS backend API service
│   │   ├── src/
│   │   ├── test/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── web/                     # Next.js frontend web application
│       ├── src/
│       ├── public/
│       ├── package.json
│       └── next.config.ts
├── packages/                    # Optional shared packages (monorepos with code reuse)
│   ├── shared-types/            # Shared TypeScript interfaces & DTO contracts
│   ├── shared-schemas/          # Shared Zod / validation schemas
│   └── shared-utils/            # Shared calculation and date helpers
├── docs/                        # Central system documentation
│   ├── api/                     # OpenAPI specifications (openapi.yaml)
│   ├── architecture/            # Structurizr DSL (workspace.dsl) & C4 diagrams
│   └── database/                # Schema models (erd.dbml, erd.svg, migrations)
├── docker-compose.yml           # Local multi-container development environment
├── package.json                 # Monorepo root scripts & workspace configuration
└── README.md                    # Project overview, setup, and run instructions
```

---

## ⚙️ Environment Variables Strategy

Environment variables are partitioned to protect credentials and maintain clean scope:

| Location                 | Purpose                                                                             | Tracked in Git?         |
| :----------------------- | :---------------------------------------------------------------------------------- | :---------------------- |
| `/.env`                  | Root Docker Compose settings (`POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`). | ❌ Never (`.gitignore`) |
| `/apps/api/.env`         | Backend config (`DATABASE_URL`, `PORT=3001`, `JWT_SECRET`, `RESEND_API_KEY`).       | ❌ Never (`.gitignore`) |
| `/apps/web/.env.local`   | Frontend runtime config (`NEXT_PUBLIC_API_URL=http://localhost:3001/api/v1`).       | ❌ Never (`.gitignore`) |
| `/.env.example`          | Root template with placeholder values for setup.                                    | ✅ Yes                  |
| `/apps/api/.env.example` | Backend template with dummy keys.                                                   | ✅ Yes                  |
| `/apps/web/.env.example` | Frontend template.                                                                  | ✅ Yes                  |

---

## 🐳 Docker Compose Conventions

Local dependencies (PostgreSQL, Redis, MinIO) must be spun up using Docker Compose:

```yaml
services:
  db:
    image: postgres:17-alpine
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-app_user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-app_password}
      POSTGRES_DB: ${POSTGRES_DB:-app_db}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-app_user}"]
      interval: 3s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

### Starting the Local Stack

```bash
# Start database in background
docker compose up -d db

# Run Prisma migrations & seed
cd apps/api
npx prisma migrate dev
npx prisma db seed
```

---

## 🚀 Standard Development Commands

Commands I regularly use across workspaces:

| Action               | Command                                                                          |
| :------------------- | :------------------------------------------------------------------------------- |
| **Start Database**   | `docker compose up -d db`                                                        |
| **Run API Dev**      | `npm run start:dev --workspace=apps/api` (or `cd apps/api && npm run start:dev`) |
| **Run Web Dev**      | `npm run dev --workspace=apps/web` (or `cd apps/web && npm run dev`)             |
| **Type Check All**   | `npx tsc --noEmit` across workspaces                                             |
| **Lint & Format**    | `npm run lint --fix` && `npm run prettier --write .`                             |
| **Run Vitest Tests** | `npm run test` inside `apps/api`                                                 |
