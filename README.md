# 🧠 Engineering Playbook

A personal, evolving collection of **standards, architecture blueprints, templates, and guidelines** to build consistent, maintainable full-stack applications efficiently.

This is my personal reference for reusable patterns, project architectures, and engineering workflows across my projects.

---

## 📌 Purpose

- **Personal Reference:** Keep my architectural, coding, and UI conventions organized in one place.
- **Speed & Consistency:** Scaffold new frontend and backend modules using proven blueprints without starting from scratch.
- **Quality Guardrails:** Follow strict type safety, RFC 7807 problem details, design system tokens, and accessibility principles.
- **Living Knowledge Base:** Evolve and refine patterns, decision records, and prompts as I build more software.

---

## ⚡ My Standard Stack

The core technologies and conventions I use across projects:

| Layer | Standard Technologies | Key Conventions |
| :--- | :--- | :--- |
| **Frontend** | Next.js (App Router), React, TypeScript | Feature-driven modules, custom hooks isolating business logic, Server vs. Client component boundaries |
| **Styling & UI** | Tailwind CSS v4, Semantic Design Tokens | `@theme` CSS variable tokens, 15 Global UI Principles, strict typography & font weight rules |
| **Backend** | NestJS, TypeScript, Node.js | Modular architecture, thin controllers, fat services, RFC 7807 Problem Details, centralized RBAC guards |
| **Persistence** | PostgreSQL, Prisma ORM | Relational integrity, migrations, atomic transactions via `prisma.$transaction()` |
| **API & Docs** | REST (`/api/v1`), OpenAPI 3.0, C4 Structurizr | Formal contracts, OpenAPI specs, Structurizr DSL architecture models |
| **Environment** | Docker Compose, Monorepos | Local containerized PostgreSQL, segregated `.env` hierarchies |

---

## 📂 Repository Layout

```text
engineering-playbook/
│
├── standards/                                   # Core engineering standards
│   ├── architecture/
│   │   ├── backend-structure.md                 # NestJS + Prisma backend architecture & folders
│   │   └── frontend-structure.md                # Next.js App Router frontend architecture & folders
│   ├── backend/
│   │   └── coding.md                            # Backend TypeScript conventions & rules
│   ├── frontend/
│   │   ├── coding.md                            # Frontend TypeScript & React rules (No `any`)
│   │   └── structure.md                         # Quick reference for frontend layout
│   └── design/
│       └── ui-standards.md                      # Design system tokens & 15 Global UI Principles
│
├── templates/                                   # Reusable starter files & blueprints
│   ├── architecture/
│   │   ├── adr-template.md                      # Architecture Decision Record (ADR)
│   │   └── c4-workspace-template.dsl            # Structurizr DSL C4 architecture template
│   ├── api/
│   │   └── openapi-starter.yaml                 # OpenAPI 3.0 spec starter with RFC 7807
│   ├── backend/
│   │   └── nest-module-blueprint.md             # NestJS feature module scaffolding blueprint
│   ├── frontend/
│   │   └── feature-module-blueprint.md          # Next.js feature folder scaffolding blueprint
│   ├── documentation/
│   │   └── features/
│   │       └── feature-template.md              # Feature specification & user stories template
│   ├── product/
│   │   ├── project-brief.md                     # High-level product brief template
│   │   └── notion-project-template.md           # 12-section Agile Notion workspace template
│   ├── prompts/
│   │   └── requirements-elicitation-template.txt # AI prompt template for requirements discovery
│   └── workflow/
│       ├── agents/
│       │   └── requirements_elicitation_agent.yaml
│       └── prompts/
│           └── requirements_elicitation_prompt.txt
│
└── guides/                                      # How-to guides and tutorials
    ├── monorepo-workflow.md                     # Monorepo architecture, Docker Compose & .env
    ├── how-to-write-a-project-brief.md          # Guide to scoping and framing projects
    └── c4-modeling-guide.md                     # Guide to modeling systems with Structurizr DSL
```

---

## 🚀 How I Start a New Project

1. **Scope & Vision:** Draft the [Project Brief Template](templates/product/project-brief.md) or set up the [Notion Project Master Template](templates/product/notion-project-template.md).
2. **Requirements Gathering:** Run the [Requirements Elicitation Agent](templates/workflow/agents/requirements_elicitation_agent.yaml) to map stakeholder needs and current-state operations.
3. **Architecture Modeling:** Copy the [C4 Structurizr Template](templates/architecture/c4-workspace-template.dsl) to map Context, Containers, and Deployment views.
4. **API Specification:** Define endpoint contracts using the [OpenAPI Starter](templates/api/openapi-starter.yaml).
5. **Implementation:**
   - Set up backend modules following the [Backend Structure Standards](standards/architecture/backend-structure.md) and the [NestJS Module Blueprint](templates/backend/nest-module-blueprint.md).
   - Set up frontend features following the [Frontend Structure Standards](standards/architecture/frontend-structure.md) and the [Next.js Feature Blueprint](templates/frontend/feature-module-blueprint.md).
   - Follow the [Design System & UI Standards](standards/design/ui-standards.md) for components and interaction feedback.
