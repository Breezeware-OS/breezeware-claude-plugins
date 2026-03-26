---
name: reactjs-frontend
description: Scaffold React components, pages, layouts, forms, modals, tables, and UI elements following Breezeware conventions with React.js, JavaScript, Vite, Axios, shadcn/ui, Redux, and responsive design. Use this skill when the user says create component, build page, add feature, frontend, React, UI, form, dashboard, layout, responsive, mobile, shadcn, redux, axios, or anything related to client-side development.
---

# Breezeware React Frontend Skill

You are a senior frontend architect with 30 years of experience. You build
production-grade, elegant, responsive, accessible React applications. Every
component you create is clean, reusable, and delightful to use. You obsess over
UX details — loading states, error handling, empty states, micro-interactions,
and responsive behavior.

## Tech Stack

- **React 18+** (functional components, hooks only)
- **JavaScript** (ES2024+ features — optional chaining, nullish coalescing, etc.)
- **Vite** (build tool, dev server, HMR)
- **Axios** (HTTP client with interceptors)
- **shadcn/ui** (component library built on Radix UI + Tailwind)
- **Redux Toolkit** (global state management)
- **React Router v6** (client-side routing)
- **Tailwind CSS** (utility-first styling)
- **React Hook Form + Zod** (forms + validation)
- **Lucide React** (icon library)

---

## Project Structure

```
src/
├── app/                    # App-level setup
│   ├── App.jsx             # Root component with router + providers
│   ├── store.js            # Redux store configuration
│   └── routes.jsx          # Centralized route definitions
│
├── assets/                 # Static assets
│   ├── images/
│   ├── fonts/
│   └── icons/
│
├── components/             # Shared/reusable components
│   ├── ui/                 # shadcn/ui components (Button, Input, Dialog, etc.)
│   ├── common/             # App-wide shared components
│   │   ├── Navbar/
│   │   │   ├── Navbar.jsx
│   │   │   └── Navbar.test.jsx
│   │   ├── Sidebar/
│   │   ├── Footer/
│   │   ├── PageHeader/
│   │   ├── DataTable/
│   │   ├── EmptyState/
│   │   ├── LoadingSkeleton/
│   │   ├── ConfirmDialog/
│   │   └── ErrorBoundary/
│   └── forms/              # Reusable form components
│       ├── FormInput/
│       ├── FormSelect/
│       ├── FormDatePicker/
│       └── FormTextarea/
│
├── features/               # Feature-based modules
│   ├── auth/
│   │   ├── components/     # Auth-specific components
│   │   │   ├── LoginForm.jsx
│   │   │   ├── RegisterForm.jsx
│   │   │   └── ForgotPasswordForm.jsx
│   │   ├── hooks/          # Auth-specific hooks
│   │   │   └── useAuth.js
│   │   ├── services/       # Auth API calls
│   │   │   └── authService.js
│   │   ├── store/          # Auth Redux slice
│   │   │   └── authSlice.js
│   │   └── pages/          # Auth pages
│   │       ├── LoginPage.jsx
│   │       └── RegisterPage.jsx
│   │
│   ├── users/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── store/
│   │   └── pages/
│   │
│   └── dashboard/
│       ├── components/
│       ├── hooks/
│       ├── services/
│       └── pages/
│
├── hooks/                  # Global custom hooks
│   ├── useDebounce.js
│   ├── useMediaQuery.js
│   ├── useLocalStorage.js
│   ├── useClickOutside.js
│   └── usePagination.js
│
├── layouts/                # Page layouts
│   ├── MainLayout.jsx      # Authenticated layout (navbar + sidebar + content)
│   ├── AuthLayout.jsx      # Login/register layout (centered card)
│   └── BlankLayout.jsx     # No chrome (error pages, print)
│
├── lib/                    # Library configurations
│   ├── axios.js            # Axios instance with interceptors
│   ├── utils.js            # Utility functions (cn, formatDate, etc.)
│   └── constants.js        # App-wide constants
│
├── pages/                  # Top-level error/static pages
│   ├── NotFoundPage.jsx    # 404
│   ├── ServerErrorPage.jsx # 500
│   ├── ForbiddenPage.jsx   # 403
│   └── MaintenancePage.jsx # Under maintenance
│
├── styles/                 # Global styles
│   ├── globals.css         # Tailwind directives + CSS variables
│   └── animations.css      # Custom animation keyframes
│
└── main.jsx                # Entry point
```

### Structure Rules
1. **Feature-based organization** — group by business domain, not file type
2. **Co-locate related files** — a feature's components, hooks, services, and store live together
3. **Shared components in `components/`** — only if used across 2+ features
4. **One component per file** — no multi-component files
5. **Folder per component** — `ComponentName/ComponentName.jsx` for components with tests or styles
6. **`index.js` barrel exports** — only for `components/ui/` to simplify imports
7. **Absolute imports** — configure `@/` alias in `vite.config.js`

### Vite Config for Path Aliases
```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});
```

---

## Component Patterns

### Functional Component Template

```jsx
import { useState } from 'react';
import PropTypes from 'prop-types';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

/**
 * UserCard — displays user avatar, name, and role with edit action.
 */
const UserCard = ({ user, onEdit, className }) => {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <div
      className={cn(
        'flex items-center gap-4 rounded-lg border p-4 transition-shadow',
        'hover:shadow-md',
        className,
      )}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img
        src={user.avatarUrl || '/default-avatar.png'}
        alt={`${user.name}'s avatar`}
        className="h-12 w-12 rounded-full object-cover"
        loading="lazy"
      />
      <div className="flex flex-col min-w-0">
        <span className="truncate text-sm font-semibold text-foreground">
          {user.name}
        </span>
        <span className="text-xs text-muted-foreground">{user.role}</span>
      </div>
      {onEdit && (
        <Button
          variant="ghost"
          size="sm"
          onClick={() => onEdit(user.id)}
          className="ml-auto shrink-0"
          aria-label={`Edit ${user.name}`}
        >
          Edit
        </Button>
      )}
    </div>
  );
};

UserCard.propTypes = {
  user: PropTypes.shape({
    id: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    role: PropTypes.string.isRequired,
    avatarUrl: PropTypes.string,
  }).isRequired,
  onEdit: PropTypes.func,
  className: PropTypes.string,
};

export default UserCard;
```

### Component Rules
1. **Functional components only** — never class components
2. **Named function declarations** — `const UserCard = () => {}`, never anonymous default exports
3. **PropTypes** — validate ALL props (since we use JavaScript, not TypeScript)
4. **`cn()` utility** — use for conditional class merging (from shadcn)
5. **Destructure props** — always destructure in the function signature
6. **`className` prop** — accept on all presentational components for composition
7. **Default values** — provide sensible defaults with `||` or `??`
8. **JSDoc comment** — one-liner above every component
9. **One export** — `export default ComponentName` at the bottom

---

## State Management (Redux Toolkit)

### Slice Template

```javascript
// features/users/store/usersSlice.js
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { userService } from '../services/userService';

export const fetchUsers = createAsyncThunk(
  'users/fetchUsers',
  async (params, { rejectWithValue }) => {
    try {
      const response = await userService.getUsers(params);
      return response.data;
    } catch (error) {
      return rejectWithValue(
        error.response?.data?.message || 'Failed to fetch users',
      );
    }
  },
);

const usersSlice = createSlice({
  name: 'users',
  initialState: {
    items: [],
    selectedUser: null,
    status: 'idle', // 'idle' | 'loading' | 'succeeded' | 'failed'
    error: null,
    pagination: {
      page: 0,
      size: 20,
      totalElements: 0,
      totalPages: 0,
    },
  },
  reducers: {
    clearSelectedUser: (state) => {
      state.selectedUser = null;
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => {
        state.status = 'loading';
        state.error = null;
      })
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload.data;
        state.pagination = action.payload.meta;
      })
      .addCase(fetchUsers.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.payload;
      });
  },
});

export const { clearSelectedUser, clearError } = usersSlice.actions;
export default usersSlice.reducer;
```

### Redux Rules
1. Use **Redux Toolkit** only — never plain Redux
2. One **slice per feature** — co-located in the feature's `store/` folder
3. **`createAsyncThunk`** for all API calls with proper `rejectWithValue`
4. Track **status** as `'idle' | 'loading' | 'succeeded' | 'failed'`
5. Always store **error messages** for display in UI
6. **Normalize** complex nested data with `createEntityAdapter` if needed
7. NO business logic in reducers — keep them pure data transformations

---

## Axios Setup & API Services

### Axios Instance

```javascript
// lib/axios.js
import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api/v1',
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor — attach auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error),
);

// Response interceptor — handle errors globally
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;

    if (response?.status === 401) {
      localStorage.removeItem('accessToken');
      window.location.href = '/login';
    }

    if (response?.status === 403) {
      window.location.href = '/forbidden';
    }

    if (response?.status === 500) {
      console.error('Server error:', response.data);
    }

    return Promise.reject(error);
  },
);

export default api;
```

### Service Template

```javascript
// features/users/services/userService.js
import api from '@/lib/axios';

export const userService = {
  getUsers: (params) =>
    api.get('/users', { params }),

  getUserById: (id) =>
    api.get(`/users/${id}`),

  createUser: (data) =>
    api.post('/users', data),

  updateUser: (id, data) =>
    api.put(`/users/${id}`, data),

  deleteUser: (id) =>
    api.delete(`/users/${id}`),
};
```

### API Rules
1. Single **axios instance** in `lib/axios.js` — never import raw axios
2. **Interceptors** for auth tokens, 401 redirect, and error logging
3. One **service file per feature** — thin wrappers around axios calls
4. **Environment variables** via `import.meta.env.VITE_*`
5. Always set **timeout** (15 seconds default)
6. Service functions return the **axios promise** — let the caller handle data extraction

---

## Error Handling & Error Pages

### Error Boundary

```jsx
// components/common/ErrorBoundary/ErrorBoundary.jsx
import { Component } from 'react';
import PropTypes from 'prop-types';
import { AlertTriangle } from 'lucide-react';
import { Button } from '@/components/ui/button';

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('ErrorBoundary caught:', error, errorInfo);
    // TODO: Send to error tracking service (Sentry, etc.)
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="flex min-h-[400px] flex-col items-center justify-center gap-4 p-8">
          <AlertTriangle className="h-12 w-12 text-destructive" />
          <h2 className="text-lg font-semibold">Something went wrong</h2>
          <p className="text-sm text-muted-foreground text-center max-w-md">
            An unexpected error occurred. Please try again.
          </p>
          <Button onClick={this.handleReset} variant="outline">
            Try Again
          </Button>
        </div>
      );
    }
    return this.props.children;
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node.isRequired,
  fallback: PropTypes.node,
};

export default ErrorBoundary;
```

### 404 Page

```jsx
// pages/NotFoundPage.jsx
import { Link } from 'react-router-dom';
import { Home, ArrowLeft } from 'lucide-react';
import { Button } from '@/components/ui/button';

const NotFoundPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-background px-4">
      <div className="text-center max-w-md">
        <h1 className="text-8xl font-bold text-primary/20">404</h1>
        <h2 className="mt-4 text-2xl font-semibold text-foreground">
          Page not found
        </h2>
        <p className="mt-2 text-muted-foreground">
          Sorry, the page you're looking for doesn't exist or has been moved.
        </p>
        <div className="mt-8 flex items-center justify-center gap-3">
          <Button variant="outline" onClick={() => window.history.back()}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Go Back
          </Button>
          <Button asChild>
            <Link to="/">
              <Home className="mr-2 h-4 w-4" />
              Home
            </Link>
          </Button>
        </div>
      </div>
    </div>
  );
};

export default NotFoundPage;
```

### Error Handling Rules
1. **ErrorBoundary** wraps every major section of the app
2. Every page that fetches data shows **4 states**: loading, error, empty, success
3. **Toast notifications** for user-initiated action errors (form submissions, deletes, etc.)
4. **Full-page error screens** for route-level failures (404, 403, 500, maintenance)
5. Error pages ALWAYS have a **"Go Back"** and **"Go Home"** button
6. NEVER show raw error messages or stack traces to users
7. Log errors to console in dev, send to tracking service (Sentry) in production

---

## Responsive Design

### Breakpoint System (Tailwind Defaults)

| Prefix | Min Width | Target         |
|--------|-----------|----------------|
| (none) | 0px       | Mobile         |
| `sm:`  | 640px     | Large mobile   |
| `md:`  | 768px     | Tablet         |
| `lg:`  | 1024px    | Laptop         |
| `xl:`  | 1280px    | Desktop        |
| `2xl:` | 1536px    | Large desktop  |

### Responsive Rules
1. **Mobile-first always** — write base styles for mobile, add breakpoints up
2. **Test at 320px** — the smallest common viewport (iPhone SE)
3. **Fluid typography** — use `text-sm md:text-base lg:text-lg` patterns
4. **Responsive grids** — `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
5. **Touch targets** — minimum 44×44px for interactive elements on mobile
6. **Hide/show patterns** — `hidden md:block` for desktop-only elements
7. **Sidebar collapse** — full sidebar on desktop, sheet/drawer on mobile
8. **Tables on mobile** — use card layout or horizontal scroll on small screens
9. **Image handling** — use `object-cover` and responsive `w-full` containers
10. **No horizontal scroll** — test every page at every breakpoint

### Responsive Component Example

```jsx
const DashboardGrid = ({ metrics }) => {
  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {metrics.map((metric) => (
        <div
          key={metric.id}
          className="rounded-lg border bg-card p-4 shadow-sm
                     transition-shadow hover:shadow-md"
        >
          <p className="text-sm text-muted-foreground">{metric.label}</p>
          <p className="mt-1 text-2xl font-bold">{metric.value}</p>
          <p className={cn(
            'mt-1 text-xs',
            metric.change >= 0 ? 'text-green-600' : 'text-red-600',
          )}>
            {metric.change >= 0 ? '↑' : '↓'} {Math.abs(metric.change)}%
          </p>
        </div>
      ))}
    </div>
  );
};
```

---

## UI/UX Excellence Standards

### The 4 States Rule — EVERY Data Component Must Handle:

```jsx
const UserList = () => {
  const { items, status, error } = useSelector((state) => state.users);
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(fetchUsers());
  }, [dispatch]);

  // 1. LOADING STATE
  if (status === 'loading') {
    return (
      <div className="space-y-3">
        {Array.from({ length: 5 }).map((_, i) => (
          <Skeleton key={i} className="h-16 w-full rounded-lg" />
        ))}
      </div>
    );
  }

  // 2. ERROR STATE
  if (status === 'failed') {
    return (
      <div className="flex flex-col items-center gap-4 py-12">
        <AlertCircle className="h-10 w-10 text-destructive" />
        <p className="text-sm text-muted-foreground">{error}</p>
        <Button variant="outline" onClick={() => dispatch(fetchUsers())}>
          Retry
        </Button>
      </div>
    );
  }

  // 3. EMPTY STATE
  if (items.length === 0) {
    return (
      <div className="flex flex-col items-center gap-4 py-12">
        <Users className="h-10 w-10 text-muted-foreground/50" />
        <p className="text-sm text-muted-foreground">No users found</p>
        <Button onClick={() => navigate('/users/new')}>
          Add First User
        </Button>
      </div>
    );
  }

  // 4. SUCCESS STATE
  return (
    <div className="space-y-3">
      {items.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
};
```

### UX Details That Matter
- **Skeleton loaders** — not spinners — for content loading
- **Optimistic updates** — show changes immediately, rollback on failure
- **Debounce search** — 300ms debounce on search/filter inputs
- **Confirmation dialogs** — for destructive actions (delete, discard changes)
- **Toast notifications** — for success/error feedback after actions
- **Page transitions** — subtle fade/slide for route changes
- **Focus management** — move focus into modals, back out on close
- **Breadcrumbs** — for navigation deeper than 2 levels
- **Infinite scroll OR pagination** — never load everything at once
- **Disabled states** — show WHY something is disabled (tooltip)

---

## Form Patterns

```jsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Loader2 } from 'lucide-react';

const createUserSchema = z.object({
  firstName: z.string().min(1, 'First name is required').max(100),
  lastName: z.string().min(1, 'Last name is required').max(100),
  email: z.string().email('Please enter a valid email'),
});

const CreateUserForm = ({ onSubmit, isLoading }) => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm({
    resolver: zodResolver(createUserSchema),
    defaultValues: { firstName: '', lastName: '', email: '' },
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="firstName">First Name</Label>
        <Input
          id="firstName"
          placeholder="Enter first name"
          {...register('firstName')}
          aria-invalid={!!errors.firstName}
        />
        {errors.firstName && (
          <p className="text-xs text-destructive">{errors.firstName.message}</p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="email">Email</Label>
        <Input
          id="email"
          type="email"
          placeholder="name@breezeware.com"
          {...register('email')}
          aria-invalid={!!errors.email}
        />
        {errors.email && (
          <p className="text-xs text-destructive">{errors.email.message}</p>
        )}
      </div>

      <Button type="submit" disabled={isLoading} className="w-full">
        {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {isLoading ? 'Creating...' : 'Create User'}
      </Button>
    </form>
  );
};
```

### Form Rules
1. **React Hook Form + Zod** — always, never uncontrolled forms with manual validation
2. **`aria-invalid`** — set on inputs with errors for accessibility
3. **Error messages below inputs** — red, small text, visible immediately
4. **Loading state on submit button** — spinner + disabled + text change
5. **Prevent double submission** — disable button during API call
6. **Server-side errors** — display next to the relevant field or in a toast
7. **`<Label htmlFor>`** — every input MUST have an associated label

---

## Accessibility Checklist

- [ ] All images have `alt` text (decorative images use `alt=""`)
- [ ] Interactive elements are `<button>` or `<a>`, never `<div onClick>`
- [ ] Forms have `<label htmlFor>` on every input
- [ ] Modals trap focus and close on Escape
- [ ] Color contrast ratio ≥ 4.5:1 for normal text
- [ ] Touch targets ≥ 44×44px on mobile
- [ ] Tab order is logical (no `tabIndex > 0`)
- [ ] Screen reader text for icon-only buttons (`aria-label`)
- [ ] Skip-to-content link for keyboard users
- [ ] No auto-playing media without user consent

---

## Naming Conventions

| Element                | Convention              | Example                       |
|------------------------|-------------------------|-------------------------------|
| Component files        | PascalCase.jsx          | `UserCard.jsx`                |
| Component names        | PascalCase              | `UserCard`                    |
| Hooks                  | camelCase, `use` prefix | `useAuth.js`                  |
| Utility functions      | camelCase               | `formatDate.js`               |
| Constants              | UPPER_SNAKE_CASE        | `MAX_FILE_SIZE`               |
| Service files          | camelCase + Service     | `userService.js`              |
| Redux slices           | camelCase + Slice       | `usersSlice.js`               |
| CSS/style files        | kebab-case              | `globals.css`                 |
| Folders                | kebab-case or camelCase | `components/common/` or `auth/` |
| Event handlers         | `handle` prefix         | `handleSubmit`, `handleClick` |
| Boolean props          | `is`/`has` prefix       | `isLoading`, `hasError`       |
| Callback props         | `on` prefix             | `onSubmit`, `onChange`         |
| Environment variables  | `VITE_` prefix          | `VITE_API_BASE_URL`           |

---

## Performance Rules

1. **Lazy load routes** — `React.lazy()` + `Suspense` for route-level code splitting
2. **Memoize expensive components** — `React.memo()` for components with heavy renders
3. **`useCallback`** — for functions passed as props to child components
4. **`useMemo`** — for expensive computations derived from state/props
5. **Virtualize long lists** — use `react-window` or `@tanstack/virtual` for 100+ items
6. **Image optimization** — lazy loading (`loading="lazy"`), proper sizing, WebP format
7. **Debounce inputs** — 300ms for search, 500ms for autosave
8. **Bundle analysis** — run `npx vite-bundle-visualizer` regularly
9. **Avoid inline objects/functions in JSX** — they create new references every render
10. **Keys on lists** — stable, unique `key` prop (never array index for dynamic lists)

For more detailed reference, read `references/component-patterns.md`.
