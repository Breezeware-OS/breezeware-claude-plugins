---
name: code-review-backend
description: Review Spring Boot backend Java code for bugs, security, performance, and Breezeware convention violations. Use this skill when the user asks to review backend code, Java classes, Spring Boot controllers, services, repositories, entities, DTOs, or any server-side code. Also trigger when reviewing PRs that touch Java files or the user says review backend code, check controller, audit service, review Java.
---

# Backend Code Review Skill

Review Spring Boot / Java backend code against Breezeware conventions. Read the
`spring-boot-backend` skill (`references/checkstyle-rules.md` and
`references/formatter-rules.md`) for full configuration reference before
reviewing.

## 1. Security Check (Critical Priority)

- **SQL injection**: No string concatenation in queries; use parameterized queries or Spring Data
- **Sensitive data in logs**: Never log passwords, tokens, PII, or full request bodies
- **Hardcoded secrets**: No URLs, credentials, or API keys in source code
- **Missing auth checks**: All endpoints must have proper authentication/authorization
- **Input validation**: `@Validated` on all `@RequestBody` parameters
- **Mass assignment**: DTOs must whitelist fields — never bind entities directly to requests
- **CSRF protection**: Verify Spring Security CSRF config for stateful sessions
- **Error message leakage**: Generic messages to clients, details in logs only

## 2. Dependency Injection — MANDATORY Constructor Injection

This is the **single most important rule**. Flag immediately:

- ❌ **`@Autowired` on fields** — ABSOLUTELY FORBIDDEN
- ❌ **Non-final dependencies** — all must be `private final`
- ✅ **`@RequiredArgsConstructor`** — preferred (Lombok)
- ✅ **Explicit constructor** — acceptable if no Lombok
- ⚠️ **>5 dependencies** — may violate Single Responsibility Principle

```java
// ❌ FORBIDDEN — flag as critical
@Autowired
private OrderRepository orderRepository;

// ✅ CORRECT
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;
}
```

## 3. Code Formatting (Checkstyle / Eclipse Profile)

- **Indentation**: 4 spaces, NEVER tabs
- **Continuation indent**: 8 spaces
- **Line length**: 120 characters maximum
- **Comment line length**: 80 characters
- **Braces**: K&R style (opening brace on same line)
- **1 blank line** before methods
- **1 blank line** between import groups
- **No star imports**: `import java.util.*` ❌
- **Import order**: `java` → `javax` → `org` → `com` → `net` → `lombok`
- **Static imports**: above regular imports, sorted alphabetically

## 4. Naming Conventions (Checkstyle Enforced)

| Element              | Convention                  | Pattern                                |
|----------------------|-----------------------------|----------------------------------------|
| Package              | lowercase only              | `^[a-z]+(\.[a-z][a-z0-9]*)*$`         |
| Class / Interface    | PascalCase                  | `^[A-Z][a-zA-Z0-9]*$`                 |
| Method               | camelCase                   | `^[a-z][a-z0-9][a-zA-Z0-9_]*$`        |
| Member variable      | camelCase (min 3 chars)     | `^[a-z][a-z0-9][a-zA-Z0-9]*$`         |
| Parameter            | camelCase                   | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`      |
| Constant             | UPPER_SNAKE_CASE            | `^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$`      |
| Abbreviations        | Max 1 consecutive uppercase | `httpUrl` ✅, `HTTPUrl` ❌              |

## 5. REST API Conventions

- **URL pattern**: `/api/v1/{resource-name}` (plural, kebab-case, lowercase)
- **No verbs in URLs**: `GET /api/v1/users` ✅, `GET /api/v1/getUsers` ❌
- **HTTP methods**: GET=200, POST=201, PUT=200, PATCH=200, DELETE=204
- **Response envelope**: `{ data, meta }` for success, `{ error: { code, message, timestamp, path } }` for errors
- **`ResponseEntity<T>`**: Always return with explicit status codes
- **`@Validated`**: On all `@RequestBody` parameters
- **No trailing slashes**: `/api/v1/users` ✅, `/api/v1/users/` ❌
- **Max 2 levels of nesting**: `/api/v1/users/{id}/orders` ✅

## 6. Controller Layer

- **THIN controllers** — no business logic, only delegation to services
- **`@RequestMapping`** at class level for base path
- **Individual mapping annotations** — `@GetMapping`, `@PostMapping`, etc.
- **Log entry points** — with relevant IDs, never sensitive data
- **Javadoc** on every public method
- **No `@Transactional`** on controllers

## 7. Service Layer

- **Interface + Impl** — `UserService` interface, `UserServiceImpl` class
- **`@Transactional(readOnly = true)`** at class level
- **`@Transactional`** on individual write methods
- **All business logic here** — not in controllers, not in repositories
- **Domain-specific exceptions** — `ResourceNotFoundException`, not `RuntimeException`
- **`@RequiredArgsConstructor`** — constructor injection, always
- **No `@Transactional` on private methods** — Spring proxy limitation

## 8. Entity Layer

- **`@Table(name = "snake_case_plural")`** — table names lowercase snake_case
- **`@Column(name = "snake_case")`** — column names lowercase snake_case
- **UUID primary keys** — `@GeneratedValue(strategy = GenerationType.UUID)`
- **Audit columns** — `createdAt` + `updatedAt` with `@CreatedDate` / `@LastModifiedDate`
- **`@EntityListeners(AuditingEntityListener.class)`** — for audit columns
- **Lombok**: `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`
- ❌ **No `@Data` on entities** — broken equals/hashCode with JPA
- ❌ **No `@ToString` with lazy relationships** — triggers N+1 queries
- **`@Enumerated(EnumType.STRING)`** — NEVER `EnumType.ORDINAL`

## 9. DTO Layer

- **Java records** for DTOs — immutable, concise (Java 21)
- **Request DTOs**: Jakarta Bean Validation annotations (`@NotBlank`, `@Email`, `@Size`)
- **Response DTOs**: Plain records, no validation annotations
- **NEVER expose entities** directly in API responses — always map to DTOs
- **Separate Request and Response DTOs** — never reuse one for both

## 10. Repository Layer

- **`JpaRepository<Entity, UUID>`** — standard Spring Data
- **Query derivation** for simple queries
- **`@Query` with JPQL** for complex queries
- **`Optional<T>`** for single-entity lookups
- **`Page<T>`** for paginated results
- **No business logic** in repositories
- **No native SQL** unless absolutely necessary (and documented why)

## 11. Exception Handling

- **Custom exceptions** — `ResourceNotFoundException`, `DuplicateResourceException`
- **`@RestControllerAdvice`** — global exception handler
- **Standard error envelope**: `{ error: { code, message, timestamp, path } }`
- **Don't leak internals** — generic message to clients, log full details server-side

## 12. Lombok Usage

- ✅ `@Getter` / `@Setter` on entities
- ✅ `@Builder` on entities
- ✅ `@NoArgsConstructor` / `@AllArgsConstructor` on entities
- ✅ `@RequiredArgsConstructor` on services, controllers
- ✅ `@Slf4j` for logging
- ✅ `@Value` on immutable value objects (NOT entities)
- ❌ `@Data` on JPA entities
- ❌ `@ToString` on entities with lazy relationships
- ❌ `@EqualsAndHashCode` on entities without careful `of` selection

## 13. Logging

- **`@Slf4j`** (Lombok) — backed by Logback
- **Parameterized logging**: `log.info("User created: id={}", id)` ✅
- **No string concatenation**: `log.info("User created: " + id)` ❌
- **Never log**: passwords, tokens, PII, full request/response bodies
- **Log levels**: ERROR (failures), WARN (recoverable), INFO (business events), DEBUG (dev)

## 14. Flyway Migrations

- **File naming**: `V{n}__{description}.sql` (two underscores, lowercase_snake_case)
- **Sequential versions**: V1, V2, V3...
- **NEVER edit** applied migrations
- **NEVER delete** existing migration files
- **Adding NOT NULL column**: Two-step (add nullable → backfill → add constraint)
- **Large table index**: `CREATE INDEX CONCURRENTLY`
- **Dropping columns**: Two-step (stop using → drop in next release)

## 15. Javadoc (Checkstyle Enforced)

- **ALL public classes** must have Javadoc
- **ALL public methods (2+ lines)** must have Javadoc
- **Tag order**: `@param` → `@return` → `@throws` → `@deprecated`
- **Summary line**: Must NOT start with "This method returns" or "@return the"
- **Exempt**: `@Override` and `@Test` methods

## 16. Performance

- **N+1 queries**: Check for lazy-loaded collections accessed in loops
- **Missing indexes**: Verify indexes exist for query patterns used
- **Pagination**: Use `Page<T>` and `Pageable`, never load all records
- **Batch operations**: Use `saveAll()` instead of looping `save()`
- **Connection pool**: Verify HikariCP settings for prod workloads
- **Query optimization**: Check `@Query` for unnecessary joins or subqueries

## Output Format

```
## Backend Code Review — [class/module name]

### 🔴 Critical Issues (must fix)
- [issue + file:line + Checkstyle/convention violated + suggested fix]

### 🟡 Warnings (should fix)
- [issue + file:line + why it matters + suggested fix]

### 🟢 Suggestions (nice to have)
- [improvement + reasoning + expected benefit]

### 📐 Formatting / Style Issues
- [formatting issue + Checkstyle rule reference + fix]

### 🗄️ Database / Migration Issues
- [schema issue + safety concern + recommended approach]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always explain *why* something is an issue and *what risk* it introduces.
Reference the specific Breezeware Checkstyle rule or convention being violated.
