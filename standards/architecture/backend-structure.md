# 🏗️ Backend Architecture & Structure Standards

This document outlines how I structure backend services and APIs using NestJS, TypeScript, and Prisma.

---

## 🎯 Architecture Principles

1. **Framework & Runtime:** Built on **NestJS** and **TypeScript** running on Node.js.
2. **Database & ORM:** **PostgreSQL** accessed through **Prisma ORM**.
3. **Separation of Concerns:**
   - **Controllers:** Thin layer. Responsible for route handling, parsing request payloads, and passing data to services. Never place business logic directly in controllers.
   - **Services:** Core business logic. Responsible for calculations, transactions, domain rules, and external integrations.
   - **Repositories / Database Access:** Handled through an injected `PrismaService` or explicit repository classes when complex query encapsulation is needed.
4. **Error Handling:** All errors are caught by a global exception filter and formatted using **RFC 7807 / RFC 9457 Problem Details** (`application/problem+json`).
5. **Declarative Security:** Centralize authentication and role-based access control (RBAC) in guards and decorators (`@Roles()`, `@Permissions()`, `@CurrentUser()`) to keep service methods focused on business logic.

---

## 📂 Standard Directory Layout (`apps/api/src`)

```text
apps/api/src/
├── app.controller.ts            # Base root health / info controller
├── app.module.ts                # Root application module orchestrating all sub-modules
├── app.service.ts               # Root application service
├── main.ts                      # Bootstrap entry point (CORS, global prefix, filters, pipes)
│
├── common/                      # Cross-cutting concerns & shared utilities
│   ├── decorators/              # Custom param and method decorators (@CurrentUser, @Roles, @ApiDocs)
│   ├── dto/                     # Shared DTOs (pagination, sorting, query filters)
│   ├── enums/                   # Shared backend enums
│   ├── exceptions/              # Domain and HTTP custom exception classes (AppException)
│   ├── filters/                 # Global exception filters (GlobalExceptionFilter RFC 7807)
│   ├── guards/                  # Centralized auth & RBAC guards (JwtAuthGuard, RolesGuard)
│   ├── interceptors/            # Response wrapping, logging, and transform interceptors
│   ├── interfaces/              # Shared TypeScript contracts (ProblemDetails, RequestUser)
│   ├── middleware/              # Express / Fastify middleware (request correlation ID, logger)
│   ├── pipes/                   # Custom validation and transformation pipes
│   └── utils/                   # Cryptographic, token, hashing, and formatting utilities
│
├── config/                      # Configuration modules and environment schema validation
│   ├── configuration.ts         # Typed configuration loader
│   └── env.validation.ts        # Zod / Joi / class-validator schema for process.env
│
├── database/                    # Persistence layer infrastructure
│   ├── prisma.module.ts         # Prisma lifecycle module
│   ├── prisma.service.ts        # Prisma client wrapper with lifecycle hooks ($connect, $disconnect)
│   └── seed/                    # Database seeding scripts
│
├── health/                      # Healthcheck and readiness probes (@nestjs/terminus)
│   ├── health.controller.ts
│   └── health.module.ts
│
├── integrations/                # 3rd-party provider SDK abstractions
│   ├── email/                   # E.g., Resend, SendGrid, Amazon SES
│   ├── storage/                 # E.g., AWS S3, Cloudflare R2
│   └── sms-weather/             # External weather or communication APIs
│
├── jobs/                        # Background tasks, queues (BullMQ), or crons (@nestjs/schedule)
│
└── modules/                     # Feature domain modules (Domain-Driven boundaries)
    ├── auth/                    # Authentication (sign-in, sign-up, password reset, tokens)
    ├── users/                   # User profile, preferences, and account management
    └── [feature-name]/          # Domain-specific modules (e.g., accounts, transactions, incidents)
        ├── dto/                 # Request and response data transfer objects
        ├── schemas/             # Zod or class-validator validation schemas
        ├── entities/            # Domain entities (if abstracted beyond Prisma models)
        ├── interfaces/          # Service contracts and internal interfaces
        ├── [feature].controller.ts
        ├── [feature].service.ts
        ├── [feature].module.ts
        └── [feature].repository.ts  # (Optional: for complex query encapsulation)
```

---

## 🧱 Module Structure Blueprint

When creating a feature module in `src/modules/[feature-name]`, I organize it like this:

| File / Folder                  | Responsibility                                                                       |
| :----------------------------- | :----------------------------------------------------------------------------------- |
| `[feature].module.ts`          | Declares imports, controllers, providers, and exported services.                     |
| `[feature].controller.ts`      | Exposes REST endpoints (`/api/v1/[feature]`). Thin and declarative.                  |
| `[feature].service.ts`         | Implements domain business logic and orchestrates database transactions.             |
| `[feature].repository.ts`      | Encapsulates complex Prisma queries (optional for simple CRUD).                      |
| `dto/`                         | Input transfer objects (e.g., `create-[feature].dto.ts`, `update-[feature].dto.ts`). |
| `schemas/`                     | Validation schemas (e.g., Zod schemas or class-validator decorators).                |
| `interfaces/`                  | Internal interfaces and method return type definitions.                              |
| `[feature].service.spec.ts`    | Unit tests for the business logic.                                                   |
| `[feature].controller.spec.ts` | Unit / integration tests for the HTTP layer.                                         |

---

## 🛡️ Best Practices & Rules

### 1. Thin Controllers, Fat Services

- Controllers must **not** perform business calculations, direct database queries, or data transformations.
- Controllers should parse inputs, verify user permissions via decorators, call the appropriate service method, and return the result.

```typescript
// Good: Thin Controller
@Controller("accounts")
@UseGuards(JwtAuthGuard)
export class AccountsController {
  constructor(private readonly accountsService: AccountsService) {}

  @Post()
  async create(
    @CurrentUser("id") userId: string,
    @Body(new ZodValidationPipe(createAccountSchema)) dto: CreateAccountDto,
  ) {
    return this.accountsService.createAccount(userId, dto);
  }
}
```

### 2. Standardized Error Handling (RFC 7807 Problem Details)

- Throw standard NestJS exceptions (`BadRequestException`, `NotFoundException`, `UnauthorizedException`, `ForbiddenException`, `ConflictException`) or domain-specific exceptions extending `AppException`.
- A centralized `GlobalExceptionFilter` catches all exceptions and transforms them into standard `application/problem+json` responses:

```json
{
  "type": "https://errors.example.com/not-found",
  "title": "Account Not Found",
  "status": 404,
  "detail": "No account with ID 9a2b8e... exists for the current user.",
  "instance": "/api/v1/accounts/9a2b8e",
  "invalidParams": []
}
```

### 3. Strict Input Validation

- All inbound request payloads (Body, Query, Params) must be strictly validated before entering the service layer.
- Use either:
  - **Zod schemas** paired with a `ZodValidationPipe`
  - **Class-Validator / Class-Transformer** with `@nestjs/common`'s `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true })`
- Never accept unvalidated `any` or raw `Record<string, unknown>` payloads.

### 4. Database Access & Transactions

- All database operations must go through `PrismaService`.
- Multi-step modifications that depend on each other must use `prisma.$transaction()` to guarantee atomicity.
- Avoid N+1 queries by leveraging Prisma's `include`, `select`, or batching mechanisms.

### 5. Centralized RBAC & Guards

- Do not check roles or permissions manually inside service methods.
- Declare security requirements on controllers and routes using guards and decorators:

```typescript
@Get('admin/metrics')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMIN', 'COMMAND_CENTER')
async getMetrics() {
  return this.adminService.getMetrics();
}
```

### 6. Logging Standards

- **Never** use raw `console.log()` or `console.error()` in production code.
- Inject the built-in `Logger` class from `@nestjs/common` scoped to the class name:

```typescript
private readonly logger = new Logger(AccountsService.name);

// Usage:
this.logger.log(`Account ${accountId} created for user ${userId}`);
this.logger.error(`Failed to process transaction for account ${accountId}`, error.stack);
```

### 7. Security & Authentication

- Issue JWTs via secure, HTTP-only cookies (`access_token`) or Bearer tokens.
- Keep secret keys, database credentials, and external API keys in `.env` and validate them on startup using a configuration validator.
