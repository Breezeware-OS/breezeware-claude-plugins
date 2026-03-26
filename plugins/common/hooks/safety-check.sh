#!/usr/bin/env bash
# Safety check hook — blocks dangerous bash commands
# Exit 0 = allow, Exit 2 = block

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Block dangerous patterns
case "$COMMAND" in
  *"rm -rf /"*|*"rm -rf /*"*)
    echo "Blocked: destructive rm -rf on root" >&2
    exit 2
    ;;
  *"DROP DATABASE"*|*"drop database"*)
    echo "Blocked: DROP DATABASE command" >&2
    exit 2
    ;;
  *"--no-verify"*)
    echo "Blocked: --no-verify bypasses safety hooks" >&2
    exit 2
    ;;
  *"force push"*|*"push --force"*|*"push -f"*)
    echo "Blocked: force push — use --force-with-lease instead" >&2
    exit 2
    ;;
esac

exit 0
