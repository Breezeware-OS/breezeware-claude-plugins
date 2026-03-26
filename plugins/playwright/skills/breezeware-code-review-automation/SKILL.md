---
name: breezeware-code-review-automation
description: Review Java Playwright automation test code for reliability, maintainability, locator strategy, Cucumber BDD conventions, and Breezeware standards. Use this skill when the user asks to review test automation code, page objects, step definitions, feature files, test utilities, or any Playwright/Cucumber/JUnit code. Also trigger when the user says review tests, check page object, audit test framework, review feature file, review automation code.
---

# Automation Test Code Review Skill

Review Java Playwright + Cucumber + JUnit 5 automation test code against
Breezeware conventions. Read the `breezeware-playwright-automation` skill
(`references/locator-guide.md`) for full locator strategy reference.

## 1. Locator Strategy (Critical Priority)

The #1 cause of flaky tests is bad locators. Flag immediately:

- ❌ **XPath selectors** — fragile, slow, unreadable
- ❌ **CSS with DOM structure** — `#root > div > div:nth-child(3)`
- ❌ **CSS class names** — `.MuiButton-containedPrimary`, `.css-1a2b3c`
- ❌ **Auto-generated IDs** — change between renders
- ❌ **Index-based without context** — `page.locator("button").nth(3)`
- ✅ **`getByTestId()`** — stable, decoupled from UI
- ✅ **`getByRole()` + name** — accessible, user-facing
- ✅ **`getByLabel()`** — for form inputs with labels
- ✅ **`getByText()`** — for visible text (buttons, headings)
- ✅ **Filtered locators** — `filter(hasText)` for contextual matching
- ✅ **Chained locators** — scope within parent elements

### Locator Naming Convention
- `data-testid` must be **kebab-case**: `create-user-btn` ✅, `createUserBtn` ❌
- Pattern: `{component}-{element}` or `{component}-{element}-{id}`

## 2. Wait Strategy — NO Thread.sleep()

Flag as **CRITICAL** if found:
- ❌ **`Thread.sleep()`** — FORBIDDEN. Always. No exceptions.
- ❌ **Hardcoded waits** — `page.waitForTimeout(5000)` (only acceptable for debounce)
- ✅ **Playwright auto-wait** — built into every action method
- ✅ **`waitFor(WaitForSelectorState)`** — explicit state waits
- ✅ **`waitForURL()`** — wait for navigation
- ✅ **`waitForResponse()`** — wait for API completion
- ✅ **`waitForLoadState()`** — wait for page load

## 3. Page Object Model

- **Every page extends `BasePage`** — common methods inherited
- **Locators encapsulated** — never exposed outside the page object
- **Methods return page objects** — for navigation methods
- **Methods return `this`** — for same-page actions (chaining)
- **No assertions** — page objects never assert, only interact and return data
- **No `Thread.sleep()`** — use waits
- **Component composition** — reusable components as fields (`DataTableComponent`)
- **`@Step` annotation** — on every public method for Allure
- **`@Slf4j` logging** — log every significant action
- **URL constants** — `private static final String URL_PATH`

## 4. Cucumber Feature Files

- **One feature per file** — `create_user.feature`
- **Feature-level tags** — `@users`, `@auth`, `@dashboard`
- **Priority tags** — `@smoke`, `@regression`, `@critical`
- **Type tags** — `@positive`, `@negative`, `@edge-case`, `@validation`
- **Background for shared setup** — login, navigation
- **Declarative steps** — WHAT, not HOW
- **No implementation details** — no selectors, no HTML, no technical jargon
- **Business language** — readable by non-technical stakeholders
- **Scenario Outline** — for data-driven tests with Examples table
- **DataTable** — for structured input `| field | value |`
- **One scenario per behavior** — not one test with 20 assertions

### Step Naming Anti-Patterns
```gherkin
# ❌ BAD — implementation details
When I click on the element with CSS selector ".btn-primary"
And I type "john@email.com" into the input with id "email"
And I wait 3 seconds

# ✅ GOOD — declarative, business language
When I fill in the registration form with valid data
And I submit the form
Then the user should be created successfully
```

## 5. Step Definitions

- **Constructor injection** — page objects via Cucumber PicoContainer
- **One step class per feature area** — `AuthSteps`, `UserSteps`
- **AssertJ assertions** — fluent, readable, with `.as()` descriptions
- **No page object creation** — inject via constructor
- **API for test data setup** — `@Given` steps use API, not UI
- **`DataTable` parsing** — `asMaps()` or `asLists()`, not raw strings
- **One assertion per `@Then`** — focused steps
- **No `Thread.sleep()`** — never

## 6. Test Data

- **Factories with Faker** — realistic, random data
- **No hardcoded test data** — in steps or page objects
- **API for setup** — `@Given` steps create data via API (faster than UI)
- **Unique data per test** — prevent test interference
- **Cleanup after tests** — via `@After` hooks or API teardown
- **Test data files** — JSON in `src/test/resources/testdata/`

## 7. Browser & Context Management

- **`ThreadLocal`** — for thread-safe parallel execution
- **New context per test** — isolated cookies, storage, state
- **Close context after test** — prevent resource leaks
- **Browser config externalized** — in properties files, not hardcoded
- **Headless by default** — in CI, headed for local debug
- **Video recording optional** — enabled via config flag

## 8. Error Handling & Reporting

- **Screenshot on failure** — auto-captured in `@After` hook
- **Page source on failure** — attached for debugging
- **Console errors captured** — via `page.onConsoleMessage`
- **Allure `@Step`** — on every page object public method
- **Allure `@Description`** — on test methods
- **Allure `@Severity`** — on all scenarios
- **Allure `@Epic/@Feature/@Story`** — map to Jira
- **No swallowed exceptions** — log and rethrow or fail explicitly

## 9. Configuration

- **Owner library** — type-safe config from properties files
- **Environment-specific** — `config-dev.properties`, `config-staging.properties`
- **System property override** — `-Denv=staging`, `-Dbrowser.name=firefox`
- **No hardcoded URLs** — always from config
- **No hardcoded credentials** — from config or env vars
- **Timeouts configurable** — default, element, page load

## 10. Code Formatting (Checkstyle)

Same rules as the backend skill:
- **4 spaces indentation** — NEVER tabs
- **120 char line length** — maximum
- **K&R brace style** — opening brace on same line
- **Import order** — `java` → `javax` → `org` → `com` → `net` → `lombok`
- **No star imports** — always specific
- **Javadoc on public methods** — Checkstyle enforced
- **Constructor injection** — `@RequiredArgsConstructor` or explicit

## 11. Test Independence

- **No test-to-test dependencies** — each test runs in isolation
- **No shared state** — between scenarios
- **No order dependency** — tests pass in any order
- **Fresh browser context** — per scenario
- **API setup/teardown** — not dependent on previous test's UI state

## 12. Performance

- **Parallel execution** — via Maven Surefire `fork` + `ThreadLocal` browser
- **API for setup** — 10x faster than UI navigation
- **Targeted waits** — wait for specific elements, not page load
- **No unnecessary screenshots** — only on failure
- **Lazy page object creation** — create when needed
- **Close resources** — context and page after each test

## Output Format

```
## Automation Code Review — [class/feature name]

### 🔴 Critical Issues (must fix)
- [issue + file:line + why it causes flaky tests + suggested fix]

### 🟡 Warnings (should fix)
- [issue + file:line + reliability/maintainability impact + suggested fix]

### 🟢 Suggestions (nice to have)
- [improvement + reasoning + expected benefit]

### 🎯 Locator Issues
- [bad locator + why it's fragile + recommended alternative]

### 🥒 Cucumber/BDD Issues
- [feature file issue + Gherkin best practice + fix]

### 📊 Reporting Issues
- [missing Allure annotation + traceability impact + fix]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always explain *why* something causes flaky tests and *what the reliability impact* is.
Reference the specific locator strategy or Cucumber convention being violated.
