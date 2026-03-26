---
name: breezeware-spring-boot-backend
description: >
  Breezeware Spring Boot backend development skill for Java 21, Spring Boot,
  Maven, PostgreSQL, Flyway, MVC, and Lombok. ALWAYS use this skill when:
  creating any Java class, service, controller, repository, entity, DTO, enum,
  config, or exception class; creating or modifying REST API endpoints; writing
  Spring Boot code of any kind; scaffolding new modules, features, or CRUD
  operations; creating Flyway migrations; reviewing backend Java code; the user
  says "create API", "add endpoint", "new service", "new entity", "backend",
  "controller", "repository", "Spring", "Java class", "migration", "DTO", or
  anything related to server-side Java development. This skill enforces
  Breezeware's Google Checkstyle rules, Eclipse formatter profile (4-space
  indent, 120 char line length), import ordering (java → javax → org → com →
  net → lombok), constructor injection (NEVER field @Autowired), and REST API
  naming conventions. Think like a 30-year veteran backend architect.
---

# Breezeware Spring Boot Backend Skill

You are a senior backend architect with 30 years of experience. You write
production-grade, clean, maintainable Spring Boot code that follows every
convention documented below. No shortcuts, no sloppy code.

## Tech Stack

- **Java 21** (use records, sealed classes, pattern matching, text blocks where appropriate)
- **Spring Boot 3.x** (latest stable)
- **Maven** (multi-module where applicable)
- **PostgreSQL** (primary database)
- **Flyway** (database migrations)
- **Spring MVC** (REST controllers)
- **Lombok** (reduce boilerplate — but use judiciously, see rules below)
- **MapStruct** (DTO ↔ Entity mapping, if available)
- **Spring Data JPA** (repository layer)
- **Spring Security** (authentication/authorization)

---

## Project Package Structure

```
com.breezeware.{module-name}
├── controller/          # REST controllers (@RestController)
├── service/             # Business logic interfaces
│   └── impl/            # Service implementations (@Service)
├── repository/          # Spring Data JPA repositories (@Repository)
├── entity/              # JPA entities (@Entity)
├── dto/                 # Request/Response DTOs (records or classes)
├── mapper/              # MapStruct mappers (@Mapper)
├── config/              # Configuration classes (@Configuration)
├── exception/           # Custom exceptions and handlers
├── enums/               # Enum types
├── util/                # Utility/helper classes
├── validator/           # Custom validators
└── constant/            # Constants classes
```

### Package Naming Rules
- All lowercase: `com.breezeware.usermanagement` ✅
- No underscores, hyphens, or uppercase: `com.breezeware.user_management` ❌
- Package names match pattern: `^[a-z]+(\.[a-z][a-z0-9]*)*$`

---

## Code Formatting Rules (Breezeware Eclipse Profile)

These are extracted from the Breezeware Eclipse formatter and Checkstyle configs.
**Follow them exactly.**

### Indentation & Spacing
- **Indentation**: 4 spaces (NEVER tabs)
- **Continuation indent**: 8 spaces (2 × indentation)
- **Line length**: 120 characters maximum
- **Comment line length**: 80 characters
- **Braces**: End of line (K&R style), NOT next line
- **1 blank line** before methods
- **1 blank line** between import groups
- **1 blank line** after package declaration
- **1 blank line** after imports
- **0 blank lines** at beginning/end of method body
- **1 blank line** after code blocks

### Brace Style (K&R — end of line)
```java
// ✅ CORRECT — opening brace on same line
public class UserService {

    public User findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID must not be null");
        }
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", id));
    }
}

// ❌ WRONG — opening brace on next line
public class UserService
{
    public User findById(Long id)
    {
```

### Whitespace Rules
- Space before opening brace: `if (condition) {`
- Space before parenthesis in control statements: `if (`, `for (`, `while (`
- NO space before parenthesis in method calls: `doSomething(arg)`
- Space after commas: `method(arg1, arg2, arg3)`
- Space around operators: `a + b`, `x = y`, `a == b`
- Space after semicolons in for: `for (int i = 0; i < n; i++)`
- Space before and after lambda arrow: `(x) -> x + 1`
- NO space inside parentheses: `method(arg)` not `method( arg )`

---

## Import Order (Breezeware Profile)

Imports MUST be organized in this exact order, with blank lines between groups:

```java
import java.*           // Group 0
                        // blank line
import javax.*          // Group 1
                        // blank line
import org.*            // Group 2
                        // blank line
import com.*            // Group 3
                        // blank line
import net.*            // Group 4
                        // blank line
import lombok.*         // Group 5
```

### Import Rules
- **NO star/wildcard imports** (`import java.util.*` ❌)
- Static imports go ABOVE regular imports, sorted alphabetically
- Imports within each group are sorted alphabetically
- No line wrapping on import or package statements

---

## Naming Conventions (Checkstyle Enforced)

| Element               | Convention                       | Pattern                                    | Example                              |
|-----------------------|----------------------------------|--------------------------------------------|--------------------------------------|
| Package               | lowercase only                   | `^[a-z]+(\.[a-z][a-z0-9]*)*$`             | `com.breezeware.usermanagement`      |
| Class / Interface     | PascalCase                       | `^[A-Z][a-zA-Z0-9]*$`                     | `UserService`, `OrderController`     |
| Method                | camelCase                        | `^[a-z][a-z0-9][a-zA-Z0-9_]*$`            | `findById`, `createUser`             |
| Member variable       | camelCase (min 3 chars)          | `^[a-z][a-z0-9][a-zA-Z0-9]*$`             | `userName`, `orderDate`              |
| Local variable        | camelCase                        | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `result`, `tempList`                 |
| Parameter             | camelCase                        | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `userId`, `request`                  |
| Constant              | UPPER_SNAKE_CASE                 | `^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$`           | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE`|
| Type parameter        | Single uppercase or `*T`         | `(^[A-Z][0-9]?)$|([A-Z][a-zA-Z0-9]*T$)`   | `T`, `E`, `RequestT`                |
| Enum                  | PascalCase (type), UPPER_SNAKE (values) |                                     | `OrderStatus.PENDING`                |
| Abbreviations         | Max 1 consecutive uppercase      |                                            | `httpUrl` ✅, `HTTPUrl` ❌            |

---

## Dependency Injection — MANDATORY: Constructor Injection

**NEVER use `@Autowired` field injection. EVER.**

This is the single most important rule. Breezeware mandates constructor injection
for all Spring beans.

```java
// ❌ ABSOLUTELY FORBIDDEN — Field injection
@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private NotificationService notificationService;
}

// ✅ CORRECT — Constructor injection with Lombok
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final NotificationService notificationService;
}

// ✅ ALSO CORRECT — Explicit constructor (when not using Lombok)
@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final NotificationService notificationService;

    public OrderService(OrderRepository orderRepository,
            NotificationService notificationService) {
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
    }
}
```

### Why Constructor Injection
- Dependencies are **immutable** (`final` fields)
- Dependencies are **explicit** — visible in the constructor signature
- Classes are **testable** — easy to pass mocks without Spring context
- Prevents **NullPointerException** — dependencies guaranteed at construction
- Detects **circular dependencies** at startup, not at runtime
- Works **outside Spring** — class is a plain POJO

### Rules
1. ALL dependencies MUST be `private final`
2. Use `@RequiredArgsConstructor` (Lombok) to avoid boilerplate constructor
3. If class has >5 dependencies, reconsider — it may violate Single Responsibility
4. `@Autowired` on constructor is NOT needed (Spring 4.3+ auto-detects single constructor)
5. For optional dependencies, use `@Nullable` parameter or `Optional<T>` in constructor

---

## REST API Conventions

### URL Naming Rules

```
Base pattern: /api/v1/{resource-name}
```

| Rule                          | ✅ Correct                          | ❌ Wrong                              |
|-------------------------------|-------------------------------------|---------------------------------------|
| Use plural nouns              | `/api/v1/users`                     | `/api/v1/user`                        |
| Use kebab-case                | `/api/v1/order-items`               | `/api/v1/orderItems`, `/api/v1/order_items` |
| All lowercase                 | `/api/v1/users`                     | `/api/v1/Users`                       |
| No verbs in URL               | `GET /api/v1/users`                 | `GET /api/v1/getUsers`                |
| Hierarchy via nesting         | `/api/v1/users/{id}/orders`         | `/api/v1/user-orders?userId=1`        |
| Max 2 levels of nesting       | `/api/v1/users/{id}/orders`         | `/api/v1/users/{id}/orders/{oid}/items/{iid}/details` |
| Version in URL                | `/api/v1/users`                     | `/users`                              |
| No trailing slash             | `/api/v1/users`                     | `/api/v1/users/`                      |
| No file extensions            | `/api/v1/users`                     | `/api/v1/users.json`                  |
| Use query params for filters  | `/api/v1/users?status=active`       | `/api/v1/users/active`                |

### HTTP Methods

| Method   | Purpose                  | Returns        | Idempotent |
|----------|--------------------------|----------------|------------|
| `GET`    | Retrieve resource(s)     | 200 OK         | Yes        |
| `POST`   | Create new resource      | 201 Created    | No         |
| `PUT`    | Full update (replace)    | 200 OK         | Yes        |
| `PATCH`  | Partial update           | 200 OK         | No         |
| `DELETE` | Remove resource          | 204 No Content | Yes        |

### Standard Response Envelope

```java
// For success responses
{
    "data": { ... },         // Single object or list
    "meta": {                // Pagination metadata
        "page": 0,
        "size": 20,
        "totalElements": 142,
        "totalPages": 8
    }
}

// For error responses
{
    "error": {
        "code": "USER_NOT_FOUND",
        "message": "User with ID 42 not found",
        "timestamp": "2026-03-23T10:15:30Z",
        "path": "/api/v1/users/42"
    }
}
```

---

## Controller Template

```java
package com.breezeware.usermanagement.controller;

import java.net.URI;
import java.util.UUID;

import com.breezeware.usermanagement.dto.CreateUserRequest;
import com.breezeware.usermanagement.dto.UpdateUserRequest;
import com.breezeware.usermanagement.dto.UserResponse;
import com.breezeware.usermanagement.service.UserService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * REST controller for managing users.
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * Retrieves a paginated list of users.
     *
     * @param pageable pagination parameters
     * @return page of user responses
     */
    @GetMapping
    public ResponseEntity<Page<UserResponse>> listUsers(Pageable pageable) {
        log.info("Listing users, page={}, size={}", pageable.getPageNumber(),
                pageable.getPageSize());
        Page<UserResponse> users = userService.listUsers(pageable);
        return ResponseEntity.ok(users);
    }

    /**
     * Retrieves a user by their unique identifier.
     *
     * @param id the user ID
     * @return the user response
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUser(@PathVariable UUID id) {
        log.info("Fetching user with id={}", id);
        UserResponse user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    /**
     * Creates a new user.
     *
     * @param request the create user request
     * @return the created user response with location header
     */
    @PostMapping
    public ResponseEntity<UserResponse> createUser(
            @Validated @RequestBody CreateUserRequest request) {
        log.info("Creating user with email={}", request.email());
        UserResponse created = userService.createUser(request);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.id())
                .toUri();
        return ResponseEntity.created(location).body(created);
    }

    /**
     * Updates an existing user.
     *
     * @param id      the user ID
     * @param request the update user request
     * @return the updated user response
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateUser(@PathVariable UUID id,
            @Validated @RequestBody UpdateUserRequest request) {
        log.info("Updating user with id={}", id);
        UserResponse updated = userService.updateUser(id, request);
        return ResponseEntity.ok(updated);
    }

    /**
     * Deletes a user by their unique identifier.
     *
     * @param id the user ID
     * @return no content response
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable UUID id) {
        log.info("Deleting user with id={}", id);
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Controller Rules
1. Controllers are THIN — no business logic, only delegation to services
2. Always return `ResponseEntity<T>` with explicit status codes
3. Use `@Validated` on `@RequestBody` for bean validation
4. Log entry point with relevant IDs (never log sensitive data like passwords)
5. `@RequestMapping` at class level for base path
6. Individual `@GetMapping`, `@PostMapping`, etc. for each endpoint
7. Javadoc on every public method

---

## Service Layer Template

```java
package com.breezeware.usermanagement.service;

import java.util.UUID;

import com.breezeware.usermanagement.dto.CreateUserRequest;
import com.breezeware.usermanagement.dto.UpdateUserRequest;
import com.breezeware.usermanagement.dto.UserResponse;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * Service interface for user management operations.
 */
public interface UserService {

    Page<UserResponse> listUsers(Pageable pageable);

    UserResponse getUserById(UUID id);

    UserResponse createUser(CreateUserRequest request);

    UserResponse updateUser(UUID id, UpdateUserRequest request);

    void deleteUser(UUID id);
}
```

```java
package com.breezeware.usermanagement.service.impl;

import java.util.UUID;

import com.breezeware.usermanagement.dto.CreateUserRequest;
import com.breezeware.usermanagement.dto.UpdateUserRequest;
import com.breezeware.usermanagement.dto.UserResponse;
import com.breezeware.usermanagement.entity.User;
import com.breezeware.usermanagement.exception.ResourceNotFoundException;
import com.breezeware.usermanagement.mapper.UserMapper;
import com.breezeware.usermanagement.repository.UserRepository;
import com.breezeware.usermanagement.service.UserService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Implementation of {@link UserService}.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    @Override
    public Page<UserResponse> listUsers(Pageable pageable) {
        return userRepository.findAll(pageable)
                .map(userMapper::toResponse);
    }

    @Override
    public UserResponse getUserById(UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
        return userMapper.toResponse(user);
    }

    @Override
    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new DuplicateResourceException("User", "email", request.email());
        }
        User user = userMapper.toEntity(request);
        User saved = userRepository.save(user);
        log.info("Created user with id={}", saved.getId());
        return userMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public UserResponse updateUser(UUID id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
        userMapper.updateEntity(request, user);
        User saved = userRepository.save(user);
        log.info("Updated user with id={}", saved.getId());
        return userMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public void deleteUser(UUID id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User", "id", id);
        }
        userRepository.deleteById(id);
        log.info("Deleted user with id={}", id);
    }
}
```

### Service Rules
1. Define an **interface** and separate **impl** class
2. `@Transactional(readOnly = true)` at class level, `@Transactional` on write methods
3. All business logic lives HERE — not in controllers, not in repositories
4. Validate business rules (duplicate checks, authorization, etc.)
5. Throw domain-specific exceptions (`ResourceNotFoundException`, not generic `RuntimeException`)
6. `@RequiredArgsConstructor` — constructor injection, always

---

## Entity Template

```java
package com.breezeware.usermanagement.entity;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * JPA entity representing a user in the system.
 */
@Entity
@Table(name = "users")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "email", nullable = false, unique = true, length = 255)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private UserStatus status;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;
}
```

### Entity Rules
1. `@Table(name = "snake_case_plural")` — table names are lowercase snake_case
2. `@Column(name = "snake_case")` — column names are lowercase snake_case
3. Use `UUID` for primary keys, generated by the database
4. Always include `createdAt` and `updatedAt` audit columns
5. Use `@EntityListeners(AuditingEntityListener.class)` with `@CreatedDate` / `@LastModifiedDate`
6. Use Lombok: `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`
7. Do NOT use `@Data` on entities — it generates `equals`/`hashCode` using all fields (dangerous with JPA)
8. Do NOT use `@ToString` on entities with lazy-loaded relationships (triggers N+1)
9. `@Enumerated(EnumType.STRING)` — NEVER `EnumType.ORDINAL`

---

## DTO Templates (Java Records)

```java
package com.breezeware.usermanagement.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * Request DTO for creating a new user.
 */
public record CreateUserRequest(

        @NotBlank(message = "First name is required")
        @Size(max = 100, message = "First name must not exceed 100 characters")
        String firstName,

        @NotBlank(message = "Last name is required")
        @Size(max = 100, message = "Last name must not exceed 100 characters")
        String lastName,

        @NotBlank(message = "Email is required")
        @Email(message = "Email must be valid")
        String email
) {}
```

```java
package com.breezeware.usermanagement.dto;

import java.time.Instant;
import java.util.UUID;

/**
 * Response DTO for user data.
 */
public record UserResponse(
        UUID id,
        String firstName,
        String lastName,
        String email,
        String status,
        Instant createdAt,
        Instant updatedAt
) {}
```

### DTO Rules
1. Use Java **records** for DTOs (immutable, concise, Java 21)
2. Request DTOs have **Jakarta Bean Validation** annotations
3. Response DTOs are plain records — no validation annotations
4. NEVER expose entities directly in API responses — always map to DTOs
5. Separate Request and Response DTOs — never reuse one for both

---

## Repository Template

```java
package com.breezeware.usermanagement.repository;

import java.util.Optional;
import java.util.UUID;

import com.breezeware.usermanagement.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repository for {@link User} entity persistence.
 */
@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);
}
```

### Repository Rules
1. Extend `JpaRepository<Entity, IdType>`
2. Use Spring Data query derivation for simple queries
3. Use `@Query` with JPQL for complex queries
4. NEVER write native SQL unless absolutely necessary (and document why)
5. Return `Optional<T>` for single-entity lookups
6. Use `Page<T>` for paginated results
7. No business logic in repositories

---

## Exception Handling

```java
package com.breezeware.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Exception thrown when a requested resource is not found.
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException(String resource, String field, Object value) {
        super(String.format("%s not found with %s: '%s'", resource, field, value));
    }
}
```

```java
package com.breezeware.common.exception;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import lombok.extern.slf4j.Slf4j;

/**
 * Global exception handler for REST API error responses.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(
            ResourceNotFoundException ex, WebRequest request) {
        return buildErrorResponse(HttpStatus.NOT_FOUND, ex.getMessage(), request);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(
            MethodArgumentNotValidException ex, WebRequest request) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .reduce((a, b) -> a + "; " + b)
                .orElse("Validation failed");
        return buildErrorResponse(HttpStatus.BAD_REQUEST, message, request);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGeneral(
            Exception ex, WebRequest request) {
        log.error("Unhandled exception", ex);
        return buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR,
                "An unexpected error occurred", request);
    }

    private ResponseEntity<Map<String, Object>> buildErrorResponse(
            HttpStatus status, String message, WebRequest request) {
        Map<String, Object> error = new LinkedHashMap<>();
        error.put("code", status.name());
        error.put("message", message);
        error.put("timestamp", Instant.now());
        error.put("path", request.getDescription(false).replace("uri=", ""));
        return ResponseEntity.status(status).body(Map.of("error", error));
    }
}
```

---

## Flyway Migration Rules

### File Naming
```
src/main/resources/db/migration/
├── V1__create_users_table.sql
├── V2__add_status_to_users.sql
├── V3__create_orders_table.sql
└── V4__add_index_on_users_email.sql
```

- Format: `V{version}__{description}.sql` (two underscores)
- Version: sequential integers (V1, V2, V3...)
- Description: lowercase_snake_case
- **NEVER** edit a migration that has been applied to any environment
- **NEVER** delete an existing migration file

### Migration Template
```sql
-- V1__create_users_table.sql
CREATE TABLE users (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name  VARCHAR(100)    NOT NULL,
    last_name   VARCHAR(100)    NOT NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    status      VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_status ON users (status);
```

### Migration Safety Rules
- Adding a nullable column → **safe**, do it in one migration
- Adding a NOT NULL column → **two-step**: add nullable, backfill, then add constraint
- Adding an index on large table → use `CREATE INDEX CONCURRENTLY`
- Dropping a column → **two-step**: stop using it in code first, then drop in next release
- Renaming a column → **three-step**: add new, migrate data, drop old
- NEVER use `DROP TABLE` without confirmation and a backup plan

---

## Lombok Usage Rules

### ✅ Use Lombok For
- `@Getter` / `@Setter` on entities
- `@Builder` on entities
- `@NoArgsConstructor` / `@AllArgsConstructor` on entities
- `@RequiredArgsConstructor` on services, controllers (for constructor injection)
- `@Slf4j` for logging
- `@Value` on immutable value objects (NOT entities)

### ❌ NEVER Use
- `@Data` on JPA entities (broken equals/hashCode)
- `@ToString` on entities with lazy relationships (triggers N+1 queries)
- `@EqualsAndHashCode` on entities without careful `of` field selection
- `@Autowired` on fields (this is a Spring annotation, not Lombok, but same category of mistake)

---

## Javadoc Requirements (Checkstyle Enforced)

- ALL public classes MUST have Javadoc
- ALL public methods with 2+ lines MUST have Javadoc
- Javadoc tag order: `@param`, `@return`, `@throws`, `@deprecated`
- Summary line must NOT start with "This method returns" or "@return the"
- Methods annotated with `@Override` or `@Test` are exempt

```java
/**
 * Retrieves a user by their unique identifier.
 *
 * @param id the user's unique identifier
 * @return the user response DTO
 * @throws ResourceNotFoundException if no user exists with the given ID
 */
public UserResponse getUserById(UUID id) {
```

---

## Additional Spring Boot Best Practices

### Configuration
- Use `application.yml` over `application.properties`
- Externalize all env-specific values
- Use `@ConfigurationProperties` with `@Validated` for type-safe config
- NEVER hardcode URLs, credentials, or secrets

### Logging
- Use `@Slf4j` (Lombok) — backed by Logback
- Use parameterized logging: `log.info("User created: id={}", id)` ✅
- NEVER string concatenation in logs: `log.info("User created: " + id)` ❌
- NEVER log passwords, tokens, PII, or full request bodies
- Log level guide: ERROR (failures), WARN (recoverable issues), INFO (business events), DEBUG (dev details)

### Transaction Management
- `@Transactional(readOnly = true)` at service class level
- `@Transactional` on individual write methods
- NEVER put `@Transactional` on controllers
- NEVER put `@Transactional` on `private` methods (won't work — Spring proxy limitation)

### Testing
- Unit tests: JUnit 5 + Mockito
- Integration tests: `@SpringBootTest` + Testcontainers (PostgreSQL)
- Use `@MockitoExtension` for service unit tests
- Test class naming: `UserServiceTest`, `UserControllerIntegrationTest`
- NEVER test against real databases in CI — use Testcontainers

For the full Checkstyle configuration reference, read `references/checkstyle-rules.md`.
For the full formatter settings reference, read `references/formatter-rules.md`.
