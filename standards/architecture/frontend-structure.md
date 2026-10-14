# 🎨 Frontend Architecture & Structure Standards

This document outlines how I structure frontend web applications using Next.js (App Router), React, and Tailwind CSS.

---

## 🎯 Architecture Principles

1. **Framework & Runtime:** **Next.js (App Router)** with **React** and **TypeScript**.
2. **Styling & Design System:** **Tailwind CSS v4** paired with a dedicated **Design System** driven by semantic CSS variable tokens.
3. **Feature-Driven Architecture:** Organize code by **domain features** (e.g., `accounts`, `auth`, `budgets`) rather than flat technical layers.
4. **Separation of Concerns:**
   - **Presentational UI Components:** Reusable components focused on UI rendering that accept props and trigger callbacks. No embedded business calculations or direct API orchestration.
   - **Custom Hooks & Services:** Dedicated stateful logic, business rules, and asynchronous data fetching cleanly separated from UI rendering.
   - **Feature View Containers:** Top-level view components (`*-view.tsx`) that wire hooks and state into UI components.
5. **No `any` Policy:** Strict TypeScript typings for domain entities, props, API responses, and form states.

---

## 📂 Standard Directory Layout (`apps/web/src`)

```text
apps/web/src/
├── app/                         # Next.js App Router (Routing, Layouts, Server Pages)
│   ├── (auth)/                  # Route groups for auth pages (sign-in, sign-up, reset)
│   │   ├── signin/page.tsx
│   │   └── signup/page.tsx
│   ├── (dashboard)/             # Protected application workspaces
│   │   ├── accounts/page.tsx
│   │   ├── budgets/page.tsx
│   │   └── layout.tsx
│   ├── api/                     # Next.js Route Handlers (BFF / edge proxies if needed)
│   ├── favicon.ico
│   ├── globals.css              # Global styles, Tailwind @theme mappings & base styles
│   └── layout.tsx               # Root layout with global providers (Toast, Theme, Auth)
│
├── components/                  # Cross-feature shared UI components
│   ├── ui/                      # Primitive atomic components (Button, Input, Modal, Badge)
│   ├── shared/                  # Reusable composite blocks (ConfirmationDialog, Navbar, Footer)
│   └── feedback/                # Skeletons, empty states, spinners, error boundaries
│
├── design-system/               # Central definitions for design tokens
│   ├── tokens.css               # Core semantic token definitions (colors, shadows, elevation)
│   ├── foundations/
│   │   ├── spacing.css          # Spacing tokens (none to 5xl)
│   │   └── radius.css           # Border radius tokens (none to full)
│   └── themes/
│       ├── light.css            # Light theme variable definitions
│       └── dark.css             # Dark theme variable definitions
│
├── features/                    # Feature modules (Feature-Driven Architecture)
│   ├── [feature-name]/          # Domain feature folder (e.g., accounts, transactions)
│   │   ├── api/                 # Feature-specific API client functions or Server Actions
│   │   │   └── [feature].api.ts
│   │   ├── components/          # Feature-specific UI components (e.g., AccountCard.tsx)
│   │   ├── constants/           # Feature-level constants and enum mappings
│   │   ├── hooks/               # Feature-specific business logic hooks (e.g., useAccountSummary.ts)
│   │   ├── types/               # Feature-specific TypeScript contracts and schemas
│   │   ├── utils/               # Domain-specific formatters or calculations
│   │   └── [feature]-view.tsx   # Top-level view container mounted in app/ page.tsx
│   └── template/                # Boilerplate template for scaffolding new features
│
├── hooks/                       # Global, reusable React hooks (useMediaQuery, useDebounce)
├── lib/                         # External library configurations & wrappers (api-client, fonts)
├── providers/                   # Context providers (ToastProvider, AuthProvider, ThemeProvider)
├── store/                       # Client state stores (Zustand or React Context)
├── styles/                      # Theme configuration or animation keyframes
├── types/                       # Shared application-wide TypeScript definitions
└── utils/                       # Shared utility functions (formatting, date, error handling)
```

---

## 🧱 Feature Module Layout Blueprint

I keep each distinct domain feature inside its own folder under `src/features/[feature-name]`:

```text
src/features/accounts/
├── api/
│   └── accounts.api.ts          # Fetcher / mutation functions talking to backend REST API
├── components/
│   ├── AccountCard.tsx          # Presentational UI component
│   ├── AccountFormModal.tsx     # Feature modal component
│   └── AccountListSkeleton.tsx  # Dedicated skeleton mirroring final layout
├── constants/
│   └── account-types.ts         # Types, options for dropdowns, labels
├── hooks/
│   ├── useAccountForm.ts        # Validation, submission, state logic
│   └── useAccounts.ts           # Fetching, caching, optimistic update state
├── types/
│   └── accounts.types.ts        # Account entity, payloads, filters
├── utils/
│   └── account-helpers.ts       # Formatting balances, category aggregations
└── accounts-view.tsx            # Main container view rendered by app/accounts/page.tsx
```

---

## 🛡️ Core Rules & Patterns

### 1. Separation of Business Logic from UI

- **Never** place heavy business logic or complex calculation formulas directly inside UI components.
- Encapsulate business calculations and asynchronous workflows inside custom hooks.

```typescript
// Good: Business logic isolated in custom hook
// src/features/budgets/hooks/useBudgetCalculator.ts
import { Budget } from "../types";

export const useBudgetCalculator = (budget: Budget) => {
  const remaining = budget.limit - budget.spent;
  const percentageUsed = Math.min(
    100,
    Math.round((budget.spent / budget.limit) * 100),
  );
  const isOverBudget = remaining < 0;

  return { remaining, percentageUsed, isOverBudget };
};
```

### 2. Component Naming & Organization

- **UI Components:** `PascalCase.tsx` (e.g., `TransactionCard.tsx`, `ConfirmationDialog.tsx`).
- **Hooks & Utilities:** `camelCase.ts` (e.g., `useBudgetCalculator.ts`, `formatCurrency.ts`).
- **Types & Interfaces:** `PascalCase` with descriptive nouns (e.g., `CreateAccountPayload`, `AccountResponse`).
- **Constants:** `UPPER_SNAKE_CASE` (e.g., `DEFAULT_PAGE_SIZE`, `SUPPORTED_CURRENCIES`).

### 3. Server Components vs. Client Components

- Keep pages as **React Server Components (RSC)** by default in Next.js App Router for optimal performance and SEO.
- Add `'use client'` only where interactivity, React hooks (`useState`, `useEffect`, `useContext`), or browser APIs are required (typically on `*-view.tsx` or specific interactive widgets).

### 4. Asynchronous User Feedback & Toast Notifications

- All asynchronous actions (form submissions, deletions, status toggles) **must** provide immediate visual feedback.
- Use a non-blocking toast notification system (e.g., `react-hot-toast` via `ToastProvider`) anchored in the bottom-right corner.
- **Never** use native browser dialogs (`window.alert`, `window.confirm`, `window.prompt`). Use a custom `<ConfirmationDialog />` component for destructive or critical actions.

### 5. Layout Stability & Skeletons

- Always provide skeleton loaders for data-fetching states.
- The skeleton loader **must closely mirror** the final dimensions and grid structure of the loaded content to eliminate Cumulative Layout Shift (CLS).
- Reserve space for predictable inline content (such as form validation error messages) using `min-h-[Xpx]` so fields do not jump when validation fires.
