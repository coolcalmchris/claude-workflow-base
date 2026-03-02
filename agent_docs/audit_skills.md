# Readiness Audit Skills

Interactive skills for auditing the application before deployment. Each skill runs a structured review, produces a severity-categorized report, and suggests fixes.

## Available Skills

| Skill | Command | What it checks |
|-------|---------|---------------|
| Performance | `/audit-performance` | Bundle size, images, CWV, React rendering, DRY, queries, caching, scale |
| Accessibility | `/audit-accessibility` | WCAG 2.1 AA: semantic HTML, keyboard, touch targets, ARIA, contrast |
| Security | `/audit-security` | OWASP Top 10, dependencies, auth, authorization, headers, rate limiting |
| SEO | `/audit-seo` | Meta tags, Open Graph, structured data, URLs, crawlability, SPA rendering |
| E2E Flows | `/audit-e2e` | Critical user flow traces: search, auth, CRUD, import/export |
| All (Orchestrator) | `/audit-all` | Runs all 5 audits in order, produces deployment readiness verdict |

## When to Use

| Scenario | Skill |
|----------|-------|
| Before deploying to staging/production | `/audit-all` |
| After adding new UI components | `/audit-accessibility` |
| After adding new API routes or auth changes | `/audit-security` |
| After performance complaints or bundle growth | `/audit-performance` |
| After adding public-facing pages | `/audit-seo` |
| After major feature additions | `/audit-e2e` |
| Periodic health check | `/audit-all` |

## Report Location

All reports are saved to `docs/audits/YYYY-MM-DD-<category>.md`. The orchestrator produces a summary at `docs/audits/YYYY-MM-DD-deployment-readiness.md`.

## Severity Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **Critical** | Blocks deployment. Exploitable vulnerability, broken flow, or AA violation. | Must fix before deploy. |
| **Warning** | Degrades quality. Security weakness, poor UX, or missing optimization. | Should fix, not blocking. |
| **Info** | Enhancement opportunity. Nice-to-have improvement. | Fix when convenient. |

## Verdict Logic (audit-all only)

- **NOT READY** — Any Critical in Security, Accessibility, or E2E
- **READY WITH WARNINGS** — No Criticals, but Warnings exist
- **READY** — No Criticals or Warnings

## Standards Referenced

Each skill checks against the project's existing standards:

| Skill | Agent Docs Referenced |
|-------|---------------------|
| Performance | `frontend_quality.md`, `code_conventions.md`, `image_optimization.md` |
| Accessibility | `frontend_quality.md` (Accessibility, Modal, Autocomplete sections) |
| Security | `authentication.md`, `service_architecture.md`, `service_communication_patterns.md` |
| SEO | `frontend_quality.md` (SEO section) |
| E2E | `running_tests.md`, `service_communication_patterns.md`, `frontend_quality.md` |
