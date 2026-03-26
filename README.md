<h1 align="center"> <a href="https://github.com/Breezeware-OS/"><img src="https://github.com/user-attachments/assets/07f2efc7-111f-4dee-b775-98fa8743e2c6" alt="Dynamo" width="400" align="center"></a>
</h1>

<h4 align="center">A powerful platform designed to supercharge business app development and streamline internal tool creation. Manage, organize, and innovate—all in one place</h4>

</div>

# Breezeware Claude Plugins

True Claude Code plugins for Breezeware development — auto-detecting, hook-powered, with skills and code review.

## Example Use Cases

### Spring Boot Backend
```
> /breezeware-spring-boot-backend Create a REST API for user management with CRUD operations
> /breezeware-code-review-backend Review my UserService.java for bugs and security issues
```
Claude generates a complete Spring Boot module — entity, DTO, repository, service, controller, Flyway migration — following Breezeware's Checkstyle rules, constructor injection, and REST conventions.

### React Frontend
```
> /breezeware-reactjs-frontend Build a dashboard page with a data table, search bar, and pagination
> /breezeware-code-review-frontend Review my Dashboard.jsx for performance and accessibility
```
Claude scaffolds responsive React components using shadcn/ui, Redux Toolkit, Axios services, and Tailwind CSS — matching Breezeware's component patterns.

### React Native Mobile
```
> /breezeware-react-native Create a login screen with form validation and biometric auth
> /breezeware-code-review-mobile Review my HomeScreen for performance and platform issues
```
Claude builds bare React Native screens with React Navigation, Redux state management, and platform-specific handling.

### Playwright Test Automation
```
> /breezeware-playwright-automation Create E2E tests for the login flow with Page Object Model
> /breezeware-code-review-automation Review my LoginPage.java page object for reliability
```
Claude generates Java Playwright tests with JUnit 5, Cucumber BDD integration, Allure reporting, and stable locator strategies.

### Cucumber BDD
```
> /breezeware-cucumber-feature Write feature files for the checkout flow
> /breezeware-code-review-cucumber Review my checkout.feature for BDD best practices
```
Claude writes declarative Gherkin scenarios with proper tagging strategy, data tables, scenario outlines, and business-readable language.

### Common (All Projects)
```
> /breezeware-code-review Review this pull request for bugs, security, and style
> /breezeware-git-workflow Generate a PR description for my current branch
> /breezeware-security-scan Scan this module for OWASP Top 10 vulnerabilities
```
General code review, PR/changelog generation, and security auditing — works across any stack.

## Plugins

| Plugin | Auto-Detects | What It Does |
|--------|-------------|--------------|
| **breezeware-common** | Always active | Code review, git workflow, security scan + safety hooks |
| **breezeware-spring-boot** | `pom.xml`, `src/main/java/` | Spring Boot dev + Java format hooks |
| **breezeware-react** | `package.json` has `react` | React.js frontend dev + JSX lint hooks |
| **breezeware-react-native** | `package.json` has `react-native` | React Native mobile dev + RN lint hooks |
| **breezeware-playwright** | `pom.xml` has "playwright" | Playwright automation + test lint hooks |
| **breezeware-cucumber** | `*.feature` files | Cucumber BDD writing + feature file lint hooks |

## Quick Start

### Option 1: Load directly (testing)

```bash
claude --plugin-dir ./plugins/common --plugin-dir ./plugins/spring-boot
```

### Option 2: Install from marketplace (recommended)

```bash
# Add marketplace (one-time)
/plugin marketplace add Breezeware-OS/breezeware-claude-plugins

# Install plugins you need
/plugin install breezeware-common@breezeware-claude-plugins
/plugin install breezeware-spring-boot@breezeware-claude-plugins
/plugin install breezeware-cucumber@breezeware-claude-plugins
/reload-plugins
```

### Option 3: Auto-install for your team

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "breezeware-claude-plugins": {
      "source": {
        "source": "github",
        "repo": "Breezeware-OS/breezeware-claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "breezeware-common@breezeware-claude-plugins": true,
    "breezeware-spring-boot@breezeware-claude-plugins": true
  }
}
```

## What Makes These Plugins (Not Just Skills)

| Feature | Skills (old) | Plugins (this) |
|---------|-------------|----------------|
| Auto-detect project type | No | Yes — SessionStart hooks |
| Lint on every file edit | No | Yes — PostToolUse hooks |
| Block dangerous commands | No | Yes — PreToolUse hooks |
| Install/uninstall | Copy files | `/plugin install` |
| Team sharing | Copy `.claude/` folder | Marketplace + settings.json |
| Hot-reload | No | `/reload-plugins` |

## Plugin Management

```bash
/plugin                                              # Open plugin manager
/plugin install breezeware-react@breezeware-claude-plugins   # Install
/plugin disable breezeware-react                     # Disable
/plugin enable breezeware-react                      # Re-enable
/plugin uninstall breezeware-react                   # Remove
/reload-plugins                                      # Hot-reload
/plugin marketplace update breezeware-claude-plugins # Get updates
```

## Legacy: Skill-Only Setup

The original skills (without hooks) are still available in `.claude/skills/` and can be used with the `setup.sh` script for projects that don't support plugins yet.

```bash
./setup.sh /path/to/target-project
./setup.sh --list-packs
```

## Directory Structure

```
breezeware-claude-plugins/
├── plugins/                          # True Claude Code plugins
│   ├── .claude-plugin/
│   │   └── marketplace.json          # Plugin marketplace catalog
│   ├── common/                       # Always-active plugin
│   ├── spring-boot/                  # Java/Spring Boot plugin
│   ├── react/                        # React.js frontend plugin
│   ├── react-native/                 # React Native mobile plugin
│   ├── playwright/                   # Playwright automation plugin
│   └── cucumber/                     # Cucumber BDD plugin
├── .claude/skills/                   # Legacy standalone skills
├── setup.sh                          # Legacy skill installer
├── plugin-registry.json              # Legacy detection registry
└── CLAUDE.md                         # Project conventions
```
