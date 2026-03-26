# Breezeware Claude Plugins

True Claude Code plugins for Breezeware development — auto-detecting, hook-powered, with skills and code review.

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
