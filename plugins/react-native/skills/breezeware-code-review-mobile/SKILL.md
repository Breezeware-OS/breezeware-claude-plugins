---
name: breezeware-code-review-mobile
description: Review React Native mobile code for bugs, security, performance, accessibility, and Breezeware convention violations. Use this skill when the user asks to review mobile code, React Native components, screens, navigation, native modules, or any mobile app code. Also trigger when reviewing PRs that touch .tsx/.ts files in a React Native project or the user says review mobile code, check screen, audit app, review React Native.
---

# Mobile Code Review Skill

Review React Native mobile code against Breezeware conventions. Read the
`breezeware-react-native` skill (`references/component-patterns.md`) for full pattern
reference before reviewing.

## 1. Security Check (Critical Priority)

- **Sensitive data storage**: Tokens/credentials MUST use `expo-secure-store`, NEVER `AsyncStorage`
- **No secrets in JS bundle**: API keys, tokens — extractable from the binary
- **Certificate pinning**: Verify for production API endpoints
- **Deep link validation**: All incoming deep link parameters must be validated
- **Biometric auth**: Used for sensitive operations (payments, profile changes)
- **Screen capture**: Disabled on sensitive screens (banking, PII display)
- **Auth token refresh**: Transparent 401 → refresh → retry flow implemented
- **Auto-logout**: On app background after configurable timeout
- **No `console.log` in production**: Stripped via Babel plugin
- **HTTPS only**: No HTTP exceptions in production `Info.plist` / `network_security_config.xml`

## 2. Component Architecture

- **Functional components only** — no class components (except ErrorBoundary)
- **One component per file** — no multi-component files
- **Named exports** — `export const UserCard`, never anonymous default exports
- **TypeScript interfaces** — all props in separate `.types.ts` file
- **`Pressable` over `TouchableOpacity`** — modern API with better customization
- **`numberOfLines`** — on ALL `Text` components that could overflow
- **`useCallback`** — for ALL event handlers passed as props
- **No inline styles** — use NativeWind classes or `StyleSheet.create()`
- **No business logic in components** — delegate to hooks, services, or Redux

## 3. The 5 States Rule

Every screen/component that fetches data MUST handle ALL 5 states:
1. **Offline** — no connectivity + no cached data
2. **Loading** — skeleton loaders (not spinners)
3. **Error** — error message with retry button
4. **Empty** — meaningful empty state with CTA
5. **Success** — the actual content

Flag any screen that only handles success state. Flag any screen missing offline handling.

## 4. Navigation

- **Type-safe navigation** — `ParamList` types defined, never `any`
- **Native stack** — `createNativeStackNavigator` for performance
- **Auth guard at root** — conditional rendering in `RootNavigator`, not per-screen
- **Deep linking configured** — for every public screen
- **Navigation ref** — for navigating outside React components
- **No navigation logic in components** — only in screens
- **Android back button** — handled with `useBackHandler` where needed
- **Screen options** — `headerShown`, `title`, `gestureEnabled` set per screen

## 5. Responsive Design

- **No hardcoded pixel values** for layout — use `scale()`, `moderateScale()`, or percentages
- **`useWindowDimensions`** — over `Dimensions.get()` (auto-updates on rotation)
- **Safe area insets** — `useSafeAreaInsets()` for top/bottom padding on ALL screens
- **Minimum touch target 44x44** — Apple HIG and Android accessibility requirement
- **Tablet layouts** — multi-column when `width >= 768`
- **Test on 5 device sizes**: iPhone SE, iPhone 15, iPhone 15 Plus, iPad Mini, iPad Pro
- **Dynamic Type** — respect user's font size accessibility settings
- **Notch/island/punch-hole** — no interactive elements behind system UI
- **Keyboard handling** — `KeyboardAvoidingView` on all forms

## 6. Accessibility

- **`accessibilityRole`** — on EVERY interactive element (`button`, `link`, `header`, etc.)
- **`accessibilityLabel`** — on elements without visible text
- **`accessibilityHint`** — for non-obvious actions
- **`accessibilityState`** — for toggles, checkboxes, disabled states
- **Touch targets ≥ 44x44** — use `hitSlop` to expand if element is smaller
- **Color contrast ≥ 4.5:1** — for normal text
- **`accessibilityIgnoresInvertColors`** — on images/photos
- **Screen reader test** — VoiceOver (iOS) and TalkBack (Android)
- **No text in images** — all text must be `Text` components
- **Focus management** — move focus to new content (modals, alerts)

## 7. Performance

- **FlatList for lists** — never ScrollView for 20+ items
- **`useCallback` on `renderItem` and `keyExtractor`** — prevents re-renders
- **`React.memo()` on list items** — prevents unnecessary re-renders
- **`removeClippedSubviews`** — enabled on long lists
- **`getItemLayout`** — provided when items have fixed height
- **`windowSize` and `maxToRenderPerBatch`** — tuned for list length
- **`expo-image` over `Image`** — for network images (caching, blurhash)
- **Reanimated 3** — for animations, never `Animated` API for complex animations
- **`InteractionManager.runAfterInteractions`** — defer heavy work after animations
- **No `console.log`** — stripped in production builds
- **Hermes enabled** — verify JS engine for faster startup + less memory
- **Inline object/function avoidance** — extract from JSX to prevent re-renders

## 8. State Management

- **Redux Toolkit** — for global app state (auth, settings, theme)
- **TanStack Query** — for server state (API data, caching, background refresh)
- **MMKV** — for fast local storage (non-sensitive preferences)
- **Expo SecureStore** — for sensitive data only (tokens, PII)
- **redux-persist with MMKV** — whitelist only necessary slices
- **Never store API data in Redux** — use TanStack Query
- **Local state for UI-only state** — modals, form inputs, toggles

## 9. API Integration

- **Single axios instance** — from `lib/axios.ts`, never raw `axios` import
- **Network check before requests** — via `NetInfo` in interceptor
- **Token refresh flow** — transparent 401 → refresh → retry
- **Request timeout** — 15 seconds default
- **TanStack Query for data fetching** — with `staleTime`, `retry`, `refetchOnReconnect`
- **Offline-first** — show cached data when offline, sync when back online
- **Error mapping** — convert API errors to user-friendly messages

## 10. Forms

- **React Hook Form + Zod** — always, never manual form state
- **`Controller` wrapper** — for all controlled inputs
- **`KeyboardAvoidingView`** — wraps every form
- **`keyboardShouldPersistTaps="handled"`** — on ScrollView
- **`textContentType`** (iOS) and `autoComplete`** (Android) — for autofill
- **`returnKeyType`** — "next" for intermediate, "done" for last field
- **Error messages below inputs** — red text, visible on blur/submit
- **Loading state on submit** — spinner + disabled + text change
- **Prevent double submission** — disable button during API call

## 11. Platform-Specific Code

- **`Platform.select()`** — for small style differences (shadows, fonts)
- **`.ios.tsx` / `.android.tsx`** — for fundamentally different implementations
- **Test on both platforms** — always, even for "simple" changes
- **Status bar** — configured per screen with `<StatusBar>`
- **Keyboard behavior** — `padding` on iOS, `height` on Android
- **Back button** — Android hardware back handled where needed
- **Permissions** — requested with platform-appropriate messaging

## 12. Error Handling

- **ErrorBoundary** — wraps every navigation stack and major feature section
- **Sentry integration** — captures all unhandled exceptions with context
- **User-friendly error messages** — never show raw errors or stack traces
- **Retry mechanism** — all error states have "Try Again" button
- **Global error handler** — catches unhandled promise rejections
- **`Alert.alert()` for fatal errors only** — inline error states for recoverable errors
- **Network errors differentiated** — "No internet" vs "Server error" vs "Timeout"

## 13. Push Notifications

- **Permission requested gracefully** — explain why before system prompt
- **Token registered with backend** — on login and token refresh
- **Notification tap handling** — navigates to correct screen
- **Android notification channels** — configured for different notification types
- **Badge management** — cleared on app open or notification read
- **Silent notifications** — for background data sync

## 14. Project Structure

- **Feature-based organization** — `features/{name}/` with screens, components, hooks, services, store
- **Screens in `screens/`** — full-page views, named `XxxScreen.tsx`
- **Navigation isolated** — all config in `navigation/` folder
- **Absolute imports** — `@/` alias, never `../../../`
- **Co-located tests** — `Component.test.tsx` next to `Component.tsx`

## Output Format

```
## Mobile Code Review — [screen/component name]

### 🔴 Critical Issues (must fix)
- [issue + file:line + why it's critical + suggested fix]

### 🟡 Warnings (should fix)
- [issue + file:line + why it matters + suggested fix]

### 🟢 Suggestions (nice to have)
- [improvement + reasoning + expected benefit]

### ♿ Accessibility Issues
- [a11y issue + fix + Apple HIG / Material Design reference]

### 📱 Platform-Specific Issues
- [iOS/Android issue + affected platform + fix]

### 🏎️ Performance Issues
- [perf issue + impact (dropped frames, memory, startup) + fix]

### 📡 Offline / Network Issues
- [offline handling issue + expected behavior + fix]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always explain *why* something is an issue and *what user experience impact* it has.
Reference the specific platform guideline (Apple HIG, Material Design) being violated.
