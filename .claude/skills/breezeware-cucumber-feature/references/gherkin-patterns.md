# Gherkin Patterns & Step Definition Mapping Guide

## Step Definition Mapping

Every Gherkin step maps to a Java step definition. Write feature files with
awareness of how steps will be implemented.

### Given Steps — Preconditions

```gherkin
# Authentication (maps to API login, not UI)
Given I am logged in as an admin
Given I am logged in as a "<role>"
Given I am not logged in

# Navigation
And I am on the Login page
And I am on the User Management page
And I am on the Dashboard

# Test data setup (maps to API calls, not UI)
Given a user "John Doe" exists
Given a user with email "john@breezeware.com" already exists
Given the following users exist:
  | name       | email               | role   |
  | John Doe   | john@breezeware.com | Admin  |
  | Jane Smith | jane@breezeware.com | Member |
Given 25 users exist in the system
Given no users exist in the system
```

**Step Definition Pattern:**
```java
@Given("I am logged in as an admin")
public void iAmLoggedInAsAdmin() {
    // Use API to login — faster than UI
    loginPage.loginViaApi("admin@breezeware.com", "password");
}

@Given("a user {string} exists")
public void aUserExists(String userName) {
    // Create via API — never via UI in Given steps
    apiClient.createUser(UserFactory.withName(userName));
}

@Given("the following users exist:")
public void theFollowingUsersExist(DataTable dataTable) {
    List<Map<String, String>> users = dataTable.asMaps();
    users.forEach(user -> apiClient.createUser(
        UserFactory.fromMap(user)
    ));
}
```

### When Steps — Actions

```gherkin
# Form operations
When I open the Create User form
When I fill in the user details:
  | field     | value               |
  | firstName | John                |
  | lastName  | Doe                 |
  | email     | john@breezeware.com |
When I fill in the email field with "john@breezeware.com"
When I submit the Create User form
When I submit the form without filling required fields

# Navigation actions
When I click the "Create User" button
When I navigate to the next page
When I navigate to page 3
When I go back to the previous page

# Search & filter
When I search for "John"
When I clear the search
When I filter by status "Active"
When I remove all filters
When I sort by "name" in "ascending" order

# Selection
When I select the user "John Doe"
When I select all users on the current page
When I deselect all users

# Bulk operations
When I delete the selected users
When I export the selected users

# Destructive actions
When I click delete for "John Doe"
When I confirm the deletion
When I cancel the deletion
```

**Step Definition Pattern:**
```java
@When("I fill in the user details:")
public void iFillInTheUserDetails(DataTable dataTable) {
    Map<String, String> data = dataTable.asMaps().get(0);
    createUserPage.fillForm(data);
}

@When("I search for {string}")
public void iSearchFor(String query) {
    listPage.search(query);
}

@When("I sort by {string} in {string} order")
public void iSortByInOrder(String column, String direction) {
    listPage.sortBy(column, direction);
}
```

### Then Steps — Assertions

```gherkin
# Success messages
Then I should see a success message "User created successfully"
Then I should see a success notification

# Error messages
Then I should see an error message "A user with this email already exists"
Then I should see an error notification

# Validation errors
Then I should see a validation error "Please enter a valid email" for the email field
Then I should see validation errors:
  | field     | error                  |
  | firstName | First name is required |
  | email     | Email is required      |
Then I should see validation errors for required fields

# List/table assertions
Then I should see 10 items in the list
Then the user "John Doe" should appear in the user list
Then "John Doe" should no longer appear in the list
Then the first result should be "Alice Smith"
Then the list should be sorted by name in ascending order

# State assertions
Then I should see an empty state with message "No users found"
Then I should be redirected to the Dashboard
Then I should remain on the Login page

# Field value assertions
Then the "firstName" field should have the value "John"
Then the role dropdown should show "Admin"

# Visibility assertions
Then the delete button should not be visible
Then the pagination controls should be visible
Then I should not see any delete options

# Count assertions
Then the user count should be 11
Then I should see 3 results in the list

# Pagination assertions
Then the pagination should show "Page 1 of 3"
Then the next page button should be disabled
```

**Step Definition Pattern:**
```java
@Then("I should see a success message {string}")
public void iShouldSeeSuccessMessage(String message) {
    String actual = toastComponent.getSuccessMessage();
    assertThat(actual)
        .as("Success toast message")
        .isEqualTo(message);
}

@Then("I should see {int} items in the list")
public void iShouldSeeItemsInList(int count) {
    assertThat(listPage.getItemCount())
        .as("List item count")
        .isEqualTo(count);
}

@Then("I should see validation errors:")
public void iShouldSeeValidationErrors(DataTable dataTable) {
    List<Map<String, String>> errors = dataTable.asMaps();
    errors.forEach(error -> {
        String actual = formPage.getFieldError(error.get("field"));
        assertThat(actual)
            .as("Validation error for " + error.get("field"))
            .isEqualTo(error.get("error"));
    });
}
```

---

## Advanced Gherkin Patterns

### Multi-Step Form Wizard

```gherkin
@users @regression
Feature: Multi-Step User Registration
  As a new user
  I want to complete the registration wizard
  So that I can create my account

  @smoke @positive
  Scenario: Complete all registration steps
    Given I am on the Registration page
    When I complete the personal details step:
      | field     | value               |
      | firstName | John                |
      | lastName  | Doe                 |
      | email     | john@breezeware.com |
    And I proceed to the next step
    And I complete the organization details step:
      | field        | value        |
      | company      | Breezeware   |
      | department   | Engineering  |
      | jobTitle     | Developer    |
    And I proceed to the next step
    And I review and confirm my details
    Then I should see a success message "Registration completed"
    And I should be redirected to the Dashboard

  @negative @validation
  Scenario: Cannot proceed without completing required step
    Given I am on the Registration page
    When I try to proceed to the next step without filling required fields
    Then I should see validation errors for the personal details step
    And I should remain on step 1
```

### File Upload

```gherkin
@documents @regression
Feature: Document Upload
  As a user
  I want to upload documents
  So that I can attach files to my profile

  @positive
  Scenario: Upload a valid document
    Given I am logged in as a member
    And I am on the Documents page
    When I upload the file "sample-report.pdf"
    Then I should see a success message "File uploaded successfully"
    And the file "sample-report.pdf" should appear in my documents

  @negative @validation
  Scenario: Reject file exceeding size limit
    Given I am logged in as a member
    And I am on the Documents page
    When I upload a file larger than 10MB
    Then I should see an error message "File size exceeds 10MB limit"

  @negative @validation
  Scenario Outline: Reject unsupported file types
    Given I am logged in as a member
    And I am on the Documents page
    When I upload a file with extension "<extension>"
    Then I should see an error message "File type not supported"

    Examples:
      | extension |
      | .exe      |
      | .bat      |
      | .sh       |
```

### Notification & Real-Time Updates

```gherkin
@notifications @regression
Feature: Real-Time Notifications
  As a user
  I want to receive notifications
  So that I am informed of important events

  @positive
  Scenario: Receive notification when assigned a task
    Given I am logged in as a member
    And another admin assigns a task to me
    Then I should see a notification badge on the bell icon
    When I open the notifications panel
    Then I should see the notification "You have been assigned a new task"

  @positive
  Scenario: Mark notification as read
    Given I am logged in as a member
    And I have 3 unread notifications
    When I open the notifications panel
    And I mark the first notification as read
    Then the notification badge should show 2
```

### Role-Based Access Control

```gherkin
@auth @permission @regression
Feature: Role-Based Access Control
  As a system administrator
  I want to restrict features by role
  So that users only access authorized functionality

  @positive @permission
  Scenario Outline: Role-based page access
    Given I am logged in as a "<role>"
    When I navigate to the "<page>" page
    Then I should <access> the page

    Examples: Admin access
      | role  | page            | access   |
      | Admin | User Management | see      |
      | Admin | Settings        | see      |
      | Admin | Reports         | see      |

    Examples: Member access
      | role   | page            | access       |
      | Member | User Management | not see      |
      | Member | Dashboard       | see          |
      | Member | Reports         | see          |

    Examples: Viewer access
      | role   | page            | access       |
      | Viewer | User Management | not see      |
      | Viewer | Settings        | not see      |
      | Viewer | Dashboard       | see          |

  @negative @permission
  Scenario: Unauthorized user sees access denied page
    Given I am logged in as a viewer
    When I try to access the User Management page directly via URL
    Then I should see an access denied message
    And I should not see any user data
```

### Modal Confirmation Flows

```gherkin
@users @regression
Feature: User Deactivation with Confirmation
  As an administrator
  I want to deactivate user accounts with confirmation
  So that accidental deactivations are prevented

  @positive
  Scenario: Deactivate user after confirmation
    Given I am logged in as an admin
    And a user "John Doe" with status "Active" exists
    And I am on the User Management page
    When I click deactivate for user "John Doe"
    Then I should see a confirmation dialog with message:
      """
      Are you sure you want to deactivate John Doe?
      This will revoke their access immediately.
      """
    When I confirm the deactivation
    Then I should see a success message "User deactivated successfully"
    And user "John Doe" should have status "Inactive"

  @positive
  Scenario: Cancel deactivation keeps user active
    Given I am logged in as an admin
    And a user "John Doe" with status "Active" exists
    And I am on the User Management page
    When I click deactivate for user "John Doe"
    And I cancel the deactivation
    Then user "John Doe" should still have status "Active"
```

### Doc Strings for Long Text

```gherkin
@support @regression
Feature: Support Ticket Submission
  As a user
  I want to submit support tickets
  So that I can get help with issues

  @positive
  Scenario: Submit a detailed support ticket
    Given I am logged in as a member
    And I am on the Support page
    When I create a new support ticket with subject "Login Issue"
    And I enter the ticket description:
      """
      I am unable to log in to my account since the last update.
      I have tried resetting my password but the reset email
      never arrives. My account email is john@breezeware.com.
      This has been happening since March 20, 2026.
      """
    And I set the priority to "High"
    And I submit the ticket
    Then I should see a success message "Ticket submitted successfully"
    And I should see the ticket reference number
```

### Date & Time Handling

```gherkin
@reports @regression
Feature: Date Range Reports
  As a manager
  I want to generate reports for specific date ranges
  So that I can analyze data over time

  @positive
  Scenario: Generate report for current month
    Given I am logged in as a manager
    And I am on the Reports page
    When I select the date range "This Month"
    And I generate the report
    Then I should see report data for the current month
    And the report header should show the current month and year

  @positive
  Scenario: Generate report for custom date range
    Given I am logged in as a manager
    And I am on the Reports page
    When I set the start date to "2026-01-01"
    And I set the end date to "2026-03-31"
    And I generate the report
    Then I should see report data for the selected period

  @negative @validation
  Scenario: Cannot generate report with end date before start date
    Given I am logged in as a manager
    And I am on the Reports page
    When I set the start date to "2026-03-31"
    And I set the end date to "2026-01-01"
    Then I should see a validation error "End date must be after start date"
    And the generate button should be disabled
```

---

## Step Reusability Matrix

| Step Pattern | Reuse Level | Example |
|-------------|-------------|---------|
| `Given I am logged in as {role}` | Global | Every feature |
| `And I am on the {page} page` | Global | Every feature |
| `Then I should see a success message {msg}` | Global | Every feature |
| `Then I should see an error message {msg}` | Global | Every feature |
| `When I search for {query}` | Domain | List features |
| `Then I should see {count} items in the list` | Domain | List features |
| `When I fill in the {form} form:` | Feature | Specific CRUD |
| `Then the {field} should have value {value}` | Feature | Specific forms |

### Shared Step Definition Classes

```
src/test/java/com/breezeware/automation/steps/
├── CommonSteps.java          # Login, navigation, toasts
├── AuthSteps.java            # Auth-specific steps
├── UserSteps.java            # User CRUD steps
├── SearchFilterSteps.java    # Search, filter, sort
├── PaginationSteps.java      # Pagination steps
├── ValidationSteps.java      # Form validation steps
└── DataSetupSteps.java       # API-based test data setup
```

---

## Parameterized Step Expressions

### Cucumber Expression Types

```java
// {string} — quoted text
@When("I search for {string}")
// Matches: When I search for "John"

// {int} — integer
@Then("I should see {int} items")
// Matches: Then I should see 10 items

// {word} — single word without quotes
@Given("I am logged in as {word}")
// Matches: Given I am logged in as admin

// {float} — decimal number
@Then("the total should be {float}")
// Matches: Then the total should be 99.99

// Custom type — enum
@Given("I am on the {pageType} page")
// Define: @ParameterType("Dashboard|Settings|Users")

// Alternative text
@When("I click/press the {string} button")
// Matches: When I click the "Save" button
// Matches: When I press the "Save" button

// Optional text
@Then("I should( not) see the delete button")
// Matches: Then I should see the delete button
// Matches: Then I should not see the delete button
```

---

## Feature File Quality Checklist

### Readability
- [ ] Can a product owner read and understand every scenario?
- [ ] No technical jargon (CSS, XPath, API, HTTP, DOM)?
- [ ] Steps describe business actions, not UI clicks?
- [ ] Scenario names clearly describe the behavior being tested?

### Structure
- [ ] One feature per file?
- [ ] User story format (As a / I want / So that)?
- [ ] Background has only shared preconditions (max 3 steps)?
- [ ] Each scenario tests exactly one behavior?

### Completeness
- [ ] Happy path covered (`@positive`)?
- [ ] Required field validation (`@negative @validation`)?
- [ ] Format validation (`@negative @validation`)?
- [ ] Duplicate/uniqueness (`@negative @duplicate`)?
- [ ] Permission checks (`@negative @permission`)?
- [ ] Boundary/edge cases (`@edge-case`)?

### Data
- [ ] DataTable used for structured input?
- [ ] Scenario Outline used for data-driven variations?
- [ ] Test data setup via Given steps (API), not UI?
- [ ] No hardcoded IDs or timestamps?

### Independence
- [ ] Each scenario can run alone?
- [ ] No scenario depends on another scenario's state?
- [ ] Background doesn't create scenario-specific data?
