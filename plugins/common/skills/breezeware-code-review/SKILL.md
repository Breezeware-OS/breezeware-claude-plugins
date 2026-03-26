---
name: breezeware-code-review
description: General code review for bugs, security vulnerabilities, performance issues, and style violations. For frontend-specific reviews (React, JSX, JavaScript), use breezeware-code-review-frontend instead. For backend-specific reviews (Spring Boot, Java), use breezeware-code-review-backend instead. Use this skill for general or mixed-stack reviews, infrastructure code, or when the stack is unclear.
---

# Code Review Skill (General)

For stack-specific reviews, use the dedicated skills:
- **Frontend** (React, JavaScript, JSX, Redux, Axios): use `breezeware-code-review-frontend`
- **Backend** (Spring Boot, Java, JPA, Flyway): use `breezeware-code-review-backend`
- **Infrastructure** (Docker, K8s, Terraform, CI/CD): use `infra-review`

This skill handles general or mixed-stack reviews.

## 1. Security Check (Critical Priority)
- SQL injection, XSS, CSRF vulnerabilities
- Hardcoded secrets, API keys, tokens, or credentials
- Insecure deserialization or input handling
- Missing authentication/authorization checks
- Exposed sensitive data in logs or responses

## 2. Bug Detection
- Null/undefined reference risks
- Off-by-one errors and boundary conditions
- Race conditions or async issues (missing `await`, unhandled promises)
- Memory leaks (event listeners not removed, subscriptions not cleaned)
- Incorrect type narrowing or unsafe type casts

## 3. Error Handling
- All async operations must have try/catch or `.catch()`
- Custom error classes extending `BreezewareError` (not generic `Error`)
- User-facing errors must not leak internal details
- Verify proper HTTP status codes in API responses

## 4. Performance
- N+1 query patterns in database calls
- Missing database indexes for query patterns used
- Unnecessary re-renders in React components (missing `useMemo`, `useCallback`)
- Large bundle imports that could be tree-shaken or lazy-loaded

## 5. Style & Conventions
- Follows project naming conventions (see CLAUDE.md)
- No `any` types — must use `unknown` with proper narrowing
- File length under 300 lines
- Functions have JSDoc for public APIs
- Named exports preferred over default exports

## 6. Test Coverage
- New logic has corresponding test cases
- Edge cases and error paths are tested
- No tests relying on implementation details

## Output Format

```
### 🔴 Critical Issues (must fix)
- [issue description + file:line + suggested fix]

### 🟡 Warnings (should fix)
- [issue description + file:line + suggested fix]

### 🟢 Suggestions (nice to have)
- [improvement idea + reasoning]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always be constructive. Explain *why* something is an issue, not just *what* is wrong.
