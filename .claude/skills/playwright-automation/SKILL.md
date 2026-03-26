---
name: playwright-automation
description: Breezeware Java Playwright automation testing skill with JUnit 5, Cucumber BDD, Page Object Model, and Allure reporting. Use this skill when creating test automation frameworks, writing E2E tests, browser tests, UI tests, Cucumber feature files, step definitions, page objects, or test utilities. Also trigger when the user says automation test, Playwright, E2E test, browser test, Cucumber, feature file, page object, test framework, BDD, or anything related to test automation.
---

# Breezeware Java Playwright Automation Skill

You are a senior test automation architect with 30 years of experience building
enterprise-grade, maintainable, scalable test automation frameworks. You write
tests that are reliable, fast, self-documenting, and aligned with the frontend
structure. Every test you write follows the Page Object Model, uses resilient
locators, and produces crystal-clear reports. No flaky tests. No magic waits.
No hardcoded values.

## Tech Stack

- **Java 21** (records, sealed classes, pattern matching, text blocks)
- **Playwright for Java** (latest stable — cross-browser automation)
- **JUnit 5** (Jupiter — test runner, parameterized tests, extensions)
- **Cucumber 7** (BDD — Gherkin feature files, step definitions)
- **Allure Report** (rich HTML reports with screenshots, steps, attachments)
- **Maven** (build tool, dependency management, Surefire/Failsafe plugins)
- **AssertJ** (fluent assertions — readable, chainable)
- **Lombok** (`@Slf4j` for logging, `@Builder` for test data)
- **Owner** (type-safe configuration from properties files)
- **JavaFaker** (realistic test data generation)

---

## Project Structure

```
src/
├── test/
│   ├── java/
│   │   └── com/breezeware/automation/
│   │       ├── config/                    # Framework configuration
│   │       │   ├── BrowserConfig.java     # Browser setup (Chromium, Firefox, WebKit)
│   │       │   ├── EnvironmentConfig.java # Environment URLs, credentials
│   │       │   ├── PlaywrightManager.java # Playwright lifecycle management
│   │       │   └── TestConfig.java        # Owner-based config loader
│   │       │
│   │       ├── pages/                     # Page Object Model
│   │       │   ├── BasePage.java          # Common page methods
│   │       │   ├── components/            # Reusable UI component objects
│   │       │   │   ├── NavbarComponent.java
│   │       │   │   ├── SidebarComponent.java
│   │       │   │   ├── DataTableComponent.java
│   │       │   │   ├── ModalComponent.java
│   │       │   │   ├── FormComponent.java
│   │       │   │   └── ToastComponent.java
│   │       │   ├── auth/
│   │       │   │   ├── LoginPage.java
│   │       │   │   └── RegisterPage.java
│   │       │   ├── dashboard/
│   │       │   │   └── DashboardPage.java
│   │       │   └── users/
│   │       │       ├── UserListPage.java
│   │       │       ├── UserDetailPage.java
│   │       │       └── CreateUserPage.java
│   │       │
│   │       ├── steps/                     # Cucumber step definitions
│   │       │   ├── CommonSteps.java       # Shared Given/When/Then steps
│   │       │   ├── AuthSteps.java
│   │       │   ├── UserSteps.java
│   │       │   └── DashboardSteps.java
│   │       │
│   │       ├── hooks/                     # Cucumber hooks (Before/After)
│   │       │   ├── CucumberHooks.java     # Scenario hooks (screenshot on failure)
│   │       │   └── PlaywrightHooks.java   # Browser lifecycle hooks
│   │       │
│   │       ├── runners/                   # Test runners
│   │       │   ├── CucumberRunner.java    # Cucumber test runner
│   │       │   └── SmokeTestRunner.java   # Smoke suite runner
│   │       │
│   │       ├── factory/                   # Test data factories
│   │       │   ├── UserFactory.java
│   │       │   ├── OrderFactory.java
│   │       │   └── TestDataFactory.java
│   │       │
│   │       ├── utils/                     # Utility classes
│   │       │   ├── WaitUtils.java         # Smart wait helpers
│   │       │   ├── ScreenshotUtils.java   # Screenshot capture
│   │       │   ├── AllureUtils.java       # Allure step/attachment helpers
│   │       │   ├── ApiUtils.java          # API helpers for test setup/teardown
│   │       │   ├── DateUtils.java         # Date formatting/generation
│   │       │   └── RetryUtils.java        # Flaky test retry logic
│   │       │
│   │       └── constants/                 # Constants
│   │           ├── Endpoints.java         # URL paths
│   │           ├── TestGroups.java        # JUnit tags (smoke, regression, etc.)
│   │           └── ErrorMessages.java     # Expected error messages
│   │
│   └── resources/
│       ├── features/                      # Cucumber feature files
│       │   ├── auth/
│       │   │   ├── login.feature
│       │   │   └── registration.feature
│       │   ├── users/
│       │   │   ├── user_list.feature
│       │   │   ├── create_user.feature
│       │   │   └── edit_user.feature
│       │   └── dashboard/
│       │       └── dashboard.feature
│       │
│       ├── config/
│       │   ├── config.properties          # Default config
│       │   ├── config-dev.properties      # Dev environment
│       │   ├── config-staging.properties  # Staging environment
│       │   └── config-prod.properties     # Prod (read-only tests only)
│       │
│       ├── testdata/
│       │   ├── users.json                 # Static test data
│       │   └── orders.json
│       │
│       └── allure.properties             # Allure config
```

### Structure Rules
1. **Page Object Model** — every page/component gets its own class
2. **Feature-aligned packages** — pages, steps, and features mirror the app's feature structure
3. **Components for reusable UI** — `DataTableComponent`, `ModalComponent`, etc.
4. **Factories for test data** — never hardcode test data in tests
5. **Config externalized** — all URLs, credentials, timeouts in properties files
6. **One step definition class per feature area** — `AuthSteps`, `UserSteps`, etc.
7. **Hooks separated** — browser lifecycle and scenario hooks in separate classes

---

## Locator Strategy — Frontend-Aligned

### Locator Priority (Best to Worst)

| Priority | Locator Type               | Example                                    | Why                                    |
|----------|----------------------------|--------------------------------------------|----------------------------------------|
| 1        | `data-testid`              | `page.getByTestId("user-list-table")`      | Stable, decoupled from UI changes      |
| 2        | `getByRole` + name         | `page.getByRole(AriaRole.BUTTON, ...)`     | Accessible, user-facing                |
| 3        | `getByLabel`               | `page.getByLabel("Email")`                 | Form inputs with labels                |
| 4        | `getByPlaceholder`         | `page.getByPlaceholder("Search...")`       | Inputs without visible labels          |
| 5        | `getByText`                | `page.getByText("Submit")`                 | Visible text (buttons, headings)       |
| 6        | CSS selector               | `page.locator(".user-card")`               | Last resort — fragile                  |

### Locator Rules — MANDATORY
1. **NEVER use XPath** — fragile, slow, unreadable
2. **NEVER use auto-generated selectors** — `#root > div > div:nth-child(3)`
3. **NEVER use CSS class names for logic** — they change with styling
4. **Prefer `data-testid`** — coordinate with frontend team to add them
5. **Use role-based locators** — mirrors how users interact with the UI
6. **Chain locators** — `page.getByTestId("user-row").getByRole(AriaRole.BUTTON, ...)`
7. **Use `filter()`** — for narrowing within a list: `.filter(new Locator.FilterOptions().setHasText("John"))`

### Frontend `data-testid` Convention

Coordinate with the React frontend team. Every testable element should have:

```jsx
// Frontend convention — add data-testid to key elements
<button data-testid="create-user-btn">Create User</button>
<table data-testid="user-list-table">...</table>
<input data-testid="email-input" />
<div data-testid="user-card-{userId}">...</div>
<div data-testid="empty-state">...</div>
<div data-testid="loading-skeleton">...</div>
<div data-testid="error-state">...</div>
<div data-testid="toast-success">...</div>
<div data-testid="toast-error">...</div>
```

**Naming convention for `data-testid`:**
- `{component}-{element}` — `user-list-table`, `create-user-btn`
- `{component}-{element}-{identifier}` — `user-card-123`, `delete-btn-456`
- kebab-case always — `login-form`, not `loginForm` or `login_form`

---

## Base Page Object

```java
package com.breezeware.automation.pages;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;
import com.microsoft.playwright.options.WaitForSelectorState;

import io.qameta.allure.Step;

import lombok.extern.slf4j.Slf4j;

/**
 * Base class for all Page Objects. Provides common interactions
 * and smart waits shared across all pages.
 */
@Slf4j
public abstract class BasePage {

    protected final Page page;

    protected BasePage(Page page) {
        this.page = page;
    }

    /**
     * Navigates to the page URL.
     *
     * @param path the relative URL path
     */
    @Step("Navigate to {path}")
    protected void navigateTo(String path) {
        log.info("Navigating to: {}", path);
        page.navigate(path);
        waitForPageLoad();
    }

    /**
     * Waits for the page to reach network idle state.
     */
    protected void waitForPageLoad() {
        page.waitForLoadState();
    }

    /**
     * Clicks a button identified by its visible text.
     *
     * @param buttonText the button's visible text
     */
    @Step("Click button: {buttonText}")
    protected void clickButton(String buttonText) {
        log.info("Clicking button: {}", buttonText);
        page.getByRole(AriaRole.BUTTON,
                new Page.GetByRoleOptions().setName(buttonText))
                .click();
    }

    /**
     * Fills an input field identified by its label.
     *
     * @param label the input label text
     * @param value the value to enter
     */
    @Step("Fill '{label}' with '{value}'")
    protected void fillByLabel(String label, String value) {
        log.info("Filling '{}' with '{}'", label, value);
        page.getByLabel(label).fill(value);
    }

    /**
     * Fills an input field identified by its test ID.
     *
     * @param testId the data-testid attribute
     * @param value  the value to enter
     */
    @Step("Fill test ID '{testId}' with '{value}'")
    protected void fillByTestId(String testId, String value) {
        log.info("Filling testId='{}' with '{}'", testId, value);
        page.getByTestId(testId).fill(value);
    }

    /**
     * Clicks an element identified by its test ID.
     *
     * @param testId the data-testid attribute
     */
    @Step("Click element: {testId}")
    protected void clickByTestId(String testId) {
        log.info("Clicking testId='{}'", testId);
        page.getByTestId(testId).click();
    }

    /**
     * Returns the text content of an element by test ID.
     *
     * @param testId the data-testid attribute
     * @return the text content
     */
    protected String getTextByTestId(String testId) {
        return page.getByTestId(testId).textContent().trim();
    }

    /**
     * Checks if an element identified by test ID is visible.
     *
     * @param testId the data-testid attribute
     * @return true if visible
     */
    protected boolean isVisibleByTestId(String testId) {
        return page.getByTestId(testId).isVisible();
    }

    /**
     * Waits for an element to be visible.
     *
     * @param testId  the data-testid attribute
     * @param timeout timeout in milliseconds
     */
    protected void waitForVisible(String testId, double timeout) {
        page.getByTestId(testId).waitFor(
                new Locator.WaitForOptions()
                        .setState(WaitForSelectorState.VISIBLE)
                        .setTimeout(timeout));
    }

    /**
     * Waits for an element to be hidden.
     *
     * @param testId  the data-testid attribute
     * @param timeout timeout in milliseconds
     */
    protected void waitForHidden(String testId, double timeout) {
        page.getByTestId(testId).waitFor(
                new Locator.WaitForOptions()
                        .setState(WaitForSelectorState.HIDDEN)
                        .setTimeout(timeout));
    }

    /**
     * Takes a screenshot and attaches it to the Allure report.
     *
     * @param name the screenshot name
     * @return the screenshot bytes
     */
    @Step("Take screenshot: {name}")
    protected byte[] takeScreenshot(String name) {
        return page.screenshot(new Page.ScreenshotOptions().setFullPage(true));
    }

    /**
     * Returns the current page URL.
     */
    protected String getCurrentUrl() {
        return page.url();
    }

    /**
     * Returns the page title.
     */
    protected String getPageTitle() {
        return page.title();
    }

    /**
     * Waits for a specific URL pattern.
     *
     * @param urlPattern regex or glob pattern
     */
    protected void waitForUrl(String urlPattern) {
        page.waitForURL(urlPattern);
    }

    /**
     * Retrieves a locator for a table row containing specific text.
     *
     * @param tableTestId the table's data-testid
     * @param rowText     the text to match in the row
     * @return the matching row locator
     */
    protected Locator getTableRow(String tableTestId, String rowText) {
        return page.getByTestId(tableTestId)
                .getByRole(AriaRole.ROW)
                .filter(new Locator.FilterOptions().setHasText(rowText));
    }
}
```

---

## Page Object Template

```java
package com.breezeware.automation.pages.users;

import com.breezeware.automation.pages.BasePage;
import com.breezeware.automation.pages.components.DataTableComponent;
import com.breezeware.automation.pages.components.ToastComponent;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;

import io.qameta.allure.Step;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

/**
 * Page Object for the User List page (/users).
 */
@Slf4j
public class UserListPage extends BasePage {

    private static final String URL_PATH = "/users";

    @Getter
    private final DataTableComponent dataTable;

    @Getter
    private final ToastComponent toast;

    public UserListPage(Page page) {
        super(page);
        this.dataTable = new DataTableComponent(page, "user-list-table");
        this.toast = new ToastComponent(page);
    }

    /**
     * Opens the user list page.
     *
     * @return this page object for chaining
     */
    @Step("Open User List page")
    public UserListPage open() {
        navigateTo(URL_PATH);
        waitForVisible("user-list-table", 10000);
        log.info("User List page loaded");
        return this;
    }

    /**
     * Clicks the Create User button.
     *
     * @return the Create User page object
     */
    @Step("Click Create User button")
    public CreateUserPage clickCreateUser() {
        clickByTestId("create-user-btn");
        return new CreateUserPage(page);
    }

    /**
     * Searches for a user by name or email.
     *
     * @param query the search text
     * @return this page object for chaining
     */
    @Step("Search for user: {query}")
    public UserListPage searchUser(String query) {
        fillByTestId("search-input", query);
        // Wait for debounced search to trigger
        page.waitForTimeout(500);
        waitForPageLoad();
        return this;
    }

    /**
     * Returns the number of rows in the user table.
     *
     * @return row count
     */
    @Step("Get user count from table")
    public int getUserCount() {
        return dataTable.getRowCount();
    }

    /**
     * Checks if a user with the given name exists in the table.
     *
     * @param userName the user name to check
     * @return true if user is found
     */
    @Step("Check if user '{userName}' exists in table")
    public boolean isUserPresent(String userName) {
        return dataTable.hasRowWithText(userName);
    }

    /**
     * Clicks the delete button for a specific user.
     *
     * @param userName the user name
     * @return this page object for chaining
     */
    @Step("Delete user: {userName}")
    public UserListPage deleteUser(String userName) {
        Locator row = getTableRow("user-list-table", userName);
        row.getByRole(AriaRole.BUTTON,
                new Locator.GetByRoleOptions().setName("Delete")).click();

        // Confirm deletion in modal
        clickButton("Confirm");
        log.info("Deleted user: {}", userName);
        return this;
    }

    /**
     * Checks if the empty state is displayed.
     *
     * @return true if empty state is visible
     */
    @Step("Check if empty state is shown")
    public boolean isEmptyStateVisible() {
        return isVisibleByTestId("empty-state");
    }

    /**
     * Checks if the loading skeleton is displayed.
     *
     * @return true if loading skeleton is visible
     */
    @Step("Check if loading state is shown")
    public boolean isLoadingVisible() {
        return isVisibleByTestId("loading-skeleton");
    }
}
```

### Page Object Rules
1. **Extend `BasePage`** — all page objects inherit common methods
2. **Encapsulate locators** — never expose raw `Locator` objects outside the page
3. **Return page objects** — methods that navigate return the destination page object
4. **Return `this` for chaining** — methods that stay on the same page return `this`
5. **`@Step` annotation** — on every public method for Allure reporting
6. **`@Slf4j` logging** — log every significant action
7. **Component composition** — use `DataTableComponent`, `ToastComponent`, etc. as fields
8. **No assertions in page objects** — assertions belong in step definitions or tests
9. **No `Thread.sleep()`** — use Playwright's auto-wait or explicit `waitFor*` methods
10. **Constants for URLs** — define `URL_PATH` as a class constant

---

## Reusable Component Objects

```java
package com.breezeware.automation.pages.components;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;

import io.qameta.allure.Step;

import lombok.extern.slf4j.Slf4j;

/**
 * Component object for DataTable interactions.
 * Maps to the frontend DataTable component with desktop table and mobile cards.
 */
@Slf4j
public class DataTableComponent {

    private final Page page;
    private final String tableTestId;

    public DataTableComponent(Page page, String tableTestId) {
        this.page = page;
        this.tableTestId = tableTestId;
    }

    /**
     * Returns the number of data rows in the table.
     */
    @Step("Get row count from table '{tableTestId}'")
    public int getRowCount() {
        Locator rows = page.getByTestId(tableTestId)
                .getByRole(AriaRole.ROW);
        // Subtract header row
        return rows.count() - 1;
    }

    /**
     * Checks if a row containing the given text exists.
     *
     * @param text the text to search for
     * @return true if a matching row is found
     */
    @Step("Check if table has row with text: {text}")
    public boolean hasRowWithText(String text) {
        Locator row = page.getByTestId(tableTestId)
                .getByRole(AriaRole.ROW)
                .filter(new Locator.FilterOptions().setHasText(text));
        return row.count() > 0;
    }

    /**
     * Returns the cell text for a given row and column.
     *
     * @param rowIndex    zero-based row index (excluding header)
     * @param columnIndex zero-based column index
     * @return the cell text content
     */
    @Step("Get cell text at row {rowIndex}, column {columnIndex}")
    public String getCellText(int rowIndex, int columnIndex) {
        return page.getByTestId(tableTestId)
                .getByRole(AriaRole.ROW)
                .nth(rowIndex + 1) // skip header
                .getByRole(AriaRole.CELL)
                .nth(columnIndex)
                .textContent()
                .trim();
    }

    /**
     * Clicks a button within a specific row.
     *
     * @param rowText    text to identify the row
     * @param buttonName the button's accessible name
     */
    @Step("Click '{buttonName}' button in row containing '{rowText}'")
    public void clickRowButton(String rowText, String buttonName) {
        page.getByTestId(tableTestId)
                .getByRole(AriaRole.ROW)
                .filter(new Locator.FilterOptions().setHasText(rowText))
                .getByRole(AriaRole.BUTTON,
                        new Locator.GetByRoleOptions().setName(buttonName))
                .click();
    }

    /**
     * Navigates to a specific page in the pagination.
     *
     * @param pageNumber the page number to navigate to
     */
    @Step("Navigate to page {pageNumber}")
    public void goToPage(int pageNumber) {
        page.getByRole(AriaRole.BUTTON,
                new Page.GetByRoleOptions().setName(String.valueOf(pageNumber)))
                .click();
    }
}
```

```java
package com.breezeware.automation.pages.components;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.WaitForSelectorState;

import io.qameta.allure.Step;

import lombok.extern.slf4j.Slf4j;

/**
 * Component object for toast notification interactions.
 * Maps to the frontend Sonner/Toast component.
 */
@Slf4j
public class ToastComponent {

    private final Page page;

    public ToastComponent(Page page) {
        this.page = page;
    }

    /**
     * Waits for a success toast and returns its message.
     *
     * @return the toast message text
     */
    @Step("Wait for success toast")
    public String getSuccessMessage() {
        Locator toast = page.getByTestId("toast-success");
        toast.waitFor(new Locator.WaitForOptions()
                .setState(WaitForSelectorState.VISIBLE)
                .setTimeout(5000));
        String message = toast.textContent().trim();
        log.info("Success toast: {}", message);
        return message;
    }

    /**
     * Waits for an error toast and returns its message.
     *
     * @return the toast message text
     */
    @Step("Wait for error toast")
    public String getErrorMessage() {
        Locator toast = page.getByTestId("toast-error");
        toast.waitFor(new Locator.WaitForOptions()
                .setState(WaitForSelectorState.VISIBLE)
                .setTimeout(5000));
        String message = toast.textContent().trim();
        log.info("Error toast: {}", message);
        return message;
    }

    /**
     * Checks if a success toast is currently visible.
     *
     * @return true if visible
     */
    public boolean isSuccessVisible() {
        return page.getByTestId("toast-success").isVisible();
    }

    /**
     * Checks if an error toast is currently visible.
     *
     * @return true if visible
     */
    public boolean isErrorVisible() {
        return page.getByTestId("toast-error").isVisible();
    }
}
```

```java
package com.breezeware.automation.pages.components;

import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;

import io.qameta.allure.Step;

import lombok.extern.slf4j.Slf4j;

/**
 * Component object for modal/dialog interactions.
 * Maps to the frontend Dialog/Modal component.
 */
@Slf4j
public class ModalComponent {

    private final Page page;

    public ModalComponent(Page page) {
        this.page = page;
    }

    /**
     * Checks if the modal is currently visible.
     *
     * @return true if modal is open
     */
    public boolean isOpen() {
        return page.getByRole(AriaRole.DIALOG).isVisible();
    }

    /**
     * Returns the modal title text.
     *
     * @return the title text
     */
    @Step("Get modal title")
    public String getTitle() {
        return page.getByRole(AriaRole.DIALOG)
                .getByRole(AriaRole.HEADING)
                .textContent()
                .trim();
    }

    /**
     * Clicks the confirm/primary button in the modal.
     *
     * @param buttonText the button text
     */
    @Step("Click modal button: {buttonText}")
    public void clickButton(String buttonText) {
        page.getByRole(AriaRole.DIALOG)
                .getByRole(AriaRole.BUTTON,
                        new Page.GetByRoleOptions().setName(buttonText))
                .click();
        log.info("Clicked modal button: {}", buttonText);
    }

    /**
     * Closes the modal via the close button or Escape key.
     */
    @Step("Close modal")
    public void close() {
        page.keyboard().press("Escape");
        log.info("Modal closed");
    }
}
```

---

## Cucumber Feature File Template

```gherkin
# features/users/create_user.feature
@users @regression
Feature: Create User
  As an admin
  I want to create new users
  So that team members can access the system

  Background:
    Given I am logged in as an admin
    And I am on the User List page

  @smoke @positive
  Scenario: Successfully create a new user
    When I click the "Create User" button
    And I fill in the user form with valid data:
      | firstName | lastName | email              |
      | John      | Doe      | john@breezeware.com |
    And I click the "Create User" submit button
    Then I should see a success toast "User created successfully"
    And the user "John Doe" should appear in the user list

  @positive
  Scenario Outline: Create users with different roles
    When I click the "Create User" button
    And I fill in the user form:
      | firstName   | lastName   | email   | role   |
      | <firstName> | <lastName> | <email> | <role> |
    And I click the "Create User" submit button
    Then I should see a success toast "User created successfully"

    Examples:
      | firstName | lastName | email                  | role    |
      | Alice     | Smith    | alice@breezeware.com   | admin   |
      | Bob       | Jones    | bob@breezeware.com     | member  |
      | Carol     | Davis    | carol@breezeware.com   | viewer  |

  @negative @validation
  Scenario: Cannot create user with empty required fields
    When I click the "Create User" button
    And I click the "Create User" submit button without filling the form
    Then I should see validation errors:
      | field     | message                 |
      | firstName | First name is required  |
      | lastName  | Last name is required   |
      | email     | Email is required       |

  @negative @validation
  Scenario: Cannot create user with invalid email
    When I click the "Create User" button
    And I fill in the user form with:
      | firstName | lastName | email         |
      | John      | Doe      | invalid-email |
    And I click the "Create User" submit button
    Then I should see validation error "Please enter a valid email" for "email"

  @negative @duplicate
  Scenario: Cannot create user with duplicate email
    Given a user with email "existing@breezeware.com" already exists
    When I click the "Create User" button
    And I fill in the user form with:
      | firstName | lastName | email                    |
      | New       | User     | existing@breezeware.com  |
    And I click the "Create User" submit button
    Then I should see an error toast "User with this email already exists"

  @edge-case
  Scenario: Create user with maximum length fields
    When I click the "Create User" button
    And I fill in the user form with 100-character first name
    And I fill in the user form with 100-character last name
    And I fill in a valid email
    And I click the "Create User" submit button
    Then I should see a success toast "User created successfully"
```

### Feature File Rules
1. **One feature per file** — `create_user.feature`, `login.feature`
2. **Feature-level tags** — `@users`, `@auth`, `@dashboard` for filtering
3. **Priority tags** — `@smoke`, `@regression`, `@critical`
4. **Type tags** — `@positive`, `@negative`, `@edge-case`, `@validation`
5. **Background for shared setup** — login, navigation to page
6. **Declarative steps** — describe WHAT, not HOW (`I create a user` not `I click the name field and type John`)
7. **Scenario Outline for data-driven** — with `Examples` table
8. **DataTable for structured input** — `| field | value |` format
9. **No implementation details** — no CSS selectors, no XPaths, no HTML in features
10. **Business language** — readable by non-technical stakeholders

---

## Step Definition Template

```java
package com.breezeware.automation.steps;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Map;

import com.breezeware.automation.factory.UserFactory;
import com.breezeware.automation.pages.users.CreateUserPage;
import com.breezeware.automation.pages.users.UserListPage;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import io.qameta.allure.Step;

import lombok.extern.slf4j.Slf4j;

/**
 * Step definitions for user management scenarios.
 */
@Slf4j
public class UserSteps {

    private final UserListPage userListPage;
    private final CreateUserPage createUserPage;

    public UserSteps(UserListPage userListPage, CreateUserPage createUserPage) {
        this.userListPage = userListPage;
        this.createUserPage = createUserPage;
    }

    @Given("I am on the User List page")
    public void iAmOnTheUserListPage() {
        userListPage.open();
    }

    @When("I click the {string} button")
    public void iClickTheButton(String buttonText) {
        if ("Create User".equals(buttonText)) {
            userListPage.clickCreateUser();
        }
    }

    @When("I fill in the user form with valid data:")
    public void iFillInTheUserFormWithValidData(DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        createUserPage
                .fillFirstName(data.get("firstName"))
                .fillLastName(data.get("lastName"))
                .fillEmail(data.get("email"));
    }

    @When("I click the {string} submit button")
    public void iClickTheSubmitButton(String buttonText) {
        createUserPage.clickSubmit();
    }

    @When("I click the {string} submit button without filling the form")
    public void iClickSubmitWithoutFilling(String buttonText) {
        createUserPage.clickSubmit();
    }

    @Then("I should see a success toast {string}")
    public void iShouldSeeASuccessToast(String expectedMessage) {
        String actualMessage = userListPage.getToast().getSuccessMessage();
        assertThat(actualMessage)
                .as("Success toast message")
                .contains(expectedMessage);
    }

    @Then("I should see an error toast {string}")
    public void iShouldSeeAnErrorToast(String expectedMessage) {
        String actualMessage = userListPage.getToast().getErrorMessage();
        assertThat(actualMessage)
                .as("Error toast message")
                .contains(expectedMessage);
    }

    @Then("the user {string} should appear in the user list")
    public void theUserShouldAppearInTheUserList(String userName) {
        assertThat(userListPage.isUserPresent(userName))
                .as("User '%s' should be in the list", userName)
                .isTrue();
    }

    @Then("I should see validation errors:")
    public void iShouldSeeValidationErrors(DataTable dataTable) {
        List<Map<String, String>> errors = dataTable.asMaps();
        for (Map<String, String> error : errors) {
            String field = error.get("field");
            String message = error.get("message");
            assertThat(createUserPage.getFieldError(field))
                    .as("Validation error for field '%s'", field)
                    .isEqualTo(message);
        }
    }

    @Then("I should see validation error {string} for {string}")
    public void iShouldSeeValidationErrorFor(String message, String field) {
        assertThat(createUserPage.getFieldError(field))
                .as("Validation error for field '%s'", field)
                .isEqualTo(message);
    }

    @Given("a user with email {string} already exists")
    public void aUserWithEmailAlreadyExists(String email) {
        // Use API to create user for test setup (faster than UI)
        UserFactory.createViaApi(email);
        log.info("Created test user with email: {}", email);
    }
}
```

### Step Definition Rules
1. **Constructor injection** — receive page objects via Cucumber PicoContainer
2. **Declarative step names** — match the Gherkin exactly
3. **AssertJ assertions** — fluent, readable, with `.as()` descriptions
4. **No page object creation in steps** — inject via constructor
5. **DataTable for structured input** — use `dataTable.asMaps()` or `dataTable.asLists()`
6. **API for test data setup** — use API calls in `@Given` steps, not UI clicks
7. **One assertion per `@Then`** — keep steps focused
8. **`@Slf4j` logging** — log significant actions
9. **No `Thread.sleep()`** — never, ever

---

## Cucumber Hooks

```java
package com.breezeware.automation.hooks;

import com.breezeware.automation.config.PlaywrightManager;

import com.microsoft.playwright.Page;

import io.cucumber.java.After;
import io.cucumber.java.AfterStep;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

import io.qameta.allure.Allure;

import lombok.extern.slf4j.Slf4j;

/**
 * Cucumber lifecycle hooks for scenario setup and teardown.
 */
@Slf4j
public class CucumberHooks {

    private Page page;

    @Before
    public void setUp(Scenario scenario) {
        log.info("Starting scenario: {}", scenario.getName());
        page = PlaywrightManager.getPage();
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            log.error("Scenario FAILED: {}", scenario.getName());
            captureScreenshot(scenario);
            capturePageSource(scenario);
            captureConsoleErrors(scenario);
        }
        log.info("Finished scenario: {} — Status: {}",
                scenario.getName(), scenario.getStatus());
        PlaywrightManager.closePage();
    }

    @AfterStep
    public void afterStep(Scenario scenario) {
        if (scenario.isFailed()) {
            captureScreenshot(scenario);
        }
    }

    private void captureScreenshot(Scenario scenario) {
        try {
            byte[] screenshot = page.screenshot(
                    new Page.ScreenshotOptions().setFullPage(true));
            scenario.attach(screenshot, "image/png",
                    "Screenshot — " + scenario.getName());
            Allure.addAttachment("Screenshot", "image/png",
                    new java.io.ByteArrayInputStream(screenshot), ".png");
        } catch (Exception ex) {
            log.warn("Failed to capture screenshot: {}", ex.getMessage());
        }
    }

    private void capturePageSource(Scenario scenario) {
        try {
            String html = page.content();
            Allure.addAttachment("Page Source", "text/html", html);
        } catch (Exception ex) {
            log.warn("Failed to capture page source: {}", ex.getMessage());
        }
    }

    private void captureConsoleErrors(Scenario scenario) {
        // Console errors are captured via page.onConsoleMessage in PlaywrightManager
    }
}
```

---

## Playwright Manager (Browser Lifecycle)

```java
package com.breezeware.automation.config;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;

import lombok.extern.slf4j.Slf4j;

/**
 * Manages Playwright browser lifecycle with thread-safe context per test.
 */
@Slf4j
public final class PlaywrightManager {

    private static final ThreadLocal<Playwright> PLAYWRIGHT = new ThreadLocal<>();
    private static final ThreadLocal<Browser> BROWSER = new ThreadLocal<>();
    private static final ThreadLocal<BrowserContext> CONTEXT = new ThreadLocal<>();
    private static final ThreadLocal<Page> PAGE = new ThreadLocal<>();

    private PlaywrightManager() {
        // Utility class
    }

    /**
     * Initializes Playwright and launches the configured browser.
     */
    public static void initBrowser() {
        Playwright pw = Playwright.create();
        PLAYWRIGHT.set(pw);

        String browserName = TestConfig.get().browserName();
        boolean headless = TestConfig.get().headless();
        int slowMo = TestConfig.get().slowMo();

        BrowserType browserType = switch (browserName.toLowerCase()) {
            case "firefox" -> pw.firefox();
            case "webkit" -> pw.webkit();
            default -> pw.chromium();
        };

        Browser browser = browserType.launch(
                new BrowserType.LaunchOptions()
                        .setHeadless(headless)
                        .setSlowMo(slowMo));

        BROWSER.set(browser);
        log.info("Browser launched: {} (headless={})", browserName, headless);
    }

    /**
     * Creates a new browser context and page for the current test.
     *
     * @return the new page
     */
    public static Page getPage() {
        if (BROWSER.get() == null) {
            initBrowser();
        }

        BrowserContext context = BROWSER.get().newContext(
                new Browser.NewContextOptions()
                        .setBaseURL(TestConfig.get().baseUrl())
                        .setViewportSize(TestConfig.get().viewportWidth(),
                                TestConfig.get().viewportHeight())
                        .setLocale("en-US")
                        .setTimezoneId("America/New_York")
                        .setRecordVideoDir(
                                TestConfig.get().recordVideo()
                                        ? java.nio.file.Paths.get("target/videos/")
                                        : null));

        // Capture console errors
        Page page = context.newPage();
        page.onConsoleMessage(msg -> {
            if ("error".equals(msg.type())) {
                log.error("Browser console error: {}", msg.text());
            }
        });

        CONTEXT.set(context);
        PAGE.set(page);
        return page;
    }

    /**
     * Closes the current page and context.
     */
    public static void closePage() {
        if (PAGE.get() != null) {
            PAGE.get().close();
            PAGE.remove();
        }
        if (CONTEXT.get() != null) {
            CONTEXT.get().close();
            CONTEXT.remove();
        }
    }

    /**
     * Closes the browser and Playwright instance.
     */
    public static void closeBrowser() {
        closePage();
        if (BROWSER.get() != null) {
            BROWSER.get().close();
            BROWSER.remove();
        }
        if (PLAYWRIGHT.get() != null) {
            PLAYWRIGHT.get().close();
            PLAYWRIGHT.remove();
        }
        log.info("Browser closed");
    }
}
```

---

## Test Configuration (Owner Library)

```java
package com.breezeware.automation.config;

import org.aeonbits.owner.Config;
import org.aeonbits.owner.Config.LoadPolicy;
import org.aeonbits.owner.Config.LoadType;
import org.aeonbits.owner.Config.Sources;
import org.aeonbits.owner.ConfigFactory;

/**
 * Type-safe configuration loaded from properties files.
 * Environment is determined by the system property 'env' (default: dev).
 */
@LoadPolicy(LoadType.MERGE)
@Sources({
    "classpath:config/config-${env}.properties",
    "classpath:config/config.properties"
})
public interface TestConfig extends Config {

    @Key("base.url")
    @DefaultValue("http://localhost:5173")
    String baseUrl();

    @Key("browser.name")
    @DefaultValue("chromium")
    String browserName();

    @Key("browser.headless")
    @DefaultValue("true")
    boolean headless();

    @Key("browser.slow.mo")
    @DefaultValue("0")
    int slowMo();

    @Key("viewport.width")
    @DefaultValue("1280")
    int viewportWidth();

    @Key("viewport.height")
    @DefaultValue("720")
    int viewportHeight();

    @Key("timeout.default")
    @DefaultValue("30000")
    int defaultTimeout();

    @Key("timeout.element")
    @DefaultValue("10000")
    int elementTimeout();

    @Key("admin.username")
    String adminUsername();

    @Key("admin.password")
    String adminPassword();

    @Key("api.base.url")
    @DefaultValue("http://localhost:8080/api/v1")
    String apiBaseUrl();

    @Key("record.video")
    @DefaultValue("false")
    boolean recordVideo();

    @Key("retry.count")
    @DefaultValue("1")
    int retryCount();

    static TestConfig get() {
        return ConfigFactory.create(TestConfig.class,
                System.getProperties(),
                System.getenv());
    }
}
```

```properties
# config/config-dev.properties
base.url=http://localhost:5173
api.base.url=http://localhost:8080/api/v1
admin.username=admin@breezeware.com
admin.password=admin123
browser.headless=false
browser.slow.mo=50

# config/config-staging.properties
base.url=https://staging.breezeware.com
api.base.url=https://staging-api.breezeware.com/api/v1
admin.username=admin@breezeware.com
admin.password=${STAGING_ADMIN_PASSWORD}
browser.headless=true
```

---

## Test Data Factory

```java
package com.breezeware.automation.factory;

import java.util.UUID;

import com.github.javafaker.Faker;

import com.breezeware.automation.config.TestConfig;
import com.breezeware.automation.utils.ApiUtils;

import lombok.Builder;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

/**
 * Factory for generating realistic test user data.
 */
@Slf4j
public final class UserFactory {

    private static final Faker FAKER = new Faker();

    private UserFactory() {
    }

    /**
     * Generates a random user data object.
     *
     * @return a new UserData instance with random values
     */
    public static UserData random() {
        return UserData.builder()
                .firstName(FAKER.name().firstName())
                .lastName(FAKER.name().lastName())
                .email(FAKER.internet().emailAddress())
                .phone(FAKER.phoneNumber().cellPhone())
                .role("member")
                .build();
    }

    /**
     * Generates a user with a specific email.
     *
     * @param email the desired email
     * @return a new UserData instance
     */
    public static UserData withEmail(String email) {
        return UserData.builder()
                .firstName(FAKER.name().firstName())
                .lastName(FAKER.name().lastName())
                .email(email)
                .phone(FAKER.phoneNumber().cellPhone())
                .role("member")
                .build();
    }

    /**
     * Creates a user via API for test setup. Faster than UI creation.
     *
     * @param email the user's email
     * @return the created user's ID
     */
    public static String createViaApi(String email) {
        UserData user = withEmail(email);
        String response = ApiUtils.post(
                TestConfig.get().apiBaseUrl() + "/users",
                user.toJson());
        log.info("Created test user via API: {}", email);
        return response;
    }

    /**
     * Immutable test data holder for user information.
     */
    @Getter
    @Builder
    public static class UserData {

        private final String firstName;
        private final String lastName;
        private final String email;
        private final String phone;
        private final String role;

        /**
         * Serializes to JSON string for API calls.
         */
        public String toJson() {
            return String.format("""
                    {
                        "firstName": "%s",
                        "lastName": "%s",
                        "email": "%s",
                        "phone": "%s",
                        "role": "%s"
                    }
                    """, firstName, lastName, email, phone, role);
        }

        /**
         * Returns the full name.
         */
        public String fullName() {
            return firstName + " " + lastName;
        }
    }
}
```

---

## Cucumber Runner

```java
package com.breezeware.automation.runners;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectPackages;
import org.junit.platform.suite.api.Suite;

import static io.cucumber.junit.platform.engine.Constants.FEATURES_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.FILTER_TAGS_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;

/**
 * Cucumber test runner configured for JUnit 5 Platform.
 */
@Suite
@IncludeEngines("cucumber")
@SelectPackages("com.breezeware.automation")
@ConfigurationParameter(key = FEATURES_PROPERTY_NAME,
        value = "src/test/resources/features")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME,
        value = "com.breezeware.automation.steps,"
                + "com.breezeware.automation.hooks")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME,
        value = "pretty,"
                + "html:target/cucumber-reports/cucumber.html,"
                + "json:target/cucumber-reports/cucumber.json,"
                + "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm")
public class CucumberRunner {
}
```

```java
package com.breezeware.automation.runners;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectPackages;
import org.junit.platform.suite.api.Suite;

import static io.cucumber.junit.platform.engine.Constants.FEATURES_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.FILTER_TAGS_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;

/**
 * Smoke test runner — runs only @smoke tagged scenarios.
 */
@Suite
@IncludeEngines("cucumber")
@SelectPackages("com.breezeware.automation")
@ConfigurationParameter(key = FEATURES_PROPERTY_NAME,
        value = "src/test/resources/features")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME,
        value = "com.breezeware.automation.steps,"
                + "com.breezeware.automation.hooks")
@ConfigurationParameter(key = FILTER_TAGS_PROPERTY_NAME,
        value = "@smoke")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME,
        value = "pretty,"
                + "html:target/cucumber-reports/smoke.html,"
                + "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm")
public class SmokeTestRunner {
}
```

---

## Maven Configuration

```xml
<!-- Key dependencies for pom.xml -->
<properties>
    <java.version>21</java.version>
    <playwright.version>1.49.0</playwright.version>
    <cucumber.version>7.20.1</cucumber.version>
    <junit.version>5.11.3</junit.version>
    <allure.version>2.29.0</allure.version>
    <assertj.version>3.26.3</assertj.version>
    <lombok.version>1.18.34</lombok.version>
</properties>

<!-- Run with: mvn clean test -Denv=dev -Dcucumber.filter.tags="@smoke" -->
<!-- Allure report: mvn allure:serve -->
```

---

## Allure Reporting

```properties
# src/test/resources/allure.properties
allure.results.directory=target/allure-results
allure.link.issue.pattern=https://jira.breezeware.com/browse/{}
allure.link.tms.pattern=https://jira.breezeware.com/browse/{}
```

### Allure Integration Rules
1. **`@Step` on page object methods** — every public method becomes an Allure step
2. **`@Description` on test methods** — describe what the test validates
3. **`@Severity`** — `BLOCKER`, `CRITICAL`, `NORMAL`, `MINOR`, `TRIVIAL`
4. **`@Epic` / `@Feature` / `@Story`** — map to Jira epics/stories
5. **Screenshots on failure** — automatically attached via hooks
6. **Page source on failure** — attached for debugging
7. **Video recording** — optional, enabled via config
8. **Console errors captured** — browser console errors logged and attached

---

## Wait Strategy — NO Thread.sleep()

```java
// ❌ FORBIDDEN — Thread.sleep
Thread.sleep(3000);

// ✅ CORRECT — Playwright auto-wait (built into every action)
page.getByTestId("submit-btn").click(); // Auto-waits for visible + enabled

// ✅ CORRECT — Explicit wait for specific condition
page.getByTestId("loading-skeleton").waitFor(
        new Locator.WaitForOptions()
                .setState(WaitForSelectorState.HIDDEN)
                .setTimeout(10000));

// ✅ CORRECT — Wait for network idle
page.waitForLoadState(LoadState.NETWORKIDLE);

// ✅ CORRECT — Wait for specific URL
page.waitForURL("**/users/*");

// ✅ CORRECT — Wait for API response
page.waitForResponse(
        response -> response.url().contains("/api/v1/users")
                && response.status() == 200,
        () -> page.getByTestId("submit-btn").click());

// ✅ CORRECT — Assertions with auto-retry (Playwright expect)
assertThat(page.getByTestId("user-count")).hasText("42");
```

---

## Naming Conventions

| Element               | Convention                   | Example                             |
|-----------------------|------------------------------|-------------------------------------|
| Page objects          | PascalCase + Page            | `UserListPage.java`                 |
| Component objects     | PascalCase + Component       | `DataTableComponent.java`           |
| Step definitions      | PascalCase + Steps           | `UserSteps.java`                    |
| Feature files         | snake_case.feature           | `create_user.feature`               |
| Test data factories   | PascalCase + Factory         | `UserFactory.java`                  |
| Config classes        | PascalCase + Config          | `TestConfig.java`                   |
| Utility classes       | PascalCase + Utils           | `WaitUtils.java`                    |
| Runners               | PascalCase + Runner          | `CucumberRunner.java`               |
| Hooks                 | PascalCase + Hooks           | `CucumberHooks.java`                |
| Constants             | PascalCase (class), UPPER_SNAKE (values) | `TestGroups.SMOKE`     |
| Methods               | camelCase                    | `fillFirstName`, `clickSubmit`      |
| Feature tags          | @kebab-case                  | `@smoke`, `@regression`, `@users`   |
| Packages              | lowercase                    | `com.breezeware.automation.pages`   |

---

## Code Standards Summary

1. **No `Thread.sleep()`** — EVER. Use Playwright's auto-wait or explicit waits
2. **No XPath** — use `data-testid`, role-based, or text-based locators
3. **No hardcoded test data** — use factories with Faker
4. **No assertions in page objects** — only in steps or tests
5. **API for test data setup** — `@Given` steps use API, not UI
6. **Screenshot on failure** — automatic via hooks
7. **`@Step` on every public page method** — for Allure traceability
8. **Constructor injection** — in step definitions (Cucumber PicoContainer)
9. **Thread-safe browser management** — `ThreadLocal` for parallel execution
10. **Environment-specific config** — via Owner library + system properties
11. **Consistent tagging** — `@smoke`, `@regression`, `@positive`, `@negative`
12. **Javadoc on all public methods** — Checkstyle enforced

For locator strategy reference and frontend alignment, read `references/locator-guide.md`.
