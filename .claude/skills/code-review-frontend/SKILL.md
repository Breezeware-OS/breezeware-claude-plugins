---
name: code-review-frontend
description: Review React frontend code for bugs, security, performance, accessibility, and Breezeware convention violations. Use this skill when the user asks to review frontend code, React components, JSX, JavaScript, Redux slices, Axios services, or any client-side code. Also trigger when reviewing PRs that touch frontend files (.jsx, .js, .css) or the user says review React code, check component, audit frontend.
---

# Frontend Code Review Skill

Review React/JavaScript frontend code against Breezeware conventions. Read the
`component-gen` skill (`references/component-patterns.md`) for full pattern
reference before reviewing.

## 1. Security Check (Critical Priority)

- **XSS vulnerabilities**: No `dangerouslySetInnerHTML` without sanitization
- **Sensitive data exposure**: No tokens, secrets, or PII in frontend code or logs
- **Environment variables**: All must start with `VITE_`; never store secrets in frontend env vars
- **Auth token handling**: Stored in `localStorage` with proper cleanup on 401
- **Input sanitization**: User inputs validated before rendering or sending to API
- **URL construction**: No direct string concatenation with user input in URLs
- **Third-party scripts**: No inline `<script>` tags or unvetted CDN imports

## 2. Component Architecture

- **Functional components only** — no class components (except ErrorBoundary)
- **One component per file** — no multi-component files
- **Named function declarations** — `const UserCard = () => {}`, never anonymous default exports
- **PropTypes on ALL components** — validate every prop (JavaScript, not TypeScript)
- **`className` prop accepted** — all presentational components must accept it
- **Props destructured** — always in the function signature
- **JSDoc comment** — one-liner above every component
- **`export default ComponentName`** — at the bottom of the file
- **No business logic in components** — delegate to hooks, services, or Redux

## 3. State Management (Redux)

- **Redux Toolkit only** — no plain Redux, no `createStore`
- **One slice per feature** — co-located in `features/{name}/store/`
- **`createAsyncThunk`** — for all API calls with `rejectWithValue`
- **Status tracking** — `'idle' | 'loading' | 'succeeded' | 'failed'`
- **Error messages stored** — for UI display
- **No business logic in reducers** — pure data transformations only
- **No direct API calls in components** — always through thunks or services

## 4. The 4 States Rule

Every component that fetches data MUST handle all 4 states:
- **Loading** — skeleton loaders (not spinners)
- **Error** — error message with retry button
- **Empty** — meaningful empty state with CTA
- **Success** — the actual content

Flag any component that only handles success state.

## 5. API Integration

- **Single axios instance** — from `lib/axios.js`, never raw `axios` import
- **Service files per feature** — thin wrappers in `features/{name}/services/`
- **Interceptors configured** — auth token attachment, 401/403 redirects
- **Timeout set** — 15 seconds default
- **Error handling** — `rejectWithValue` in thunks, toast for user actions

## 6. Forms

- **React Hook Form + Zod** — always, never manual form state
- **`aria-invalid`** — set on inputs with validation errors
- **Error messages below inputs** — `text-xs text-destructive`
- **Loading state on submit** — spinner + disabled + text change
- **Double-submit prevention** — button disabled during API call
- **`<Label htmlFor>`** — every input must have an associated label

## 7. Responsive Design

- **Mobile-first** — base styles for mobile, breakpoints added up
- **No horizontal scroll** — at any breakpoint
- **Touch targets** — minimum 44×44px on mobile
- **Tables on mobile** — card layout or horizontal scroll, not raw table
- **Sidebar collapse** — sheet/drawer on mobile, full sidebar on desktop
- **Responsive grids** — `grid-cols-1 md:grid-cols-2 lg:grid-cols-3` patterns
- **Test at 320px** — smallest common viewport

## 8. Accessibility

- **All images have `alt`** — decorative images use `alt=""`
- **Interactive elements** — `<button>` or `<a>`, never `<div onClick>`
- **Icon-only buttons** — must have `aria-label`
- **Color contrast** — ratio ≥ 4.5:1 for normal text
- **Tab order logical** — no `tabIndex > 0`
- **Modals** — trap focus and close on Escape
- **Skip-to-content link** — for keyboard users

## 9. Performance

- **Lazy load routes** — `React.lazy()` + `Suspense`
- **`React.memo()`** — for components with expensive renders
- **`useCallback`** — for functions passed as props to children
- **`useMemo`** — for expensive computations
- **No inline objects/functions in JSX** — create new references every render
- **Virtualize long lists** — `react-window` for 100+ items
- **`loading="lazy"`** — on images
- **Debounce inputs** — 300ms for search, 500ms for autosave
- **Stable keys** — never array index for dynamic lists

## 10. Styling & Tailwind

- **Tailwind only** — no CSS modules, no styled-components, no inline `style={}`
- **`cn()` utility** — for conditional class merging (from shadcn)
- **shadcn/ui components** — use existing UI primitives, don't reinvent
- **Consistent spacing** — use Tailwind spacing scale (`p-4`, `gap-3`)
- **Dark mode aware** — use `text-foreground`, `bg-background`, not hardcoded colors

## 11. Project Structure

- **Feature-based organization** — `features/{name}/` with components, hooks, services, store
- **Shared components in `components/`** — only if used across 2+ features
- **Absolute imports** — `@/` alias, never `../../../`
- **Naming conventions**:
  - Components: `PascalCase.jsx`
  - Hooks: `useXxx.js`
  - Services: `xxxService.js`
  - Slices: `xxxSlice.js`
  - Event handlers: `handleXxx`
  - Boolean props: `isXxx` / `hasXxx`
  - Callback props: `onXxx`

## Output Format

```
## Frontend Code Review — [file/feature name]

### 🔴 Critical Issues (must fix)
- [issue + file:line + why it's critical + suggested fix]

### 🟡 Warnings (should fix)
- [issue + file:line + why it matters + suggested fix]

### 🟢 Suggestions (nice to have)
- [improvement + reasoning + expected benefit]

### ♿ Accessibility Issues
- [a11y issue + fix + WCAG reference if applicable]

### 📱 Responsive Issues
- [responsive issue + affected breakpoints + fix]

### ✅ What Looks Good
- [positive observations — always include these]
```

Always explain *why* something is an issue and *what risk* it introduces.
Reference the Breezeware convention being violated where applicable.
