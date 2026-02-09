# Deferred Quality Gates: Coverage Threshold, Bundle Budget, E2E Tests

**Status:** accepted
**Date:** 2026-02-09
**Deciders:** project setup

## Context

During boilerplate setup, we evaluated six enhancements to improve long-term maintainability and resilience to library upgrades. Three were implemented immediately (ADRs, CI pipeline, dependency update automation). Three were deferred because they require a running application to configure meaningfully.

## Decision

The following quality gates are deferred to specific trigger points rather than configured in the boilerplate:

### 1. Test Coverage Threshold (target: 80%)

**Trigger:** Add during the first feature's Validate phase, once there is a meaningful test baseline.

**What to do:**
- Add `coverage` config to the root Vitest config with `thresholds: { lines: 80, functions: 80, branches: 80 }`
- Add a coverage step to `.github/workflows/ci.yml` using `npm run test -- --coverage`
- Set the threshold to whatever the first feature achieves (but no lower than 80%)

**Why deferred:** Enforcing a coverage threshold on a boilerplate with no application code produces either 100% (trivially) or 0% (no tests yet). The threshold only becomes meaningful once real code exists.

### 2. Bundle Size Budget

**Trigger:** Add after the first production build, once baseline bundle sizes are known.

**What to do:**
- Install `size-limit` and `@size-limit/preset-app` as dev dependencies in `apps/web`
- Add a `.size-limit.json` config based on the initial build output
- Add a size check step to `.github/workflows/ci.yml`

**Why deferred:** Bundle budgets require a baseline measurement. Setting arbitrary limits before the first real build creates either a too-generous budget (useless) or a too-tight one (constant false failures). Measure first, then set the ceiling at baseline + 10%.

### 3. E2E Testing (Playwright)

**Trigger:** Add when the first user-facing flow is complete (e.g., login, checkout, onboarding).

**What to do:**
- Install Playwright in `apps/web`
- Add a `test:e2e` script
- Add an E2E job to `.github/workflows/ci.yml` (runs after build)
- Create initial tests for the critical user flows
- Add E2E patterns to `agent_docs/running_tests.md`

**Why deferred:** E2E tests are only valuable when there are real user flows to test. Adding Playwright to a boilerplate with a placeholder App.tsx provides no value and adds dependency weight. The setup is straightforward enough to add when needed.

## Consequences

### Positive

- Boilerplate stays lean — no premature tooling that needs immediate reconfiguration
- Each gate is added at the moment it can be configured correctly
- Clear trigger points prevent these from being forgotten

### Negative

- Risk of forgetting to add these gates (mitigated by this ADR being searchable)
- First few features ship without these safety nets

### Neutral

- The CI pipeline, Renovate, and ADR convention provide immediate value while these gates wait for their trigger
