# CLAUDE.md

## Tech Stack

| Layer | Technology | Required |
|-------|-----------|----------|
| Monorepo | Turborepo, npm workspaces | Always |
| Frontend | React, TypeScript, Vite, TailwindCSS, SASS, Zustand | Always |
| Backend | Express, TypeScript | Optional |
| Database | PostgreSQL, Prisma ORM | Optional |
| Local DB | Docker Compose (PostgreSQL container) | Optional |
| Testing | Vitest | Always |
| Linting | ESLint + Prettier | Always |
| CI | GitHub Actions (lint, test, build) | Always |
| Runtime | Node (latest LTS) | Always |

This boilerplate supports two project scales:
- **Frontend only** — `apps/web` only. No API, no database.
- **Full stack** — `apps/web` + `apps/api` + `packages/shared` + PostgreSQL.

When starting a new project from this boilerplate, decide which scale applies and omit what isn't needed.

## Project Structure

```
apps/
  web/            # React SPA (Vite) — always present
  api/            # Express API server — full stack only
packages/
  shared/         # Shared types, utils, constants — full stack only
agent_docs/       # Task-specific instructions (see below)
docs/
  research/       # Research and brainstorming docs (Superpowers output)
  plans/          # Implementation plans (Superpowers output)
  decisions/      # Architectural Decision Records (ADRs)
.github/workflows/ # CI pipeline (lint, test, build)
```

## Workflow

This project uses the [Superpowers](https://github.com/obra/superpowers) plugin. Every task follows four phases — Superpowers skills handle the process. Do not skip phases.

> **HARD RULE:** For any significant feature (new page, new model, multi-file change, or user-presented design concept), invoke `superpowers:brainstorming` BEFORE any other response — before exploring code, before asking questions, before proposing approaches. This applies even in long sessions after context compaction. Bug fixes, lint cleanup, and small tweaks are exempt.

1. **Research** — Use `superpowers:brainstorming`. Read `agent_docs/`, explore the codebase, ask clarifying questions. Design doc saved to `docs/research/`. Create an ADR in `docs/decisions/` for any decision with meaningful alternatives.
2. **Plan** — Use `superpowers:writing-plans`. Break work into small tasks with exact file paths and code. Plan saved to `docs/plans/`.
3. **Implement** — Use `superpowers:executing-plans` or `superpowers:subagent-driven-development`. Follow TDD (`superpowers:test-driven-development`). Commit after completing implementation.
4. **Validate** — Use `superpowers:verification-before-completion`. Evidence before claims. All lint, tests, and build must pass. CI runs automatically on PRs. Use `superpowers:finishing-a-development-branch` to merge or PR.

### Documentation Requirements (Mandatory)

The brainstorming skill saves its output to `docs/plans/` by default. **Override this** — save the research/design doc to `docs/research/YYYY-MM-DD-<topic>.md` instead. The implementation plan (from `writing-plans`) goes to `docs/plans/`.

Every feature MUST produce these artifacts before implementation begins:

| Artifact | Location | Created During | Required? |
|----------|----------|---------------|-----------|
| Research/design doc | `docs/research/YYYY-MM-DD-<topic>.md` | Phase 1 (Research) | Yes, for all features |
| ADRs | `docs/decisions/NNN-<title>.md` | Phase 1 (Research) | Yes, for any decision with meaningful alternatives |
| Implementation plan | `docs/plans/YYYY-MM-DD-<feature>.md` | Phase 2 (Plan) | Yes, for all features |

**Enforcement:** Do not create a feature branch or write implementation code until the research doc and plan exist. If a plan is provided externally (e.g., pasted into the conversation), save it to `docs/plans/` before executing. If research was done in a prior session, backfill the research doc and ADRs in the first implementation commit.

**What qualifies as an ADR:** Any choice where you considered (or should have considered) an alternative. Examples: library selection, architectural patterns, data modeling decisions, API design choices, scheduling strategies. When in doubt, write the ADR — a short ADR is better than none.

**Commit timing for docs:** Research and plan docs are committed with the first implementation commit on the feature branch (not separately to `main`).

## Implementation Guards

### Blast Radius Check
Before modifying any function or component, grep for all callers/importers. If callers span 3+ modules, note the blast radius and verify a caller from each module after the change.

### Proactive Checkpoint
After every 5 implementation steps (or when context feels heavy), write a checkpoint to `.claude/memory/sessions/.current-checkpoint.md`:
- Success criteria status (done vs remaining)
- Files changed so far
- Current step and what's next

This ensures continuity if context compression occurs mid-task.

### Guardrails
Read `.claude/memory/guardrails.md` before complex tasks. PERMANENT entries always apply. When the user corrects an approach or a failure is identified, add a guardrail entry with date, severity, trigger, and rule.

## Model Routing

When spawning subagents (Task tool), select the model by task complexity:

| Task type | Model | Examples |
|-----------|-------|---------|
| Research, architecture, complex analysis | `opus` | Brainstorming, design review, debugging complex issues |
| Code implementation | `sonnet` | Writing features, tests, refactors from a plan |
| File search, lookups, simple commands | `haiku` | Grep/glob exploration, running lint/build/test |

**Rule:** Default to `sonnet` for subagents. Escalate to `opus` only when the task requires cross-cutting reasoning or architectural judgment. Use `haiku` for read-only exploration and command execution.

The main conversation model is user-controlled (`/model` to switch). Use Opus for Research and Plan phases, Sonnet for Implement and Validate.

## Git

- **Branches:**
  - `main` — production. Auto-deploys on push. Never push directly.
  - `develop` — integration/testing. All feature branches merge here first.
  - `feature/<short-description>` — one per feature (e.g., `feature/add-login-form`)
- **Flow:** `feature/*` → PR to `develop` → local testing → PR from `develop` to `main` → auto-deploy + changelog
- **Creating a feature branch:** Always branch from `develop`, not `main`.
- **Merging:** Feature branches PR into `develop`. Only `develop` PRs into `main`.
- **Never push directly to `main` or `develop`.** All changes via PR.
- **Commits at:** Implement and Validate phases only. Research/plan/decision docs are committed with the first implementation commit on the feature branch.
- **Commit format:** [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): description`
  - Types: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`
  - Scope = app or package name: `web`, `api`, `shared`
  - Example: `feat(web): add user login form`
- **Releases:** Date-based tags (e.g., `v2026-02-28`) auto-created on merge to `main`. Changelog auto-generated.

## Commands

```bash
npm run dev          # Start all apps (turbo)
npm run build        # Build all apps
npm run lint         # Lint + format check
npm run test         # Run all tests
npm run test:watch   # Watch mode
```

## Conventions (Quick Reference)

- TypeScript strict mode. No `any`.
- Small files (<200 lines). One component/module per file.
- Colocate tests: `foo.ts` -> `foo.test.ts`
- Named exports over default exports.
- Path aliases: `@web/`, `@api/`, `@shared/`

For full conventions, see `agent_docs/code_conventions.md`.

## Agent Docs (Progressive Disclosure)

Before starting a task, consult the relevant doc in `agent_docs/`:

| Doc | When to read |
|-----|-------------|
| `building_the_project.md` | Build setup, scripts, env config |
| `running_tests.md` | Writing or running tests |
| `code_conventions.md` | Any code change |
| `service_architecture.md` | Adding/modifying services or packages |
| `database_schema.md` | Schema changes, migrations, seeding |
| `service_communication_patterns.md` | API contracts, request/response patterns |
| `frontend_quality.md` | Accessibility, responsive design, performance, SEO |
| `image_optimization.md` | Responsive variants, ThumbHash placeholders, upload processing |
| `authentication.md` | Adding auth (JWT, middleware, roles, token strategy) |
| `dependency_updates.md` | Reviewing Renovate PRs, adding/updating dependencies |
| `memory_system.md` | Memory architecture, commands, entry format, rules |
| `audit_skills.md` | Running readiness audits (performance, accessibility, security, SEO, E2E) |
| `branching_workflow.md` | Branching strategy, release flow, changelog process |

## Memory

Persistent memory at `.claude/memory/` is managed automatically via hooks. Commands:

| Command | What it does |
|---------|-------------|
| `/remember` | Extract and save context from the current conversation |
| `/recall [topic]` | Search memory tree for relevant context |
| `/memory-status` | Show stored memory count by domain |

See `agent_docs/memory_system.md` for architecture and hook details.
