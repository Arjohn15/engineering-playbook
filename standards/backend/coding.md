# ⚙️ Backend Coding Standards

These are the coding standards and conventions I follow when writing NestJS, TypeScript, and Prisma backend services.

---

## 🎯 Core Rules

1. **Thin Controllers, Fat Services:**
   - Controllers handle HTTP routing, request payload binding, status codes, and security decorators only.
   - All business logic, transaction logic, domain checks, and third-party interactions must live in Services.
2. **Standardized Responses & Error Handling:**
   - Throw semantic NestJS HTTP exceptions (`BadRequestException`, `NotFoundException`, `ForbiddenException`).
   - All errors are formatted via the centralized `GlobalExceptionFilter` into RFC 7807/9457 Problem Details (`application/problem+json`).
3. **No Direct `console.log`:**
   - Use NestJS's `Logger` class scoped to the class context for structured, leveled logging.
4. **Explicit Validation on Every Inbound Boundary:**
   - Every POST, PUT, PATCH request body and query string must be validated with DTOs and Zod/class-validator schemas.
5. **Database Queries through Prisma Client:**
   - All persistence must pass through `PrismaService`.
   - Dependent state changes must be executed in `prisma.$transaction()`.

---

## 🏷️ Naming Conventions

| Item             | Convention                    | Example                                         |
| :--------------- | :---------------------------- | :---------------------------------------------- |
| **Modules**      | `[name].module.ts`            | `accounts.module.ts`, `auth.module.ts`          |
| **Controllers**  | `[name].controller.ts`        | `accounts.controller.ts`                        |
| **Services**     | `[name].service.ts`           | `accounts.service.ts`                           |
| **Repositories** | `[name].repository.ts`        | `accounts.repository.ts`                        |
| **DTOs**         | `[action]-[entity].dto.ts`    | `create-account.dto.ts`, `update-status.dto.ts` |
| **Schemas**      | `[action]-[entity].schema.ts` | `create-account.schema.ts`                      |
| **Interfaces**   | `[name].interface.ts`         | `account-filter.interface.ts`                   |
| **Guards**       | `[name].guard.ts`             | `roles.guard.ts`, `jwt-auth.guard.ts`           |

---

## 🔍 Verification Commands

Before submitting code, run the standard verification suite:

```bash
# 1. Format code
npm run prettier --write .

# 2. Lint and autofix
npm run lint --fix

# 3. Run unit tests
npm run test

# 4. Run end-to-end API tests
npm run test:e2e
```

---

## 📝 Code Examples

### Good: Standardized Service with Transactions & Logger

```typescript
// src/modules/accounts/accounts.service.ts
import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
} from "@nestjs/common";
import { PrismaService } from "../../database/prisma.service";
import { CreateAccountDto } from "./dto/create-account.dto";

@Injectable()
export class AccountsService {
  private readonly logger = new Logger(AccountsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async createAccount(userId: string, dto: CreateAccountDto) {
    this.logger.log(`Creating account "${dto.name}" for user ID ${userId}`);

    const existing = await this.prisma.account.findFirst({
      where: { userId, name: dto.name },
    });

    if (existing) {
      throw new ConflictException(
        `An account named "${dto.name}" already exists.`,
      );
    }

    return this.prisma.$transaction(async (tx) => {
      const account = await tx.account.create({
        data: {
          userId,
          name: dto.name,
          currency: dto.currency,
          initialBalance: dto.initialBalance,
        },
      });

      if (dto.initialBalance > 0) {
        await tx.transaction.create({
          data: {
            accountId: account.id,
            userId,
            amount: dto.initialBalance,
            type: "INITIAL_DEPOSIT",
            description: "Opening balance",
          },
        });
      }

      return account;
    });
  }

  async findAccountById(userId: string, accountId: string) {
    const account = await this.prisma.account.findFirst({
      where: { id: accountId, userId },
    });

    if (!account) {
      throw new NotFoundException(`Account with ID "${accountId}" not found.`);
    }

    return account;
  }
}
```
