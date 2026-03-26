#!/usr/bin/env bash
# Detect Cucumber/BDD project and inject context

DETECTED=false

# Check for .feature files
FEATURE_COUNT=$(find . -maxdepth 4 -name "*.feature" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -path "*/target/*" \
    -not -path "*/build/*" \
    2>/dev/null | wc -l | tr -d ' ')

if [ "$FEATURE_COUNT" -gt 0 ]; then
    DETECTED=true
fi

# Check pom.xml for Cucumber
if [ -f "pom.xml" ] && grep -qi "cucumber" pom.xml 2>/dev/null; then
    DETECTED=true
fi

# Check package.json for @cucumber/cucumber
if [ -f "package.json" ]; then
    HAS_CUC=$(jq -e '(.dependencies["@cucumber/cucumber"] // .devDependencies["@cucumber/cucumber"]) != null' package.json 2>/dev/null)
    if [ "$HAS_CUC" = "true" ]; then
        DETECTED=true
    fi
fi

if [ "$DETECTED" = true ]; then
    echo "[Cucumber BDD project detected — ${FEATURE_COUNT} feature files found]"
    echo ""
    echo "Breezeware Cucumber conventions active:"
    echo "- One feature per file, snake_case naming"
    echo "- Feature-level tags: @domain + @regression"
    echo "- Scenario tags: @positive, @negative, @edge-case, @validation"
    echo "- Priority tags: @smoke (15-25 max), @critical, @regression"
    echo "- Declarative steps — WHAT not HOW (no CSS/XPath in Gherkin)"
    echo "- Background: max 3 steps, Given only"
    echo "- Each scenario tests ONE behavior, independently"
    echo "- DataTable for structured input, Scenario Outline for data-driven"
    echo ""
    echo "Available: /breezeware-cucumber:cucumber-feature, /breezeware-cucumber:code-review-cucumber"
fi
