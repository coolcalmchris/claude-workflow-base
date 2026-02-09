# Dependency Updates

Read this when reviewing Renovate PRs, manually updating dependencies, or evaluating whether to adopt a new library.

## Automated Updates (Renovate)

Renovate is configured in `renovate.json` at the project root. It runs weekly (Monday mornings) and creates PRs for outdated dependencies.

### Update Strategy

| Update type | Behavior | Review required |
|-------------|----------|-----------------|
| Patch (`1.0.x`) | Grouped into one PR, auto-merged if CI passes | No |
| Minor (`1.x.0`) | Grouped into one PR | Yes — scan changelog for breaking behavior changes |
| Major (`x.0.0`) | Individual PRs per package | Yes — read migration guide, check for breaking changes |
| Dev dependencies | Grouped, auto-merged if CI passes | No |

### Grouped Packages

Related packages are updated together to avoid version mismatches:
- **React**: `react`, `react-dom`, `@types/react*`
- **Prisma**: `prisma`, `@prisma/client`
- **Linting**: `eslint`, `prettier`, `@typescript-eslint/*`

## Reviewing Update PRs

### For minor updates

1. Read the PR description (Renovate includes changelog links)
2. Check if CI passes (lint, test, build)
3. If CI passes and changelog has no behavioral changes, merge

### For major updates

1. Read the migration guide linked in the PR
2. Check for breaking API changes that affect our code
3. Search the codebase for deprecated APIs mentioned in the migration guide
4. Run the app locally and smoke-test key flows
5. If the update requires code changes, create a feature branch from the Renovate PR branch and make the changes there
6. Create an ADR in `docs/decisions/` documenting the upgrade rationale and any migration steps taken

## Manual Updates

When manually updating a dependency:

```bash
# Check what's outdated
npm outdated

# Update a specific package
npm install <package>@latest -w <workspace>

# Example: update React in the web app
npm install react@latest react-dom@latest -w apps/web
```

After any manual update, run the full validation suite:

```bash
npm run lint && npm run test && npm run build
```

## Adding New Dependencies

Before adding a new dependency, evaluate:

1. **Is it necessary?** Can the functionality be achieved with existing dependencies or a small utility?
2. **Is it maintained?** Check last publish date, open issues, and bus factor
3. **What's the bundle impact?** Check size on [bundlephobia.com](https://bundlephobia.com/)
4. **Does it have types?** Prefer packages with built-in TypeScript types over `@types/*`
5. **License compatibility?** Must be MIT, Apache 2.0, or BSD

Install to the correct workspace:

```bash
# Frontend dependency
npm install <package> -w apps/web

# Backend dependency
npm install <package> -w apps/api

# Shared dependency
npm install <package> -w packages/shared

# Dev dependency (root)
npm install -D <package> -w .
```
