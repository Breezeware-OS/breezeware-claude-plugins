# Breezeware — Project Conventions

## Tech Stack
- **Language**: TypeScript (strict mode enabled)
- **Package Manager**: pnpm
- **Monorepo**: Turborepo
- **Frontend**: React 19 + Tailwind CSS
- **Backend**: Node.js + Fastify
- **Database**: PostgreSQL with Drizzle ORM
- **Testing**: Vitest (unit), Playwright (E2E)
- **CI/CD**: GitHub Actions
- **Infrastructure**: Docker + Kubernetes
- **Monitoring**: Prometheus + Grafana

## Git Conventions
- Branch naming: `feature/*`, `fix/*`, `chore/*`, `hotfix/*`
- Flow: `feature/*` → `develop` → `staging` → `main`
- Commit format: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`)
- All PRs require at least 1 approval
- Squash merge to `develop`, merge commit to `main`

## Code Standards
- No `any` types — use `unknown` and narrow
- All public functions must have JSDoc comments
- Max file length: 300 lines (split if larger)
- Prefer named exports over default exports
- Error handling: use custom error classes extending `BreezewareError`
- Logging: structured JSON logs via `pino`
- Env vars: loaded via `@t3-oss/env-nextjs` or `zod` validated configs

## API Standards
- RESTful with `/api/v1/` prefix
- Response envelope: `{ data, error, meta }`
- Pagination: cursor-based using `?cursor=<id>&limit=<n>`
- Auth: JWT in `Authorization: Bearer <token>` header
- Rate limiting: 100 req/min for authenticated, 20 req/min for public

## Testing Standards
- Minimum 80% branch coverage for all new code
- Unit tests co-located: `*.test.ts` next to source file
- E2E tests in `/tests/e2e/`
- Test data factories in `/tests/fixtures/`
- No testing against production databases

<!-- BREEZEWARE-SKILLS-START -->
## Available Skills
The following custom skills are available in `.claude/skills/`:
- `/code-review` — General code review (mixed-stack or unclear)
- `/code-review-frontend` — Frontend code review (React, JSX, Redux, Axios)
- `/code-review-backend` — Backend code review (Spring Boot, Java, JPA, Flyway)
- `/code-review-mobile` — Mobile code review (React Native, iOS, Android)
- `/code-review-automation` — Automation test code review (Playwright, Page Objects, Cucumber)
- `/code-review-cucumber` — Cucumber feature file review (Gherkin, BDD, step quality)
- `/reactjs-frontend` — React.js frontend development (Vite, Axios, shadcn/ui, Redux)
- `/spring-boot-backend` — Spring Boot backend development (Java 21, Maven, JPA, Flyway)
- `/react-native` — React Native mobile development (bare CLI, JavaScript)
- `/playwright-automation` — Java Playwright automation testing (JUnit 5, Cucumber, Allure)
- `/cucumber-feature` — Write Cucumber Gherkin feature files (BDD, declarative steps, tagging)
- `/git-workflow` — PR descriptions, changelogs, release notes
- `/security-scan` — Security-focused code review (OWASP Top 10)
<!-- BREEZEWARE-SKILLS-END -->
