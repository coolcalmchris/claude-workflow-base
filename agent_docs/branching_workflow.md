# Branching Workflow

## Branch Structure

| Branch | Purpose | Deploys? | Push directly? |
|--------|---------|----------|----------------|
| `main` | Production | Yes (auto-deploy) | Never |
| `develop` | Integration/testing | No | Never |
| `feature/*` | Individual features | No | Yes (your branch) |

## Flow

```
feature/my-feature ──PR──▶ develop ──PR──▶ main ──▶ auto-deploy + changelog
```

### Step-by-Step

1. **Start a feature:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/my-feature
   ```

2. **Work on the feature:**
   - Commit using Conventional Commits: `feat(web): add login form`
   - Push to your feature branch: `git push -u origin feature/my-feature`

3. **Open PR to `develop`:**
   ```bash
   gh pr create --base develop --title "feat(web): add login form"
   ```
   - CI runs lint, test, build on PRs to `develop`
   - Review, approve, merge

4. **Test on `develop`:**
   - Multiple features can be merged into `develop` and tested together
   - No auto-deploy — `develop` is for integration testing only

5. **Promote to production:**
   - Open PR from `develop` to `main`
   - CI runs again on the PR
   - After merge: auto-deploy triggers, changelog generates, version tag created

## Rules

- **Never push directly** to `main` or `develop` — always use PRs
- **Always branch from `develop`**, not `main`
- **One PR per feature** — don't bundle unrelated changes
- **Conventional Commits required** — the changelog parses commit messages
- **Keep `develop` stable** — don't merge broken features

## Changelog Process

When `develop` merges into `main`:

1. CI deploys to production
2. `scripts/generate-changelog.ts` runs automatically
3. Parses all commits since the last version tag
4. Groups by type: Features, Fixes, Improvements
5. Updates `CHANGELOG.md` and `apps/web/public/changelog.json`
6. Commits the changelog and creates a date-based tag (e.g., `v2026-02-28`)
7. The `/whats-new` page in the frontend reads `changelog.json`

### Commit types and changelog sections

| Commit type | Changelog section | Example |
|-------------|------------------|---------|
| `feat` | Features | `feat(web): add deck builder` |
| `fix` | Fixes | `fix(api): correct price calculation` |
| `refactor` | Improvements | `refactor(web): simplify card grid` |
| `perf` | Improvements | `perf(api): optimize search query` |
| `chore`, `docs`, `test`, `ci` | (excluded) | Not user-facing |

## Hotfix Flow

For urgent production fixes:

1. Branch from `main`: `git checkout -b hotfix/fix-login main`
2. Fix, commit, PR to `main`
3. After merge to `main`: cherry-pick or merge the fix into `develop`

```bash
git checkout develop
git pull origin develop
git merge main
git push origin develop
```
