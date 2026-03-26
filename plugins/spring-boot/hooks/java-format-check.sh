#!/usr/bin/env bash
# Post-edit hook: validate Java file formatting rules

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only check .java files
case "$FILE_PATH" in
    *.java) ;;
    *) exit 0 ;;
esac

[ ! -f "$FILE_PATH" ] && exit 0

ISSUES=""

# Check for tabs (must use 4 spaces)
if grep -P '\t' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- TABS detected: use 4 spaces for indentation"
fi

# Check for lines > 120 chars
LONG_LINES=$(awk 'length > 120 { count++ } END { print count+0 }' "$FILE_PATH")
if [ "$LONG_LINES" -gt 0 ]; then
    ISSUES="${ISSUES}\n- ${LONG_LINES} lines exceed 120 characters"
fi

# Check for @Autowired on fields (must use constructor injection)
if grep -n '@Autowired' "$FILE_PATH" | grep -v 'constructor' > /dev/null 2>&1; then
    LINE=$(grep -n '@Autowired' "$FILE_PATH" | head -1 | cut -d: -f1)
    ISSUES="${ISSUES}\n- Line ${LINE}: @Autowired on field — use constructor injection (@RequiredArgsConstructor)"
fi

# Check for star imports
if grep -n 'import .*\.\*;' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Star imports found — use specific imports"
fi

# Check for Thread.sleep
if grep -n 'Thread\.sleep' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Thread.sleep() found — use proper wait mechanisms"
fi

if [ -n "$ISSUES" ]; then
    echo "Java format issues in $(basename "$FILE_PATH"):"
    echo -e "$ISSUES"
fi

exit 0
