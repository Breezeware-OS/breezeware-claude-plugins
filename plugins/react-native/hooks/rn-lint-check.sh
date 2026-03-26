#!/usr/bin/env bash
# Post-edit hook: validate React Native file conventions

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only check .js and .jsx files
case "$FILE_PATH" in
    *.jsx|*.js) ;;
    *) exit 0 ;;
esac

[ ! -f "$FILE_PATH" ] && exit 0

ISSUES=""

# Check for NativeWind/Tailwind (should use StyleSheet)
if grep -n 'className=' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- className found — use StyleSheet.create() not NativeWind/Tailwind"
fi

# Check for Expo imports (bare RN only)
if grep -n "from 'expo" "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Expo import found — use bare React Native CLI packages"
fi

# Check for inline styles
if grep -n 'style={{' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Inline styles found — use StyleSheet.create() with theme"
fi

# Check for Dimensions.get (should use useWindowDimensions)
if grep -n 'Dimensions\.get' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- Dimensions.get() found — use useWindowDimensions() hook instead"
fi

# Check for console.log
if grep -n 'console\.log' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- console.log found — remove before commit"
fi

# Check for AsyncStorage (should use MMKV for non-sensitive, Keychain for sensitive)
if grep -n 'AsyncStorage' "$FILE_PATH" > /dev/null 2>&1; then
    ISSUES="${ISSUES}\n- AsyncStorage found — use MMKV for non-sensitive data, react-native-keychain for sensitive"
fi

if [ -n "$ISSUES" ]; then
    echo "React Native lint issues in $(basename "$FILE_PATH"):"
    echo -e "$ISSUES"
fi

exit 0
