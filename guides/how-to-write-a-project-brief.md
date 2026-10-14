# ✍️ How to Write a Project Brief

A project brief defines the problem, scope, and technical direction before architecture or code begins. Writing one early keeps goals clear and prevents scope creep.

---

## 🧭 Step-by-Step Guide

### 1. Identify the Core User & The Core Pain Point

- Don't start with features or technology stacks.
- Start with who is suffering from a problem and how they currently solve it.
- _Example (Finance / Budgeting App):_ Users struggle to build savings habits because existing finance apps are bloated with ads, require manual banking synchronization, and lack intuitive envelope budgeting.
- _Example (Emergency Coordination Platform):_ Field responders and residents during crises face congested telephone lines and delayed dispatch due to lack of real-time coordinate plotting.

### 2. Draft the Vision Statement

Use Geoffrey Moore's classic positioning formula:

```text
For [target customer]
Who [statement of the need or opportunity]
The [product name] is a [product category]
That [key benefit, reason to buy]
Unlike [primary competitive alternative]
This product [statement of primary differentiation]
```

### 3. Draw a Hard Boundary Around Scope

- Every strong project brief has an **In-Scope** list and an **Explicitly Out-of-Scope** list.
- If a feature isn't strictly necessary for the MVP to deliver its core promise, put it in the "Out of Scope (Phase 2+)" section.
- This protects engineering velocity and keeps delivery dates realistic.

### 4. Choose the Architecture & Tech Stack Intentionally

The standard stack I default to:

- **Frontend:** Next.js (App Router), React, Tailwind CSS v4, Custom Design System
- **Backend:** NestJS, TypeScript, Prisma ORM
- **Database:** PostgreSQL
- **Infrastructure:** Docker Compose (local), Vercel + AWS (production)

### 5. Define Measurable Success Metrics (OKRs / KPIs)

Avoid vague statements like "The app should be fast and easy to use."  
Write measurable criteria:

- User onboarding completed in `< 60 seconds`.
- 95% of API requests respond in `< 150ms`.
- System maintains 99.9% uptime during peak loads.

---

## 🔗 Related Resources

- Template: [Project Brief Template](../templates/product/project-brief.md)
- Notion Project Template: [Notion Project Master Template](../templates/product/notion-project-template.md)
