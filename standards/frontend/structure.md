# 📁 Frontend Structure Quick Reference

For full architectural guidelines, refer to [Frontend Architecture & Structure Standards](../architecture/frontend-structure.md).

---

## 🗂️ Core Structure at a Glance

```text
apps/web/src/
├── app/                  # Next.js App Router (RSC pages, layouts, route handlers)
├── components/           # Cross-feature shared components
│   ├── ui/               # Primitives (Button, Modal, Input, Badge)
│   ├── shared/           # Compositional blocks (ConfirmationDialog, Navbar)
│   └── feedback/         # Skeletons, empty states, error fallbacks
├── design-system/        # Design system tokens and themes
│   ├── tokens.css        # Semantic color tokens
│   ├── foundations/      # spacing.css, radius.css
│   └── themes/           # light.css, dark.css
├── features/             # Feature-driven modules
│   └── [feature]/        # Domain module (api/, components/, hooks/, types/, view)
├── hooks/                # Global reusable hooks
├── lib/                  # Library wrappers (api-client, fonts)
├── providers/            # Context providers (ToastProvider, AuthProvider)
├── types/                # Global types and domain interfaces
└── utils/                # Pure formatting and calculation utilities
```
