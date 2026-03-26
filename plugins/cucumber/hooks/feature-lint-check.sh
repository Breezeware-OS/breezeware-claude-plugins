#!/usr/bin/env bash
# Post-edit hook: validate Cucumber feature file conventions

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only check .feature files
case "$FILE_PATH" in
    *.feature) ;;
    *) exit 0 ;;
esac

[ ! -f "$FILE_PATH" ] && exit 0

ISSUES=""

# Check for Feature-level tags (@domain + @regression)
FIRST_TAG_LINE=$(grep -n '^@' "$FILE_PATH" | head -1)
if [ -z "$FIRST_TAG_LINE" ]; then
    ISSUES="${ISSUES}\n- CRITICAL: No feature-level tags — add @domain + @regression"
elif ! echo "$FIRST_TAG_LINE" | grep -qi 'regression'; then
    ISSUES="${ISSUES}\n- Missing @regression tag on Feature"
fi

# Check for user story format
if ! grep -q 'As a\|As an' "$FILE_PATH" 2>/dev/null; then
    ISSUES="${ISSUES}\n- Missing user story (As a / I want to / So that)"
fi

# CRITICAL: Check for CSS selectors in steps
if grep -n 'CSS selector\|css-\|\.Mui\|#[a-zA-Z]\|xpath\|XPath\|"//' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- CRITICAL: Implementation details in Gherkin — steps must be declarative (WHAT not HOW)"
fi

# Check for wait/sleep steps
if grep -ni 'wait for.*second\|sleep\|wait.*load' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- CRITICAL: Wait/sleep steps in Gherkin — remove timing from feature files"
fi

# Check for scenarios without type tags
SCENARIOS_WITHOUT_TAGS=0
PREV_LINE=""
while IFS= read -r line; do
    if echo "$line" | grep -q '^\s*Scenario:'; then
        if ! echo "$PREV_LINE" | grep -qE '@positive|@negative|@edge-case|@validation|@smoke'; then
            SCENARIOS_WITHOUT_TAGS=$((SCENARIOS_WITHOUT_TAGS + 1))
        fi
    fi
    PREV_LINE="$line"
done < "$FILE_PATH"

if [ "$SCENARIOS_WITHOUT_TAGS" -gt 0 ]; then
    ISSUES="${ISSUES}\n- ${SCENARIOS_WITHOUT_TAGS} scenario(s) missing type tags (@positive, @negative, etc.)"
fi

# Check for file naming (should be snake_case)
BASENAME=$(basename "$FILE_PATH")
if echo "$BASENAME" | grep -qE '[A-Z]|-'; then
    ISSUES="${ISSUES}\n- File name '${BASENAME}' should be snake_case (e.g., create_user.feature)"
fi

# Check Background length
BG_STEPS=$(sed -n '/Background:/,/Scenario/{ /Given\|And\|When\|Then/p }' "$FILE_PATH" 2>/dev/null | wc -l | tr -d ' ')
if [ "$BG_STEPS" -gt 3 ]; then
    ISSUES="${ISSUES}\n- Background has ${BG_STEPS} steps — max 3 allowed"
fi

# Check scenario count
SCENARIO_COUNT=$(grep -c '^\s*Scenario:' "$FILE_PATH" 2>/dev/null || echo 0)
OUTLINE_COUNT=$(grep -c '^\s*Scenario Outline:' "$FILE_PATH" 2>/dev/null || echo 0)
TOTAL=$((SCENARIO_COUNT + OUTLINE_COUNT))
if [ "$TOTAL" -gt 10 ]; then
    ISSUES="${ISSUES}\n- ${TOTAL} scenarios in one file — max 10, split into separate feature files"
fi

if [ -n "$ISSUES" ]; then
    echo "Feature file issues in $(basename "$FILE_PATH"):"
    echo -e "$ISSUES"
fi

exit 0
