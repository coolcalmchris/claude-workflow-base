# Use Architectural Decision Records

**Status:** accepted
**Date:** 2026-02-09
**Deciders:** project setup

## Context

As this project grows, architectural and technology decisions accumulate. Without a record of *why* decisions were made, future developers (or Claude sessions) lack the context to evaluate whether a decision still holds — especially when upgrading dependencies or revisiting trade-offs.

Research and brainstorming docs capture exploration, but they don't distill the final decision and its rationale into a stable, findable format.

## Decision

We will use lightweight Architectural Decision Records (ADRs) stored in `docs/decisions/`. Each ADR follows the template at `docs/decisions/000-template.md` and is numbered sequentially (`001-`, `002-`, etc.).

ADRs are created during the **Research** workflow phase whenever a decision has meaningful alternatives or long-term implications. Not every choice needs an ADR — only those where the "why" matters for future maintainability.

ADRs are never deleted. When a decision is reversed, the original ADR is marked `deprecated` or `superseded by [ADR-XXX]`, and a new ADR explains the change.

## Consequences

### Positive

- Future developers can search `docs/decisions/` to understand why the project is structured a certain way
- Dependency upgrades are informed — the original trade-offs are documented
- Claude sessions can read ADRs to avoid re-debating settled decisions

### Negative

- Small overhead to write an ADR during Research phase
- Risk of ADRs going stale if not maintained during major changes

### Neutral

- ADRs complement but don't replace research docs — research is exploratory, ADRs are conclusive
