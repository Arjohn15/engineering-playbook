# 💻 Frontend Coding Standards

These are the coding standards and conventions I follow when building TypeScript and React frontend applications.

---

## 🎯 Core Rules

1. **Strict TypeScript (No `any`):**
   - Never use `any`. Always use explicit types, interfaces, or generics.
   - For unknown inputs (e.g. dynamic JSON), use `unknown` and narrow with type guards or Zod.
2. **Feature-Driven Co-location:**
   - Keep domain types, hooks, API fetchers, and components co-located inside the feature directory (`src/features/[feature]`).
3. **Pure Presentational Components:**
   - Components should render based on props and trigger event callbacks.
   - Heavy data processing, business logic, or state orchestration belongs in dedicated custom hooks (`use[Feature].ts`).
4. **Token-First Styling:**
   - Style exclusively using CSS variables and semantic design tokens from `globals.css` / `tokens.css`.
   - Never hardcode arbitrary colors (`#1a2b3c`) or ad-hoc Tailwind values (`max-w-[423px]`).
5. **No Native Dialogs:**
   - Never use `window.alert`, `window.confirm`, or `window.prompt`. Use application modals and toast feedback.

---

## 🏷️ Naming Conventions

| Item                   | Convention              | Example                                          |
| :--------------------- | :---------------------- | :----------------------------------------------- |
| **Components**         | `PascalCase.tsx`        | `AccountCard.tsx`, `TransactionModal.tsx`        |
| **Hooks**              | `camelCase.ts` (`use*`) | `useBudgetSummary.ts`, `useTransactionFilter.ts` |
| **Utilities**          | `camelCase.ts`          | `formatCurrency.ts`, `validateEmail.ts`          |
| **Types & Interfaces** | `PascalCase`            | `CreateTransactionPayload`, `UserSession`        |
| **Constants**          | `UPPER_SNAKE_CASE`      | `DEFAULT_PAGINATION_LIMIT`, `STORAGE_KEY`        |
| **Feature Views**      | `[feature]-view.tsx`    | `accounts-view.tsx`, `settings-view.tsx`         |

---

## 🔍 Verification Commands

Before committing or submitting a PR, run the standard verification pipeline:

```bash
# 1. Format code
npm run prettier --write .

# 2. Lint and autofix
npm run lint --fix

# 3. Type check (no emit)
npx tsc --noEmit
```

---

## 📝 Code Examples

### Good: Strongly-Typed Custom Hook Isolating Business Logic

```typescript
// src/features/accounts/hooks/useAccountBalance.ts
import { useMemo } from "react";
import type { Transaction } from "../types/transactions.types";

interface UseAccountBalanceProps {
  initialBalance: number;
  transactions: Transaction[];
}

interface AccountBalanceSummary {
  currentBalance: number;
  totalIncome: number;
  totalExpense: number;
}

export function useAccountBalance({
  initialBalance,
  transactions,
}: UseAccountBalanceProps): AccountBalanceSummary {
  return useMemo(() => {
    let income = 0;
    let expense = 0;

    for (const tx of transactions) {
      if (tx.type === "INCOME") {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    return {
      currentBalance: initialBalance + income - expense,
      totalIncome: income,
      totalExpense: expense,
    };
  }, [initialBalance, transactions]);
}
```

### Good: Component Adhering to Design Tokens & Accessibility

```tsx
// src/features/accounts/components/AccountCard.tsx
import React from "react";
import type { Account } from "../types/accounts.types";

interface AccountCardProps {
  account: Account;
  onSelect: (id: string) => void;
}

export const AccountCard: React.FC<AccountCardProps> = ({
  account,
  onSelect,
}) => {
  return (
    <article
      onClick={() => onSelect(account.id)}
      className="p-md rounded-lg border border-border bg-background hover:bg-background-subtle 
                 transition-all duration-200 ease-in-out cursor-pointer shadow-sm hover:shadow-md"
    >
      <div className="flex items-center justify-between mb-sm">
        <h3 className="title-medium text-foreground font-semibold">
          {account.name}
        </h3>
        <span className="text-body-small text-foreground-muted capitalize">
          {account.type}
        </span>
      </div>
      <p className="display-small font-bold text-primary">
        ₱{account.balance.toLocaleString("en-PH", { minimumFractionDigits: 2 })}
      </p>
    </article>
  );
};
```
