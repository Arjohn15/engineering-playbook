# 🎨 Design System & UI/UX Standards

This document outlines the **Design System rules and UI & Interaction Principles** I follow when building user interfaces.

---

## 🎯 Design System Principles

The design system is my central reference for visual properties, colors, spacing, typography, and interactive behaviors.

- **Tokens over Arbitrary Values:** Avoid hardcoding arbitrary hex colors, pixel dimensions, or ad-hoc Tailwind classes.
- **Semantic Theming:** Use semantic tokens mapped to CSS variables (e.g., `var(--color-primary)` or Tailwind v4 `@theme` mappings) so themes (Light / Dark) switch cleanly without breaking.
- **Consistent Polish:** Interfaces should feel fluid, responsive, accessible, and intentional across desktop, tablet, and mobile.

---

## 🎨 Token Architecture

### 1. Color Tokens (`tokens.css`, `themes/*.css`)

- **DO NOT** use raw hex codes (e.g., `bg-[#e11d48]`) or default arbitrary Tailwind colors (e.g., `text-blue-500`) for primary UI surfaces and text.
- **DO** use semantic color tokens:
  - `primary`, `primary-hover`, `primary-subtle`, `primary-foreground`
  - `success`, `danger`, `warning`, `info` (along with `-hover` and `-subtle` variants)
  - `background`, `background-subtle`, `foreground`, `foreground-muted`
  - `border`, `border-muted`, `border-focus`
- **Example:**
  ```tsx
  // Good: Semantic design tokens
  <button className="bg-primary hover:bg-primary-hover text-primary-foreground transition-colors duration-200">
    Save Changes
  </button>
  ```

### 2. Typography Standards (`components.css` / `@theme`)

- **DO NOT** use arbitrary font sizes or arbitrary font weights (e.g., `text-[13px] font-extrabold`).
- **Allowed Font Weights:** Only use `normal`, `semibold`, and `bold` (e.g., `font-normal`, `font-semibold`, `font-bold`). Avoid using `font-medium`, `font-light`, etc., unless explicitly required by a validated typographic hierarchy.
- **Semantic Typography Classes:**
  - **Display:** `display-large`, `display-medium`, `display-small`
  - **Title:** `title-large`, `title-medium`, `title-small`
  - **Body:** `body-large`, `body-medium`, `body-small`, `body-xsmall`

### 3. Spacing & Radius Foundations

- **Spacing:** Standard token scale ranges from `none`, `xs`, `sm`, `md`, `lg`, `xl`, `2xl`, to `5xl`. Use these with Tailwind margin/padding utilities (e.g., `p-md`, `mt-xl`, `gap-sm`).
- **Radius:** Standard token scale ranges from `none`, `sm`, `md`, `lg`, `xl`, to `full`. Use with Tailwind rounding utilities (e.g., `rounded-md`, `rounded-full`).

---

## 🌟 15 UI & Interaction Principles

To keep interfaces polished and accessible across different screen sizes, I follow these 15 principles:

### 1. Consistent Interactive Feedback

Every interactive element (buttons, links, cards, list items, checkboxes, dropdown items) **must** provide clear visual feedback across `hover`, `focus-visible`, and `active` states. Use context-aware styling (destructive actions must have destructive hovers, not generic gray). Ensure the correct semantic cursor is applied (e.g., `cursor-pointer`).

### 2. Smooth Transitions

State changes must never feel abrupt or jarring. Always pair hover, focus, and state modifications with smooth transition utilities:

```tsx
className = "transition-all duration-200 ease-in-out";
```

### 3. Selective Layout Shift Prevention

- **DO** reserve space for predictable inline content (such as form validation error messages or helper text beneath inputs) using `min-h-[20px]` so forms do not jump when validation messages toggle.
- **DO NOT** permanently reserve blank space for transient UI elements like global alerts, toasts, or temporary announcement banners where an empty box creates awkward white gaps. Let them render conditionally with enter/exit transitions.

### 4. Realistic Skeleton Loaders

Skeleton loaders must serve as a 1:1 preview of the final rendered content. If displaying a 3-column card grid, the loading state must render an identical 3-column skeleton grid with matching aspect ratios, preventing layout shifts when data arrives.

### 5. Color Contrast & Readability

All text and essential graphics must meet or exceed WCAG 2.1 AA contrast requirements (minimum 4.5:1 for normal text). Pay close attention to active or checked states: text on light accent backgrounds must remain dark/primary rather than white.

### 6. Entity Formatting

Display system entity names, statuses, and roles (e.g., `admin`, `coordinator`, `pending`, `verified`) in **Title Case** in the user interface. Prefer using CSS utilities like `capitalize` directly in markup rather than mutating the underlying data layer.

### 7. Custom Confirmation Dialogs (No Native Dialogs)

**Never** use native browser dialogs (`window.alert`, `window.confirm`, `window.prompt`). They block the browser main thread and break design consistency. Always use a dedicated, accessible, reusable modal component (e.g., `<ConfirmationDialog />`).

### 8. Contextual Primary Actions

Place primary actions (e.g., "Add New Account", "New Incident Report") in the contextual sticky header or toolbar of the feature they belong to, rather than floating them globally above the viewport. This ensures actions remain accessible during deep scrolling.

### 9. Resource Discoverability & Ordering

Newly created or modified resources should be surfaced prominently (e.g., prepending the new item to the top of the table/list or highlighting it) to provide instant confirmation to the user.

### 10. Role-Based Access Control (RBAC) in UI

- Guard frontend routes and views based on verified user roles/permissions.
- Only expose UI controls (buttons, menus) that the user has permission to execute.
- Do not invent artificial permission entities in the UI - mirror actual system feature boundaries.

### 11. Toast Notifications for User Feedback

All asynchronous operations (saving, deleting, syncing) must notify the user of success or failure using non-blocking toast notifications (e.g., `react-hot-toast` via `ToastProvider`). Toasts should be positioned in the bottom-right corner.

### 12. Modular Landing Page Architecture

Public and landing pages must be broken down into clean, reusable section components (`HeroSection`, `FeaturesSection`, `FAQSection`, `CTASection`). Avoid monolithic page files. Ensure full responsiveness across mobile, tablet, and desktop viewports with optimized assets (`next/image`).

### 13. Workspace & Data-Heavy Interfaces

Workspace pages with tables, sidebars, or maps should use fixed viewport layouts with independently scrollable panels (`overflow-y-auto`). Modals containing large forms must have constrained viewport heights (`max-h-[85vh]`) with internal scrolling.

### 14. Avoid Arbitrary `max-w-*` Constraints

**Do NOT** indiscriminately sprinkle Tailwind classes like `max-w-xs`, `max-w-sm`, `max-w-md`, or `max-w-lg` onto dialogs, cards, forms, titles, or paragraphs simply to force width constraints.

- Excessive artificial width constraints cause unnatural text wrapping, wasted screen space, and cheap-looking cramped interfaces.
- Dialogs, cards, and forms should size naturally based on content and responsive grid/flex layouts.
- **Only use `max-w-*` when there is a deliberate UX reason**, such as enforcing optimal reading measure (65-75 characters) on long-form documentation or articles.

### 15. Offline & Storage Gracefulness (PWA Ready)

Where offline capability or local caching is supported (e.g., via IndexedDB or Service Workers), interfaces must gracefully display offline indicators and queue mutations without freezing the main thread.
