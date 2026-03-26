#!/usr/bin/env bash
# Detect React Native project and inject context

if [ -f "package.json" ]; then
    HAS_RN=$(jq -e '(.dependencies["react-native"] // .devDependencies["react-native"]) != null' package.json 2>/dev/null)

    if [ "$HAS_RN" = "true" ]; then
        echo "[React Native mobile project detected]"
        echo ""
        echo "Breezeware React Native conventions active:"
        echo "- Bare React Native CLI with JavaScript (not Expo)"
        echo "- React Navigation v7 for navigation"
        echo "- Redux Toolkit + TanStack Query for state"
        echo "- StyleSheet.create() with theme system (not NativeWind)"
        echo "- react-native-keychain for secure storage"
        echo "- 5 states rule: loading, error, empty, success, offline"
        echo "- PropTypes for type checking"
        echo ""
        echo "Available: /breezeware-react-native:react-native, /breezeware-react-native:code-review-mobile"
    fi
fi
