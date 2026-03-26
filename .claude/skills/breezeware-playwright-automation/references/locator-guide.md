# Locator Strategy & Frontend Alignment Guide

## Locator Priority Matrix

| Priority | Playwright Method          | Selector Type       | Stability | Speed | Accessibility |
|----------|----------------------------|---------------------|-----------|-------|---------------|
| 1        | `getByTestId()`            | `data-testid`       | Highest   | Fast  | No            |
| 2        | `getByRole()`              | ARIA role + name    | High      | Fast  | Yes           |
| 3        | `getByLabel()`             | `<label>` text      | High      | Fast  | Yes           |
| 4        | `getByPlaceholder()`       | placeholder text    | Medium    | Fast  | No            |
| 5        | `getByText()`              | visible text        | Medium    | Fast  | No            |
| 6        | `getByAltText()`           | `alt` attribute     | Medium    | Fast  | Yes           |
| 7        | `getByTitle()`             | `title` attribute   | Low       | Fast  | No            |
| 8        | `locator()` (CSS)          | CSS selector        | Low       | Fast  | No            |
| 9        | XPath                      | DOM path            | Lowest    | Slow  | No            |

## Frontend data-testid Convention

Work with the frontend team to add `data-testid` attributes to key elements.
These IDs are stable, survive refactoring, and create a contract between
frontend and test automation.

### Naming Pattern

```
data-testid="{component}-{element}"
data-testid="{component}-{element}-{identifier}"
```

Always kebab-case. Never camelCase or snake_case.

### Standard Test IDs by Component Type

#### Pages & Sections
```html
<div data-testid="user-list-page">
<div data-testid="dashboard-page">
<section data-testid="recent-activity-section">
```

#### Buttons
```html
<button data-testid="create-user-btn">Create User</button>
<button data-testid="delete-user-btn-{userId}">Delete</button>
<button data-testid="submit-form-btn">Submit</button>
<button data-testid="cancel-btn">Cancel</button>
<button data-testid="confirm-btn">Confirm</button>
```

#### Form Inputs
```html
<input data-testid="first-name-input" />
<input data-testid="last-name-input" />
<input data-testid="email-input" />
<input data-testid="search-input" />
<select data-testid="role-select" />
<textarea data-testid="description-textarea" />
```

#### Tables
```html
<table data-testid="user-list-table">
  <thead data-testid="user-list-header">
  <tbody data-testid="user-list-body">
  <tr data-testid="user-row-{userId}">
```

#### Navigation
```html
<nav data-testid="main-navbar">
<aside data-testid="main-sidebar">
<a data-testid="nav-link-{pageName}">
```

#### States
```html
<div data-testid="loading-skeleton">
<div data-testid="empty-state">
<div data-testid="error-state">
```

#### Feedback
```html
<div data-testid="toast-success">
<div data-testid="toast-error">
<div data-testid="toast-warning">
<span data-testid="field-error-{fieldName}">
```

#### Modals & Dialogs
```html
<div data-testid="confirm-dialog">
<div data-testid="create-user-modal">
```

#### Pagination
```html
<nav data-testid="pagination">
<button data-testid="page-prev-btn">
<button data-testid="page-next-btn">
<span data-testid="page-info">
```

## Locator Patterns by Use Case

### Finding a specific row in a table
```java
// By data-testid with dynamic ID
page.getByTestId("user-row-" + userId);

// By text content within the table
page.getByTestId("user-list-table")
    .getByRole(AriaRole.ROW)
    .filter(new Locator.FilterOptions().setHasText("John Doe"));
```

### Clicking a button within a specific row
```java
page.getByTestId("user-list-table")
    .getByRole(AriaRole.ROW)
    .filter(new Locator.FilterOptions().setHasText("John Doe"))
    .getByRole(AriaRole.BUTTON,
            new Locator.GetByRoleOptions().setName("Edit"));
```

### Filling a form
```java
// By label (preferred for form inputs)
page.getByLabel("First Name").fill("John");
page.getByLabel("Email").fill("john@example.com");

// By test ID (when label is complex or absent)
page.getByTestId("phone-input").fill("+1234567890");
```

### Checking a dropdown/select
```java
page.getByLabel("Role").selectOption("admin");
// or
page.getByTestId("role-select").selectOption(
        new SelectOption().setLabel("Administrator"));
```

### Verifying text content
```java
// Exact match
assertThat(page.getByTestId("user-count")).hasText("42 users");

// Contains
assertThat(page.getByTestId("welcome-message"))
        .containsText("Welcome, John");

// Regex
assertThat(page.getByTestId("timestamp"))
        .hasText(Pattern.compile("\\d{4}-\\d{2}-\\d{2}"));
```

### Handling lists
```java
// Count items
int count = page.getByTestId("user-card").count();

// Get nth item
Locator thirdCard = page.getByTestId("user-card").nth(2);

// Iterate
for (Locator card : page.getByTestId("user-card").all()) {
    String name = card.getByTestId("user-name").textContent();
    // ...
}
```

### Waiting for states
```java
// Wait for loading to finish
page.getByTestId("loading-skeleton").waitFor(
        new Locator.WaitForOptions()
                .setState(WaitForSelectorState.HIDDEN)
                .setTimeout(10000));

// Wait for data to appear
page.getByTestId("user-list-table").waitFor(
        new Locator.WaitForOptions()
                .setState(WaitForSelectorState.VISIBLE));

// Wait for toast to appear and disappear
Locator toast = page.getByTestId("toast-success");
toast.waitFor(new Locator.WaitForOptions()
        .setState(WaitForSelectorState.VISIBLE));
String message = toast.textContent();
toast.waitFor(new Locator.WaitForOptions()
        .setState(WaitForSelectorState.HIDDEN)
        .setTimeout(6000));
```

### Handling modals
```java
// Wait for modal to open
Locator dialog = page.getByRole(AriaRole.DIALOG);
dialog.waitFor(new Locator.WaitForOptions()
        .setState(WaitForSelectorState.VISIBLE));

// Interact within modal scope
dialog.getByLabel("Name").fill("New Name");
dialog.getByRole(AriaRole.BUTTON,
        new Locator.GetByRoleOptions().setName("Save")).click();

// Wait for modal to close
dialog.waitFor(new Locator.WaitForOptions()
        .setState(WaitForSelectorState.HIDDEN));
```

### Handling file uploads
```java
page.getByTestId("file-upload-input")
    .setInputFiles(Paths.get("src/test/resources/testdata/sample.pdf"));
```

### Mobile viewport testing
```java
// Set viewport in context
Browser.NewContextOptions options = new Browser.NewContextOptions()
    .setViewportSize(375, 812)  // iPhone X
    .setIsMobile(true)
    .setHasTouch(true);

BrowserContext context = browser.newContext(options);
Page page = context.newPage();
```

## Anti-Patterns to Avoid

### ❌ NEVER DO THIS

```java
// XPath — fragile, unreadable
page.locator("//div[@class='user-card']/div[2]/span[1]");

// CSS with structure dependency — breaks on refactor
page.locator("#root > div > main > div:nth-child(3) > table > tbody > tr:nth-child(1)");

// Class-based selectors — change with styling
page.locator(".MuiButton-containedPrimary");
page.locator(".css-1a2b3c");

// Index-based without context — fragile
page.locator("button").nth(3);

// Thread.sleep — flaky, slow
Thread.sleep(5000);
page.locator(".result").textContent();
```

### ✅ DO THIS INSTEAD

```java
// data-testid — stable contract
page.getByTestId("create-user-btn");

// Role-based — accessible, user-facing
page.getByRole(AriaRole.BUTTON,
        new Page.GetByRoleOptions().setName("Create User"));

// Label-based — accessible
page.getByLabel("Email");

// Filtered locator — contextual
page.getByTestId("user-list-table")
    .getByRole(AriaRole.ROW)
    .filter(new Locator.FilterOptions().setHasText("John"))
    .getByRole(AriaRole.BUTTON,
            new Locator.GetByRoleOptions().setName("Edit"));

// Auto-wait — Playwright handles timing
page.getByTestId("result").textContent(); // Auto-waits
```

## Coordinating with Frontend Team

### What to Ask For
1. Add `data-testid` to all interactive elements (buttons, inputs, links)
2. Add `data-testid` to all data display elements (tables, cards, lists)
3. Add `data-testid` to all state indicators (loading, empty, error)
4. Add `data-testid` to all feedback elements (toasts, alerts, validation errors)
5. Follow the `{component}-{element}` naming convention
6. Never remove a `data-testid` without notifying the test team

### What NOT to Depend On
1. CSS class names — they change with styling/framework updates
2. DOM structure — it changes with component refactoring
3. Text content — it changes with copy updates (use for assertions, not locators)
4. Auto-generated IDs — they change between renders
5. Attribute order — it's not guaranteed
