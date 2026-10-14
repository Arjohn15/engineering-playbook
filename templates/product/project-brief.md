# 📄 Project Brief Template

A high-level project brief that sets the vision, scope, users, technical boundaries, and milestones before architecture and development begin.

---

## 📌 Executive Summary

- **Project Name:** [e.g., My Application / System Name]
- **Target Launch Date:** [e.g., Q4 2026]
- **Project Lead / Owner:** [Name]
- **Repository / Monorepo:** [GitHub / GitLab repo link]
- **One-Line Pitch:** [A clear 1-sentence description of the system's core value proposition.]

---

## 🎯 Problem Statement & Product Vision

### The Problem

What friction, pain point, inefficiency, or manual work exists today?

> [Describe the specific pain point experienced by users or the business.]

### The Solution & Vision Statement

```text
For [target audience],
Who [have a specific problem or need],
The [Product Name] is a [product category]
That [provides primary benefit / key value].
Unlike [current alternatives or manual process],
This product [key differentiator and competitive advantage].
```

---

## 👥 Target Users & Personas

| Persona              | Role & Description                   | Primary Goal                       | Key Frustration                          |
| :------------------- | :----------------------------------- | :--------------------------------- | :--------------------------------------- |
| **Primary User**     | [e.g. Household budgeter / Resident] | [e.g. Track monthly cash flow]     | [e.g. Overcomplicated spreadsheets]      |
| **Admin / Operator** | [e.g. Support lead / Command Center] | [e.g. Monitor operational metrics] | [e.g. Fragmented communication channels] |

---

## 📦 Scope & Core Capabilities

### In-Scope (MVP & Core Features)

- [ ] **Feature Area 1:** [Description]
- [ ] **Feature Area 2:** [Description]
- [ ] **Feature Area 3:** [Description]
- [ ] **Feature Area 4:** [Description]

### Explicitly Out-of-Scope (Phase 2+ / Guardrails)

- ❌ [Feature or complexity deliberately deferred to prevent scope creep]
- ❌ [Non-essential integrations]

---

## 🏗️ Technology & Architecture Stack

| Layer               | Selected Technology                                 | Rationale                                                      |
| :------------------ | :-------------------------------------------------- | :------------------------------------------------------------- |
| **Frontend**        | Next.js (App Router), React, Tailwind CSS v4        | Server-rendered performance, design token system               |
| **Backend**         | NestJS, TypeScript, Node.js                         | Modular architecture, strict type safety, dependency injection |
| **Database**        | PostgreSQL + Prisma ORM                             | Relational integrity, migrations, type-safe queries            |
| **Hosting & Infra** | Vercel (Web), AWS ECS / Fargate (API), AWS RDS (DB) | Serverless edge frontend with scalable containerized backend   |
| **Local Dev**       | Docker Compose                                      | Reproducible local PostgreSQL & services                       |

---

## 📊 Success Metrics & KPIs

How will success be measured?

- **Metric 1:** [e.g., 90% of active users log at least 3 transactions per week]
- **Metric 2:** [e.g., Average incident response dispatch time reduced under 5 minutes]
- **Metric 3:** [e.g., 99.9% uptime and API response times under 200ms]

---

## 🗓️ Delivery Phases & Milestones

1. **Phase 1: Discovery & Architecture** (C4 diagrams, ERD, API OpenAPI spec, design tokens)
2. **Phase 2: Core Platform & Auth** (Accounts, authentication, RBAC, base layouts)
3. **Phase 3: Domain Features** (Feature-driven modules, services, user workflows)
4. **Phase 4: Hardening & Testing** (Unit tests, e2e tests, accessibility, load tests)
5. **Phase 5: Production Deployment & Monitoring** (CI/CD pipeline, logging, alerting)
