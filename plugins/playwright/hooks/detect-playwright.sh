#!/usr/bin/env bash
# Detect Playwright automation project and inject context

DETECTED=false

# Check pom.xml for Playwright dependency
if [ -f "pom.xml" ] && grep -qi "playwright" pom.xml 2>/dev/null; then
    DETECTED=true
fi

# Check package.json for @playwright/test
if [ -f "package.json" ]; then
    HAS_PW=$(jq -e '(.dependencies["@playwright/test"] // .devDependencies["@playwright/test"]) != null' package.json 2>/dev/null)
    if [ "$HAS_PW" = "true" ]; then
        DETECTED=true
    fi
fi

if [ "$DETECTED" = true ]; then
    echo "[Playwright automation project detected]"
    echo ""
    echo "Breezeware Playwright conventions active:"
    echo "- Page Object Model with BasePage"
    echo "- Locator priority: getByTestId > getByRole > getByLabel > getByText"
    echo "- data-testid in kebab-case: {component}-{element}"
    echo "- NO Thread.sleep() — use Playwright auto-wait"
    echo "- NO XPath or CSS class selectors"
    echo "- @Step annotation on every public page object method"
    echo "- @Slf4j logging on every page object"
    echo "- Allure reporting with @Epic/@Feature/@Story"
    echo ""
    echo "Available: /breezeware-playwright:playwright-automation, /breezeware-playwright:code-review-automation"
fi
