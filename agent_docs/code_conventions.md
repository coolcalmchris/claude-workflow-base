# Code Conventions

## TypeScript

- **Strict mode** enabled in all `tsconfig.json` files.
- Never use `any`. Use `unknown` + type narrowing when the type is truly dynamic.
- Prefer `interface` for object shapes, `type` for unions/intersections.
- Use explicit return types on exported functions.

## File Organization

- **One component/module per file.** Max ~200 lines.
- **Named exports only.** No default exports.
- Filename matches the primary export: `UserCard.tsx` exports `UserCard`.
- Group by feature, not by type:
  ```
  features/
    auth/
      LoginForm.tsx
      LoginForm.test.tsx
      useAuth.ts
      auth.api.ts
  ```

## Naming

| Thing | Convention | Example |
|-------|-----------|---------|
| Components | PascalCase | `UserCard` |
| Hooks | camelCase, `use` prefix | `useAuth` |
| Utilities | camelCase | `formatDate` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRIES` |
| Types/Interfaces | PascalCase | `UserProfile` |
| Files (components) | PascalCase | `UserCard.tsx` |
| Files (non-component) | camelCase | `formatDate.ts` |
| CSS classes | Tailwind utilities or SASS BEM | `.card__header` |

## React

- Functional components only.
- Colocate state as close to usage as possible.
- Extract hooks when logic is reused or complex.
- Props interface named `<ComponentName>Props`.
- Avoid prop drilling past 2 levels — use Zustand or context.

## Styling

- **TailwindCSS** for utility-first styling (primary).
- **SASS modules** (`*.module.scss`) for complex/reusable component styles.
- Never use inline `style` objects.
- Keep Tailwind class lists readable — extract to variables or use `clsx`/`cn` when >4 classes.

## Imports

Order (enforced by ESLint):

1. External packages (`react`, `express`, etc.)
2. Internal aliases (`@web/`, `@api/`, `@shared/`)
3. Relative imports (`./`, `../`)

Blank line between each group.

## Error Handling

- API layer: catch errors in middleware, return consistent error shapes.
- Frontend: use error boundaries for render errors, try/catch for async.
- Never silently swallow errors. Log or propagate.

## Frontend Quality

All user-facing components must meet accessibility (WCAG 2.1 AA), responsive design, and performance standards. See `agent_docs/frontend_quality.md` for full details, checklist, and testing requirements.

## Backend Conventions (Full Stack)

API and database code follow additional conventions for service architecture, error handling, input validation, and security. See `agent_docs/service_architecture.md`, `agent_docs/service_communication_patterns.md`, and `agent_docs/database_schema.md`.

## DRY (Don't Repeat Yourself)

When the same logic, markup, or pattern appears in 3+ places, extract it:

| Repeated thing | Extract to | Example |
|----------------|-----------|---------|
| Utility logic (formatting, URL construction) | `lib/` function | `formatPrice`, `getImageUrl` |
| UI pattern (markup + styling) | `components/ui/` component | `ModalOverlay`, `CardGridSkeleton` |
| Store boilerplate (fetch/loading/error) | `lib/` helper | `withLoading` wrapper |
| Near-identical pages/stores | Factory function or shared component | `FilteredListPage` |

**Guidelines:**
- Extract when a pattern is repeated 3+ times, or 2 times if the logic is non-trivial.
- Use design tokens (CSS custom properties via Tailwind) instead of hardcoded hex values.
- Shared components live in `components/ui/`. Feature-specific shared components live in the feature folder.
- Keep extracted components focused — one responsibility per component.
- When extracting, ensure all call sites are updated (no orphaned duplicates).

## Search Inputs

All search input fields must include a `Search` icon (from `lucide-react`) positioned to the left of the placeholder text. Use the following pattern:

```tsx
<div className="relative">
  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
  <input
    ...
    className="w-full pl-9 pr-3 py-2 ..."
  />
</div>
```

**Exception:** Search bars that have a dedicated search button (e.g., a site-wide header search) do not need the inline icon since the button already provides the affordance.

## Select Dropdowns

All `<select>` elements must use `appearance-none` with a `ChevronDown` SVG icon (from `lucide-react`) and a relative wrapper. Use the following pattern:

```tsx
<div className="relative">
  <select
    ...
    className="w-full appearance-none pl-2.5 pr-8 py-1.5 text-sm rounded border border-border bg-card text-text-primary cursor-pointer focus:outline-none focus:ring-1 focus:ring-primary"
  >
    {options}
  </select>
  <ChevronDown className="absolute right-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-text-muted pointer-events-none" />
</div>
```

Never use a bare `<select>` without this wrapper — the native browser chevron is inconsistent across platforms.

## Comments

- Don't comment *what* the code does — make the code self-explanatory.
- Comment *why* when the reason isn't obvious.
- Use `// TODO:` for known follow-ups. Include context.
