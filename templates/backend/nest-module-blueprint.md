# 🛠️ NestJS Feature Module Blueprint

This blueprint provides the exact file layout and boilerplate code for scaffolding a new feature module in `apps/api/src/modules/[feature-name]`.

---

## 📂 Target Structure

```text
apps/api/src/modules/accounts/
├── dto/
│   ├── create-account.dto.ts
│   └── update-account.dto.ts
├── schemas/
│   └── create-account.schema.ts
├── interfaces/
│   └── account-summary.interface.ts
├── accounts.controller.ts
├── accounts.service.ts
├── accounts.module.ts
├── accounts.service.spec.ts
└── accounts.controller.spec.ts
```

---

## 1. Validation Schema (`schemas/create-account.schema.ts`)

```typescript
import { z } from "zod";

export const createAccountSchema = z.object({
  name: z.string().min(1, "Account name is required").max(100),
  currency: z
    .string()
    .length(3, "Currency code must be 3 letters (e.g. PHP, USD)")
    .toUpperCase(),
  initialBalance: z
    .number()
    .min(0, "Initial balance cannot be negative")
    .default(0),
  description: z.string().max(255).optional(),
});

export type CreateAccountInput = z.infer<typeof createAccountSchema>;
```

---

## 2. DTO (`dto/create-account.dto.ts`)

```typescript
import { CreateAccountInput } from "../schemas/create-account.schema";

export class CreateAccountDto implements CreateAccountInput {
  name!: string;
  currency!: string;
  initialBalance!: number;
  description?: string;
}
```

---

## 3. Service (`accounts.service.ts`)

```typescript
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

  async findAll(userId: string) {
    return this.prisma.account.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async findOne(userId: string, id: string) {
    const account = await this.prisma.account.findFirst({
      where: { id, userId },
    });

    if (!account) {
      throw new NotFoundException(`Account with ID "${id}" was not found.`);
    }

    return account;
  }

  async create(userId: string, dto: CreateAccountDto) {
    this.logger.log(`User ${userId} creating account "${dto.name}"`);

    const existing = await this.prisma.account.findFirst({
      where: { userId, name: dto.name },
    });

    if (existing) {
      throw new ConflictException(
        `An account named "${dto.name}" already exists.`,
      );
    }

    return this.prisma.account.create({
      data: {
        userId,
        name: dto.name,
        currency: dto.currency,
        balance: dto.initialBalance,
        description: dto.description,
      },
    });
  }
}
```

---

## 4. Controller (`accounts.controller.ts`)

```typescript
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { CurrentUser } from "../../common/decorators/current-user.decorator";
import { ZodValidationPipe } from "../../common/pipes/zod-validation.pipe";
import { AccountsService } from "./accounts.service";
import { CreateAccountDto } from "./dto/create-account.dto";
import { createAccountSchema } from "./schemas/create-account.schema";

@Controller("accounts")
@UseGuards(JwtAuthGuard)
export class AccountsController {
  constructor(private readonly accountsService: AccountsService) {}

  @Get()
  async findAll(@CurrentUser("id") userId: string) {
    return this.accountsService.findAll(userId);
  }

  @Get(":id")
  async findOne(@CurrentUser("id") userId: string, @Param("id") id: string) {
    return this.accountsService.findOne(userId, id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(
    @CurrentUser("id") userId: string,
    @Body(new ZodValidationPipe(createAccountSchema)) dto: CreateAccountDto,
  ) {
    return this.accountsService.create(userId, dto);
  }
}
```

---

## 5. Module (`accounts.module.ts`)

```typescript
import { Module } from "@nestjs/common";
import { AccountsController } from "./accounts.controller";
import { AccountsService } from "./accounts.service";
import { DatabaseModule } from "../../database/database.module";

@Module({
  imports: [DatabaseModule],
  controllers: [AccountsController],
  providers: [AccountsService],
  exports: [AccountsService],
})
export class AccountsModule {}
```
