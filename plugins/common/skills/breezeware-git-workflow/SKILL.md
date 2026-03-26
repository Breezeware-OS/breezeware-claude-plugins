---
name: breezeware-git-workflow
description: >
  Generate PR descriptions, changelogs, release notes, and commit messages
  following Breezeware conventions. Use this skill when the user asks to
  "write a PR description", "generate changelog", "release notes", "describe
  these changes", "commit message", or needs help with any git workflow
  documentation.
---

# Git Workflow Skill

## PR Description Template

When generating a PR description, read the diff first, then produce:

```markdown
## What

[1-2 sentence summary of what changed and why]

## Changes

- [specific change 1 with file context]
- [specific change 2]
- [specific change 3]

## How to Test

1. [Step-by-step testing instructions]
2. [Expected behavior]
3. [Edge cases to verify]

## Screenshots / Recordings

[If UI changes — include before/after or describe what to look for]

## Checklist

- [ ] Tests added/updated
- [ ] API docs updated (if endpoint changed)
- [ ] Migration is reversible
- [ ] No breaking changes (or documented in changelog)
- [ ] Reviewed own diff before requesting review
```

## Commit Message Format

Follow Conventional Commits:

```
<type>(<scope>): <short description>

[optional body — what and why, not how]

[optional footer — BREAKING CHANGE: or Closes #123]
```

**Types**: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `style`

**Examples**:
```
feat(auth): add OAuth2 login with Google provider

Implements Google OAuth2 flow using passport-google-oauth20.
Tokens are stored encrypted in the session store.

Closes #247
```

```
fix(api): prevent duplicate user creation on race condition

Added a unique constraint check with retry logic to handle
concurrent POST /users requests with the same email.
```

## Changelog Entry

For the `CHANGELOG.md`, group by type:

```markdown
## [1.4.0] - 2026-03-23

### Added
- OAuth2 login with Google provider (#247)
- Bulk export endpoint for user data (#251)

### Fixed
- Race condition in user creation causing duplicates (#253)
- Pagination cursor not working with filtered queries (#249)

### Changed
- Upgraded Drizzle ORM from 0.34 to 0.36
- Increased default rate limit from 60 to 100 req/min

### Deprecated
- `GET /api/v1/users/search` — use query params on `GET /api/v1/users` instead
```

## Release Notes (User-Facing)

For external release notes, translate technical changes into user benefits:

```markdown
## What's New in v1.4

**Sign in with Google** — You can now log in using your Google account.
No more passwords to remember.

**Export your data** — Download all your data as a CSV from the
Settings page.

**Performance improvements** — Page load times improved by ~30%
thanks to optimized database queries.

**Bug fixes** — Fixed an issue where search results would sometimes
show duplicate entries.
```

## Rules

1. **Read the actual diff** before writing any description — don't guess
2. **Be specific** — "Updated user service" is bad. "Added email validation to user creation flow" is good
3. **Separate what from why** — the diff shows what changed; the PR description explains why
4. **Link issues** — reference ticket numbers with `Closes #N` or `Refs #N`
5. **Call out risks** — if a change could break something, flag it explicitly
