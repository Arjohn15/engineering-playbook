# [Feature Name]

## 📋 Description

Provide a clear and concise description of what this feature does, why it exists, and the user problem or business goal it solves.

---

## 👥 User Roles Involved

Identify which personas/roles interact with or are impacted by this feature:

- **[Role 1]** (e.g., Standard User / Resident / Account Owner)
- **[Role 2]** (e.g., Administrator / Coordinator / Support)
- **[Role 3, if applicable]** (e.g., Responder / Auditor / Guest)

---

## 📖 User Stories

### [Role 1]

#### Story 1: [Short Action-Oriented Title]

> **As a** [Role 1],  
> **I want to** [perform an action],  
> **So that** [achieve an outcome / value].

**Acceptance Criteria**
- [ ] Given [precondition], when [action taken], then [expected result].
- [ ] Condition 1 (e.g., Form validates required fields before submission).
- [ ] Condition 2 (e.g., Success toast notification is displayed).
- [ ] Condition 3 (e.g., Updated item appears immediately in the list).

---

#### Story 2: [Short Action-Oriented Title]

> **As a** [Role 1],  
> **I want to** [perform an action],  
> **So that** [achieve an outcome / value].

**Acceptance Criteria**
- [ ] Condition 1
- [ ] Condition 2

---

### [Role 2] (Admin / Moderator)

#### Story 1: [Short Action-Oriented Title]

> **As an** [Role 2],  
> **I want to** [perform administrative action],  
> **So that** [oversee, moderate, or configure system].

**Acceptance Criteria**
- [ ] Condition 1
- [ ] Condition 2

---

## 🛠️ Technical & Architecture Notes

- **API Endpoints:**
  - `POST /api/v1/[feature]` (Payload: `Create[Feature]Dto`)
  - `GET /api/v1/[feature]` (Query params: pagination, filters)
  - `PATCH /api/v1/[feature]/:id`
  - `DELETE /api/v1/[feature]/:id`
- **Data Model Impact:** Mention any new Prisma models or schema migrations required.
- **Security & Authorization:** Required guards (`@Roles()`, `@Permissions()`, `@CurrentUser()`).
- **UI Components & Skeletons:** Mention required feature components, skeleton loaders, and form validations.

---

## ⚠️ Edge Cases & Future Considerations

- Handling offline scenarios or network drops.
- Error handling (e.g., duplicate entries, rate limits).
- Planned future iterations or out-of-scope items.
