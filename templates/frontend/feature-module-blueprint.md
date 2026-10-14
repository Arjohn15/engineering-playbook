# 🛠️ Next.js Feature Module Blueprint

This blueprint provides the exact folder layout and boilerplate code for scaffolding a new domain feature in `apps/web/src/features/[feature-name]`.

---

## 📂 Target Structure

```text
apps/web/src/features/accounts/
├── api/
│   └── accounts.api.ts          # Fetchers and mutations
├── components/
│   ├── AccountCard.tsx          # Pure presentational component
│   └── AccountSkeleton.tsx     # 1:1 skeleton loader
├── constants/
│   └── account-options.ts       # Dropdowns and enum mappings
├── hooks/
│   └── useAccounts.ts           # Business logic & state management
├── types/
│   └── accounts.types.ts        # TypeScript contracts
└── accounts-view.tsx            # Top-level view container mounted in app/
```

---

## 1. Types (`types/accounts.types.ts`)

```typescript
export interface Account {
  id: string;
  name: string;
  currency: string;
  balance: number;
  description?: string;
  createdAt: string;
}

export interface CreateAccountPayload {
  name: string;
  currency: string;
  initialBalance: number;
  description?: string;
}
```

---

## 2. API Client (`api/accounts.api.ts`)

```typescript
import type { Account, CreateAccountPayload } from "../types/accounts.types";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3001/api/v1";

export async function fetchAccounts(): Promise<Account[]> {
  const res = await fetch(`${API_BASE_URL}/accounts`, {
    credentials: "include", // Includes HTTP-only JWT cookie
    headers: { "Content-Type": "application/json" },
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.detail || "Failed to fetch accounts.");
  }

  return res.json();
}

export async function createAccount(
  payload: CreateAccountPayload,
): Promise<Account> {
  const res = await fetch(`${API_BASE_URL}/accounts`, {
    method: "POST",
    credentials: "include",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.detail || "Failed to create account.");
  }

  return res.json();
}
```

---

## 3. Hook Isolating Business Logic (`hooks/useAccounts.ts`)

```typescript
"use client";

import { useState, useEffect, useCallback } from "react";
import toast from "react-hot-toast";
import { fetchAccounts, createAccount } from "../api/accounts.api";
import type { Account, CreateAccountPayload } from "../types/accounts.types";

export function useAccounts() {
  const [accounts, setAccounts] = useState<Account[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const loadAccounts = useCallback(async () => {
    try {
      setIsLoading(true);
      const data = await fetchAccounts();
      setAccounts(data);
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "An error occurred";
      toast.error(message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAccounts();
  }, [loadAccounts]);

  const handleCreate = async (payload: CreateAccountPayload) => {
    try {
      setIsSubmitting(true);
      const created = await createAccount(payload);
      // Prepend newly created item for high discoverability
      setAccounts((prev) => [created, ...prev]);
      toast.success(`Account "${created.name}" created successfully!`);
      return created;
    } catch (err: unknown) {
      const message =
        err instanceof Error ? err.message : "Failed to create account";
      toast.error(message);
      throw err;
    } finally {
      setIsSubmitting(false);
    }
  };

  return {
    accounts,
    isLoading,
    isSubmitting,
    createAccount: handleCreate,
    refreshAccounts: loadAccounts,
  };
}
```

---

## 4. Presentational Component (`components/AccountCard.tsx`)

```tsx
import React from "react";
import type { Account } from "../types/accounts.types";

interface AccountCardProps {
  account: Account;
  onSelect?: (id: string) => void;
}

export const AccountCard: React.FC<AccountCardProps> = ({
  account,
  onSelect,
}) => {
  return (
    <article
      onClick={() => onSelect?.(account.id)}
      className="p-md rounded-lg border border-border bg-background hover:bg-background-subtle 
                 transition-all duration-200 ease-in-out cursor-pointer shadow-sm hover:shadow-md"
    >
      <div className="flex items-center justify-between mb-sm">
        <h3 className="title-medium text-foreground font-semibold">
          {account.name}
        </h3>
        <span className="text-body-small text-foreground-muted uppercase font-semibold">
          {account.currency}
        </span>
      </div>
      <p className="display-small font-bold text-primary">
        ₱{account.balance.toLocaleString("en-PH", { minimumFractionDigits: 2 })}
      </p>
      {account.description && (
        <p className="body-small text-foreground-muted mt-xs line-clamp-2">
          {account.description}
        </p>
      )}
    </article>
  );
};
```

---

## 5. Main Feature View Container (`accounts-view.tsx`)

```tsx
"use client";

import React from "react";
import { useAccounts } from "./hooks/useAccounts";
import { AccountCard } from "./components/AccountCard";

export const AccountsView: React.FC = () => {
  const { accounts, isLoading } = useAccounts();

  return (
    <div className="w-full space-y-lg">
      {/* Contextual Toolbar */}
      <header className="sticky top-0 z-10 flex items-center justify-between py-md bg-background/80 backdrop-blur border-b border-border">
        <div>
          <h1 className="display-small font-bold text-foreground">Accounts</h1>
          <p className="body-medium text-foreground-muted">
            Manage your cash, bank accounts, and digital wallets.
          </p>
        </div>
        <button className="bg-primary hover:bg-primary-hover text-primary-foreground font-semibold px-md py-sm rounded-md transition-colors duration-200 cursor-pointer">
          Add Account
        </button>
      </header>

      {/* Content Grid */}
      {isLoading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-md">
          {[1, 2, 3].map((n) => (
            <div
              key={n}
              className="h-32 rounded-lg bg-background-subtle animate-pulse"
            />
          ))}
        </div>
      ) : accounts.length === 0 ? (
        <div className="p-2xl text-center border border-dashed border-border rounded-lg">
          <p className="body-large text-foreground-muted">
            No accounts added yet.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-md">
          {accounts.map((acc) => (
            <AccountCard key={acc.id} account={acc} />
          ))}
        </div>
      )}
    </div>
  );
};
```
