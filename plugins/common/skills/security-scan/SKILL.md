---
name: security-scan
description: >
  Security-focused code review scanning for OWASP Top 10, authentication flaws,
  data exposure, and dependency vulnerabilities. Use this skill when the user
  asks for a security review, security audit, vulnerability scan, says "is this
  secure", "check for vulnerabilities", "security scan", "pentest this", or
  wants to harden any code, API, or configuration against attacks.
---

# Security Scan Skill

## OWASP Top 10 Checklist

### 1. Injection (SQL, NoSQL, Command, LDAP)
- [ ] All database queries use parameterized statements (Drizzle handles this, but check raw SQL)
- [ ] No string concatenation in queries: `sql\`...${userInput}...\`` is safe, `"SELECT * FROM " + table` is not
- [ ] User input never passed directly to `exec()`, `spawn()`, or `eval()`
- [ ] File paths from user input are sanitized (no `../` traversal)

### 2. Broken Authentication
- [ ] Passwords hashed with bcrypt/argon2 (cost factor ≥ 12)
- [ ] JWT tokens have reasonable expiry (access: 15min, refresh: 7d)
- [ ] Refresh tokens are rotated on use and revocable
- [ ] Failed login attempts are rate-limited (max 5 per minute per IP)
- [ ] Session tokens invalidated on logout and password change

### 3. Sensitive Data Exposure
- [ ] No secrets in source code, env files committed, or Docker images
- [ ] PII encrypted at rest in the database
- [ ] HTTPS enforced everywhere (HSTS header set)
- [ ] Sensitive fields excluded from API responses and logs
- [ ] Error messages don't leak stack traces or internal details

### 4. Broken Access Control
- [ ] Every endpoint checks authentication AND authorization
- [ ] Users cannot access other users' resources (IDOR check)
- [ ] Admin routes have role-based middleware
- [ ] File uploads restricted by type and size
- [ ] CORS configured to specific origins, not `*`

### 5. Security Misconfiguration
- [ ] Security headers set: CSP, X-Frame-Options, X-Content-Type-Options
- [ ] Debug mode disabled in production
- [ ] Default credentials changed
- [ ] Unnecessary routes and endpoints removed
- [ ] Directory listing disabled

### 6. XSS (Cross-Site Scripting)
- [ ] React auto-escapes by default — check for `dangerouslySetInnerHTML`
- [ ] User-generated content sanitized with DOMPurify before rendering
- [ ] CSP header blocks inline scripts
- [ ] URL params validated before use in redirects (open redirect prevention)

### 7. Insecure Dependencies
- [ ] `pnpm audit` shows no critical/high vulnerabilities
- [ ] Dependencies pinned to specific versions in lockfile
- [ ] No deprecated packages with known CVEs
- [ ] Automated dependency update checks (Renovate/Dependabot)

### 8. Logging & Monitoring
- [ ] Authentication events logged (login, logout, failed attempts)
- [ ] Authorization failures logged with user context
- [ ] Sensitive data (passwords, tokens, PII) NEVER logged
- [ ] Log injection prevented (user input sanitized before logging)

## Scan Output Format

```
## Security Scan Report — [target]

### 🔴 Critical (exploit risk)
- **[VULN-001] [Category]**: [description]
  - File: [path:line]
  - Risk: [what an attacker could do]
  - Fix: [specific remediation]

### 🟡 High (should fix before deploy)
- **[VULN-002] [Category]**: [description]
  - File: [path:line]
  - Risk: [impact]
  - Fix: [remediation]

### 🟢 Informational
- [observations that aren't vulnerabilities but worth noting]

### Summary
| Severity     | Count |
|--------------|-------|
| 🔴 Critical  | 0     |
| 🟡 High      | 2     |
| 🔵 Medium    | 1     |
| 🟢 Info      | 3     |
```

## Rules

1. **Assume hostile input** — every user-supplied value is untrusted
2. **Check the full request path** — from route → middleware → handler → service → DB
3. **Flag missing checks** — the absence of a security control is itself a finding
4. **Provide working fixes** — not just "sanitize input" but actual code to fix the issue
5. **Prioritize by exploitability** — remote code execution > data leak > information disclosure
