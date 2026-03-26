# Breezeware Plugins

True Claude Code plugins with auto-detection, hooks, and skills.

## Available Plugins

| Plugin | Auto-Detects | Skills | Hooks |
|--------|-------------|--------|-------|
| **breezeware-common** | Always active | code-review, git-workflow, security-scan | Safety check (blocks rm -rf, DROP DATABASE, --no-verify) |
| **breezeware-spring-boot** | `pom.xml`, `src/main/java/` | spring-boot-backend, code-review-backend | Java format check (tabs, line length, @Autowired, star imports) |
| **breezeware-react** | `package.json` has `react` | reactjs-frontend, code-review-frontend | React lint (default exports, inline styles, console.log, PropTypes) |
| **breezeware-react-native** | `package.json` has `react-native` | react-native, code-review-mobile | RN lint (Expo imports, className, Dimensions.get, AsyncStorage) |
| **breezeware-playwright** | `pom.xml` has "playwright" | playwright-automation, code-review-automation | Test lint (Thread.sleep, XPath, CSS classes, missing @Step/@Slf4j) |
| **breezeware-cucumber** | `*.feature` files exist | cucumber-feature, code-review-cucumber | Feature lint (tags, declarative steps, Background length, naming) |

## Quick Start

### Option 1: Load directly (testing)

```bash
# Load one plugin
claude --plugin-dir ./plugins/spring-boot

# Load multiple
claude --plugin-dir ./plugins/common --plugin-dir ./plugins/spring-boot --plugin-dir ./plugins/cucumber
```

### Option 2: Add marketplace (team sharing)

```bash
# Inside Claude Code:
/plugin marketplace add your-org/breezeware-claude-plugins

# Then install what you need:
/plugin install breezeware-common@breezeware-claude-plugins
/plugin install breezeware-spring-boot@breezeware-claude-plugins
```

### Option 3: Project-scoped (auto-install for team)

Add to your project's `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "breezeware-common@breezeware-claude-plugins": true,
    "breezeware-spring-boot@breezeware-claude-plugins": true
  }
}
```

## What Happens When You Start Claude Code

1. **SessionStart** hook fires — detects your project type
2. **Skills auto-load** — matched by description, no `/slash` needed
3. **Every file edit** — PostToolUse hook runs lint checks automatically
4. **Dangerous commands** — PreToolUse hook blocks them before execution

## Plugin Management

```bash
/plugin                              # Open plugin manager
/plugin disable breezeware-react     # Disable a plugin
/plugin enable breezeware-react      # Re-enable
/reload-plugins                      # Hot-reload after changes
```
