#!/usr/bin/env bash
# Detect React.js project (not React Native) and inject context

if [ -f "package.json" ]; then
    HAS_REACT=$(jq -e '(.dependencies.react // .devDependencies.react) != null' package.json 2>/dev/null)
    HAS_RN=$(jq -e '(.dependencies["react-native"] // .devDependencies["react-native"]) != null' package.json 2>/dev/null)

    if [ "$HAS_REACT" = "true" ] && [ "$HAS_RN" != "true" ]; then
        echo "[React.js frontend project detected]"
        echo ""
        echo "Breezeware React conventions active:"
        echo "- React.js with JavaScript (not TypeScript)"
        echo "- Vite bundler, Axios for API calls"
        echo "- shadcn/ui components, Tailwind CSS"
        echo "- Redux Toolkit for state management"
        echo "- React Hook Form + Zod for forms"
        echo "- PropTypes for type checking"
        echo "- 4 states rule: loading, error, empty, success"
        echo ""
        echo "Available: /breezeware-react:reactjs-frontend, /breezeware-react:code-review-frontend"
    fi
fi
