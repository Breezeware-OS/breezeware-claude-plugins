#!/usr/bin/env bash
# Post-edit hook: validate React/JSX file conventions

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only check .jsx and .js files
case "$FILE_PATH" in
    *.jsx|*.js) ;;
    *) exit 0 ;;
esac

[ ! -f "$FILE_PATH" ] && exit 0

ISSUES=""

# Check for default exports (should use named exports)
if grep -n 'export default' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Uses default export — prefer named exports"
fi

# Check for 'any' type usage
if grep -n ': any' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- 'any' type found — use specific types or 'unknown'"
fi

# Check for inline styles (should use Tailwind)
if grep -n 'style={{' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Inline styles found — use Tailwind CSS classes instead"
fi

# Check for console.log left in
if grep -n 'console\.log' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- console.log found — remove before commit"
fi

# Check for missing PropTypes (components only)
if grep -q 'function.*(' "$FILE_PATH" || grep -q 'const.*=.*(' "$FILE_PATH"; then
    if grep -q 'return.*<' "$FILE_PATH" && ! grep -q 'propTypes\|PropTypes' "$FILE_PATH"; then
        BASENAME=$(basename "$FILE_PATH")
        # Skip non-component files
        FIRST_CHAR="${BASENAME:0:1}"
        if [[ "$FIRST_CHAR" =~ [A-Z] ]]; then
            ISSUES="${ISSUES}\n- Component missing PropTypes definition"
        fi
    fi
fi

if [ -n "$ISSUES" ]; then
    echo "React lint issues in $(basename "$FILE_PATH"):"
    echo -e "$ISSUES"
fi

exit 0
