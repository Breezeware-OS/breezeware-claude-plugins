# Breezeware Checkstyle Rules Reference

Extracted from `BreezewareGoogleCheckStyle.xml`. These rules are enforced at
**error** severity unless noted otherwise.

## File-Level Rules

| Rule                  | Value                    | Notes                              |
|-----------------------|--------------------------|------------------------------------|
| Charset               | UTF-8                    | All Java files must be UTF-8       |
| File extensions       | java, properties, xml    | Checkstyle applies to these        |
| No tab characters     | Enforced per line        | Use spaces only                    |
| Max line length       | **120 characters**       | Ignores package, import, URLs      |

## Import Rules

| Rule                     | Details                                                    |
|--------------------------|------------------------------------------------------------|
| No star imports          | `AvoidStarImport` — always use specific imports            |
| No line wrap on imports  | Package and import statements must be single-line          |
| Import order             | `java` → `javax` → `org` → `com` → `net` → `lombok`      |
| Separated groups         | Blank line between each import group                       |
| Static imports           | Above regular imports, sorted alphabetically               |
| Static import sort       | `sortStaticImportsAlphabetically = true`                   |
| Import order severity    | **warning** (not error)                                    |

## Naming Conventions

| Element                  | Pattern                                    | Example              |
|--------------------------|--------------------------------------------|----------------------|
| Package                  | `^[a-z]+(\.[a-z][a-z0-9]*)*$`             | `com.breezeware.api` |
| Type (class/interface)   | `^[A-Z][a-zA-Z0-9]*$`                     | `UserService`        |
| Method                   | `^[a-z][a-z0-9][a-zA-Z0-9_]*$`            | `findById`           |
| Member variable          | `^[a-z][a-z0-9][a-zA-Z0-9]*$`             | `userName`           |
| Parameter                | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `userId`             |
| Local variable           | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `result`             |
| Lambda parameter         | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `item`               |
| Catch parameter          | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `ex`                 |
| Class type parameter     | `(^[A-Z][0-9]?)$\|([A-Z][a-zA-Z0-9]*T$)` | `T`, `RequestT`      |
| Record component         | `^[a-z]([a-z0-9][a-zA-Z0-9]*)?$`          | `firstName`          |
| Abbreviation max length  | 1 consecutive uppercase                    | `httpUrl` ✅ `HTTPUrl` ❌ |

## Whitespace & Formatting

- `WhitespaceAfter`: Required after COMMA, SEMI, TYPECAST, IF, ELSE, RETURN, WHILE, DO, FOR, etc.
- `WhitespaceAround`: Required around ASSIGN, operators, LCURLY, RCURLY, etc.
  - Empty constructors, lambdas, methods, types, loops are allowed
- `NoWhitespaceBefore`: COMMA, SEMI, POST_INC, POST_DEC, DOT, METHOD_REF
- `GenericWhitespace`: No space inside angle brackets `<T>`, space after closing `>`
- `ParenPad`: No spaces inside parentheses
- `MethodParamPad`: No space before method parameter list

## Brace Rules

- `LeftCurly`: End of line for all blocks (class, method, if, for, etc.)
- `RightCurly` (same line): try/catch/finally, if/else, do/while
- `RightCurly` (alone): class, method, for, while, static init, enum
- `NeedBraces`: Required for DO, ELSE, FOR, IF, WHILE — no single-line blocks

## Indentation

| Setting                  | Value |
|--------------------------|-------|
| Basic offset             | 4     |
| Brace adjustment         | 0     |
| Case indent              | 4     |
| Throws indent            | 4     |
| Line wrapping indent     | 2     |
| Array init indent        | 4     |

## Javadoc Rules

- `MissingJavadocType`: Required on public/protected classes, interfaces, enums, records
- `MissingJavadocMethod`: Required on public methods (2+ lines), except `@Override` and `@Test`
- `JavadocMethod`: Allows missing `@param` and `@return` tags
- `AtclauseOrder`: `@param` → `@return` → `@throws` → `@deprecated`
- `SummaryJavadoc`: Must not start with "This method returns" or "@return the"
- `NonEmptyAtclauseDescription`: All `@` tags must have a description
- `JavadocParagraph`: Blank line before `<p>` tags
- `SingleLineJavadoc`: Enforced for short Javadoc

## Other Enforced Rules

- `OneTopLevelClass`: Only one top-level class per file
- `OuterTypeFilename`: Filename must match the outer type name
- `OneStatementPerLine`: No multiple statements on one line
- `MultipleVariableDeclarations`: One variable per declaration
- `ArrayTypeStyle`: Java style `String[] args` not C style `String args[]`
- `MissingSwitchDefault`: Every switch must have a default case
- `FallThrough`: No fall-through in switch cases without comment
- `ModifierOrder`: Annotations, then `public/protected/private`, then `abstract`, etc.
- `NoFinalizer`: No `finalize()` methods
- `EmptyCatchBlock`: Must have content (or variable named `expected`)
- `EmptyBlock`: Must have content or comment for TRY, FINALLY, IF, ELSE, SWITCH
- `OperatorWrap`: Operators on new line (not trailing)
- `SeparatorWrap`: DOT on new line, COMMA at end of line

## Suppression

- Suppressions loaded from: `https://breezeware-dev-config.s3.amazonaws.com/suppressions.xml`
- `SuppressionCommentFilter` enabled (use `// CHECKSTYLE:OFF` / `// CHECKSTYLE:ON`)
- `module-info.java` files excluded
