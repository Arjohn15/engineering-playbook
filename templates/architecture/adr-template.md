# [ADR-0000] [Short Title of Architectural Decision]

- **Status:** Proposed | Accepted | Deprecated | Superseded by [ADR-XXXX]
- **Date:** YYYY-MM-DD
- **Deciders:** [List everyone involved in the decision]
- **Consulted:** [Stakeholders consulted]
- **Informed:** [Team members informed]

---

## 1. Context and Problem Statement

Describe the context and problem that requires an architectural decision:

- What technical or business requirements are prompting this decision?
- What are the constraints (budget, timeline, existing stack, scalability, developer ergonomics)?

---

## 2. Decision Drivers

- Driver 1 (e.g., Strict type safety across client and server)
- Driver 2 (e.g., Sub-100ms API response latency)
- Driver 3 (e.g., Ease of maintenance and team familiarity)
- Driver 4 (e.g., Zero breaking database schema migrations)

---

## 3. Considered Options

1. **Option 1:** [Name of option] (e.g., NestJS + Prisma ORM + PostgreSQL)
2. **Option 2:** [Name of option] (e.g., Express + TypeORM + PostgreSQL)
3. **Option 3:** [Name of option] (e.g., Fastify + Kysely + PostgreSQL)

---

## 4. Decision Outcome

**Chosen Option:** **[Option 1]**, because:

- [Key positive argument 1]
- [Key positive argument 2]
- [Key positive argument 3]

### Positive Consequences

- [Positive consequence 1]
- [Positive consequence 2]

### Negative Consequences / Trade-offs

- [Trade-off or limitation 1]
- [Mitigation strategy for trade-off]

---

## 5. Pros and Cons of the Options

### [Option 1: Chosen Option]

- **Good:** [Advantage 1]
- **Good:** [Advantage 2]
- **Bad:** [Disadvantage or complexity 1]

### [Option 2: Alternative Option]

- **Good:** [Advantage 1]
- **Bad:** [Why it was rejected]

### [Option 3: Alternative Option]

- **Good:** [Advantage 1]
- **Bad:** [Why it was rejected]

---

## 6. Implementation Notes & Follow-up

- Any necessary libraries, scripts, or boilerplates to adopt.
- Action items or PRs needed to implement this decision.
