#!/usr/bin/env bash
# Post-edit hook: validate Playwright test code conventions

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only check .java files in test directories
case "$FILE_PATH" in
    *.java) ;;
    *) exit 0 ;;
esac

# Only check test files (pages, steps, hooks, config)
case "$FILE_PATH" in
    */test/*|*/pages/*|*/steps/*|*/hooks/*|*/automation/*) ;;
    *) exit 0 ;;
esac

[ ! -f "$FILE_PATH" ] && exit 0

ISSUES=""

# CRITICAL: Check for Thread.sleep()
if grep -n 'Thread\.sleep' "$FILE_PATH" > /dev/null 2>&1; then
    LINE=$(grep -n 'Thread\.sleep' "$FILE_PATH" | head -1 | cut -d: -f1)
    ISSUES="${ISSUES}\n- CRITICAL Line ${LINE}: Thread.sleep() — FORBIDDEN. Use Playwright auto-wait or waitFor()"
fi

# CRITICAL: Check for XPath selectors
if grep -n 'xpath\|XPath\|"//\|'"'"'//\|By\.xpath' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- CRITICAL: XPath selector found — use getByTestId(), getByRole(), or getByLabel()"
fi

# Check for CSS class selectors
if grep -n '\.MuiButton\|\.css-\|\.MuiTable\|\.MuiInput' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- CSS class selector found — use data-testid instead of MUI/CSS classes"
fi

# Check for hardcoded waits
if grep -n 'waitForTimeout' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- waitForTimeout() found — use waitFor() with specific state instead"
fi

# Check page objects have @Step annotation on public methods
if echo "$FILE_PATH" | grep -q 'pages/'; then
    # Count public methods without @Step
    PUBLIC_METHODS=$(grep -c 'public.*(' "$FILE_PATH" 2>/dev/null || echo 0)
    STEP_ANNOTATIONS=$(grep -c '@Step' "$FILE_PATH" 2>/dev/null || echo 0)
    if [ "$PUBLIC_METHODS" -gt 0 ] && [ "$STEP_ANNOTATIONS" -lt "$PUBLIC_METHODS" ]; then
        ISSUES="${ISSUES}\n- Page object has ${PUBLIC_METHODS} public methods but only ${STEP_ANNOTATIONS} @Step annotations"
    fi
fi

# Check for assertions in page objects (should be in steps only)
if echo "$FILE_PATH" | grep -q 'pages/'; then
    if grep -n 'assertThat\|assertEquals\|assertTrue\|assertFalse' "$FILE_PATH" > /dev/null 2>&1; then
        ISSUES="${ISSUES}\n- Assertions found in page object — move to step definitions"
    fi
fi

# Check for @Slf4j
if echo "$FILE_PATH" | grep -q 'pages/'; then
    if ! grep -q '@Slf4j' "$FILE_PATH"; then
        ISSUES="${ISSUES}\n- Missing @Slf4j annotation — page objects must log actions"
    fi
fi

# Check for star imports
if grep -n 'import .*\.\*;' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Star imports found — use specific imports"
fi

if [ -n "$ISSUES" ]; then
    echo "Playwright test issues in $(basename "$FILE_PATH"):"
    echo -e "$ISSUES"
fi

exit 0
