---
name: breezeware-code-review-cucumber
description: Review Cucumber Gherkin feature files for BDD best practices, declarative writing, tagging strategy, step reusability, scenario independence, and business readability. Use this skill when reviewing feature files, Gherkin scenarios, step definitions mapping, or BDD test coverage. Also trigger when the user says review feature file, check Gherkin, audit BDD, review scenarios, review cucumber.
---

# Cucumber Feature File Code Review Skill

Review Cucumber Gherkin feature files against Breezeware BDD conventions.
Read the `breezeware-cucumber-feature` skill (`references/gherkin-patterns.md`) for
full pattern reference and step definition mapping guide.

## 1. Feature File Structure (Critical Priority)

- **One feature per file** — never combine unrelated features
- **snake_case file name** — `create_user.feature`, not `CreateUser.feature`
- **Verb-noun pattern** — `create_user`, `edit_profile`, `list_orders`
- **User story format** — `As a / I want to / So that` on every Feature
- **Grouped by domain folder** — `auth/`, `users/`, `orders/`
- **Max 10 scenarios per file** — split if larger

Flag if:
- Multiple `Feature:` blocks in one file
- File name uses camelCase, PascalCase, or kebab-case
- Missing user story (`As a / I want to / So that`)
- Feature file has 15+ scenarios

## 2. Tagging Strategy (Critical Priority)

### Required Tags
Every feature file MUST have:
- **Feature-level**: at least one domain tag (`@users`, `@auth`, `@dashboard`) + `@regression`
- **Scenario-level**: at least one type tag (`@positive`, `@negative`, `@edge-case`, `@validation`)

### Tag Validation Rules
| Rule | Valid | Invalid |
|------|-------|---------|
| Domain tag on Feature | `@users @regression` | No domain tag |
| Type tag on Scenario | `@positive`, `@negative` | No type tag |
| `@smoke` count | 15-25 total across all features | 100+ smoke tests |
| `@skip`/`@flaky` | Must have JIRA comment | `@skip` without reason |
| Max tags per scenario | 4 tags | 6+ tags on one scenario |
| Tag format | lowercase, kebab-case | `@CreateUser`, `@create_user` |
| No implementation tags | `@positive`, `@validation` | `@selenium`, `@api`, `@database` |

Flag as **CRITICAL** if:
- Feature has no domain tag
- Scenarios have no type tags
- `@skip` or `@flaky` without JIRA ticket comment
- Implementation-detail tags (`@selenium`, `@playwright`, `@api-test`)

## 3. Declarative vs Imperative Steps (Critical Priority)

The #1 quality issue in feature files. Every step must describe WHAT, never HOW.

### Red Flags — Imperative Steps (Flag Immediately)
```gherkin
# ❌ CSS selectors, IDs, classes
When I click on the element with CSS selector ".btn-primary"
When I click the element "#submit-btn"

# ❌ XPath references
When I click on the element at xpath "//div[@class='form']/button"

# ❌ HTML/DOM references
And I type "john@email.com" into the input with id "email"
And I select from the dropdown with name "role"

# ❌ Explicit waits
And I wait for 3 seconds
And I wait for the page to load
And I wait until the element is visible

# ❌ Technical jargon
Then the HTTP response code should be 200
And the API should return a JSON with status "success"
And the DOM element should have class "active"

# ❌ Mouse/keyboard actions
When I double-click on the row
And I press Enter key
And I hover over the menu item
```

### Green Flags — Declarative Steps
```gherkin
# ✅ Business language
When I open the Create User form
And I fill in the user details with valid data
And I submit the form
Then I should see a success message "User created successfully"

# ✅ Contextual actions
When I search for "John Doe"
When I filter by status "Active"
When I sort by name in ascending order

# ✅ Observable outcomes
Then the user "John Doe" should appear in the list
Then I should see 10 results
Then the form should show validation errors
```

Flag as **CRITICAL** if:
- Any CSS selector, XPath, or HTML ID in step text
- Any `wait for X seconds` step
- Any HTTP status code or API response in step text
- Any DOM manipulation language in steps

## 4. Background Usage

### Rules
- **Max 3 steps** — keep it minimal
- **Only Given steps** — never When/Then in Background
- **Applies to ALL scenarios** — if not universal, use inline Given
- **Login + navigation only** — no scenario-specific test data
- **No conditional logic** — every scenario must need the Background

Flag if:
- Background has 4+ steps
- Background has When or Then steps
- Background creates test data that only some scenarios need
- Background has complex setup that obscures scenario intent

## 5. Scenario Independence (Critical Priority)

Every scenario MUST run in isolation, in any order, without depending on
other scenarios.

### Red Flags
```gherkin
# ❌ Scenario 2 depends on Scenario 1
Scenario: Create a user
  When I create user "John Doe"
  Then user should be created

Scenario: Edit the user created above
  When I edit user "John Doe"    # Depends on previous scenario!
  Then user should be updated
```

### Green Flags
```gherkin
# ✅ Each scenario sets up its own data
Scenario: Edit a user
  Given a user "John Doe" exists    # Own setup via API
  When I update the user's email
  Then the user should be updated
```

Flag as **CRITICAL** if:
- Scenario references data created by a previous scenario
- Scenarios must run in a specific order
- Scenario says "the user created above" or "the previously created"
- No Given steps for test data (relying on shared state)

## 6. Scenario Design

### One Behavior Per Scenario
```gherkin
# ❌ Multiple behaviors in one scenario
Scenario: User management
  When I create a user
  Then the user should be created
  When I edit the user
  Then the user should be updated
  When I delete the user
  Then the user should be deleted

# ✅ One behavior per scenario
Scenario: Create a user
  ...
Scenario: Edit a user
  ...
Scenario: Delete a user
  ...
```

### Specific Assertions
```gherkin
# ❌ Vague assertions
Then it should work
Then the page should load correctly
Then everything should be fine

# ✅ Specific, verifiable assertions
Then I should see a success message "User created successfully"
Then the user "John Doe" should appear in the user list
Then the user count should be 11
```

Flag if:
- Scenario tests more than one behavior
- Scenario has 10+ steps
- Assertions are vague ("should work", "should load")
- Scenario name doesn't clearly describe the behavior

## 7. Data Tables & Scenario Outlines

### DataTable Rules
- **Always include headers** — `| field | value |`
- **Meaningful column names** — not `col1`, `col2`
- **Aligned pipes** — for readability
- **Max 8 columns** — split if wider
- **Max 10 rows** — use Scenario Outline for more
- **No empty cells** — use `N/A` or `-`

### Scenario Outline Rules
- **Descriptive placeholders** — `<firstName>` not `<val1>` or `<a>`
- **camelCase placeholders** — `<firstName>`, `<emailAddress>`
- **Named Examples blocks** — `Examples: Valid roles`, not just `Examples:`
- **3-10 rows per Examples** — enough to cover variants
- **Same assertion pattern** — all rows test same behavior with different data
- **Split by category** — separate Examples blocks for different categories

Flag if:
- DataTable has no headers
- Placeholders are single letters or meaningless (`<a>`, `<val1>`)
- Scenario Outline rows have completely different assertion logic
- DataTable has 15+ rows (use Scenario Outline instead)
- Examples block is unnamed

## 8. Step Reusability

### Reusable Step Patterns
Steps should be written to maximize reuse across features:

```gherkin
# ✅ Generic — reusable everywhere
Given I am logged in as an admin
Given I am logged in as a "<role>"
And I am on the "<pageName>" page
Then I should see a success message "<message>"
Then I should see an error message "<message>"
Then I should see <count> items in the list

# ❌ Over-specific — not reusable
Given I am logged in as admin user john@breezeware.com with password Admin123
And I am on the User Management page at /admin/users
Then I should see the green success toast in the top right corner
```

Flag if:
- Steps are so specific they can only be used in one scenario
- Similar steps are worded differently across features (inconsistency)
- Common actions (login, search, toast check) are rewritten instead of reused

## 9. Test Coverage Completeness

For every CRUD feature, verify these scenario types exist:

| Type | Tag | Required? | Example |
|------|-----|-----------|---------|
| Happy path | `@positive @smoke` | YES | Create with valid data |
| All fields | `@positive` | YES | Create with optional fields |
| Empty required | `@negative @validation` | YES | Submit without required fields |
| Invalid format | `@negative @validation` | YES | Invalid email, phone |
| Duplicate | `@negative @duplicate` | YES | Duplicate email/name |
| Permission | `@negative @permission` | Recommended | Non-admin cannot access |
| Edge case | `@edge-case` | Recommended | Max length, special chars |
| Pagination | `@pagination` | If applicable | Page navigation, size change |
| Search/filter | `@search` | If applicable | Text search, filters |
| Sort | `@sort` | If applicable | Column sorting |

Flag if:
- No negative scenarios for a CRUD feature
- No validation scenarios for a form feature
- Only happy path tested (missing unhappy paths)
- Delete feature has no cancel/confirmation test

## 10. Given Steps — Test Data Setup

### Rules
- **API for test data** — Given steps should create data via API, never UI
- **Explicit test data** — state what data exists, don't assume it
- **No hardcoded IDs** — use meaningful identifiers
- **No timestamps** — use relative descriptions
- **DataTable for multiple records** — structured data setup

```gherkin
# ❌ Hardcoded, UI-dependent
Given I navigated to the create user form and typed John in first name field

# ✅ API-based, declarative
Given a user "John Doe" exists
Given the following users exist:
  | name       | email               | role   |
  | John Doe   | john@breezeware.com | Admin  |
```

Flag if:
- Given steps navigate through UI to set up data
- Given steps reference specific UI elements
- Test data has hardcoded IDs or UUIDs
- No Given step for prerequisite data

## 11. Gherkin Syntax & Formatting

- **Consistent indentation** — 2 spaces for steps under Scenario/Background
- **Blank line** between scenarios
- **No trailing whitespace**
- **Pipe alignment** — DataTable columns aligned
- **Given/When/Then order** — never mix up the order
- **And/But for continuation** — never start with And as first step
- **No comments in scenarios** — scenario name should be self-documenting
- **Feature description** — non-empty, meaningful user story

Flag if:
- Steps start with And without a preceding Given/When/Then
- Given appears after When/Then
- Inconsistent indentation
- Excessive comments explaining what steps do (steps should be self-explanatory)

## 12. Naming Conventions

| Element | Convention | Flag If |
|---------|-----------|---------|
| Feature file | `snake_case.feature` | camelCase, PascalCase, kebab-case |
| Feature name | Title Case | ALL CAPS, lowercase |
| Scenario name | Sentence case, starts with verb/state | ALL CAPS, cryptic names |
| Tags | lowercase kebab-case | PascalCase, snake_case |
| Placeholders | camelCase in `<>` | UPPER_CASE, snake_case |
| Folder | lowercase singular | PascalCase, plural |
| Step text | First person present tense | Third person, past tense |

## Output Format

```
## Feature File Review — [feature file name]

### 🔴 Critical Issues (must fix)
- [issue + file:line + why it breaks BDD conventions + fix]

### 🟡 Warnings (should fix)
- [issue + file:line + readability/maintainability impact + fix]

### 🟢 Suggestions (nice to have)
- [improvement + reasoning + expected benefit]

### 🏷️ Tagging Issues
- [missing/incorrect tags + correct tagging strategy + fix]

### 📝 Step Quality Issues
- [imperative step + why it's bad + declarative rewrite]

### 🔗 Scenario Independence Issues
- [dependency between scenarios + how to make independent]

### 📊 Coverage Gaps
- [missing scenario types + what should be added]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always explain *why* something violates BDD principles and *what the impact*
is on readability, maintainability, and stakeholder communication.
Reference the specific Gherkin convention or anti-pattern being violated.
