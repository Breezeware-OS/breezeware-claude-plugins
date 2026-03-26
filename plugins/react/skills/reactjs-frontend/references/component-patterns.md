# Component Patterns & Recipes Reference

## Route Setup with Lazy Loading

```jsx
// app/routes.jsx
import { lazy, Suspense } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import MainLayout from '@/layouts/MainLayout';
import AuthLayout from '@/layouts/AuthLayout';
import BlankLayout from '@/layouts/BlankLayout';
import LoadingScreen from '@/components/common/LoadingScreen/LoadingScreen';
import ErrorBoundary from '@/components/common/ErrorBoundary/ErrorBoundary';

// Lazy-loaded pages
const LoginPage = lazy(() => import('@/features/auth/pages/LoginPage'));
const DashboardPage = lazy(() => import('@/features/dashboard/pages/DashboardPage'));
const UserListPage = lazy(() => import('@/features/users/pages/UserListPage'));
const UserDetailPage = lazy(() => import('@/features/users/pages/UserDetailPage'));
const NotFoundPage = lazy(() => import('@/pages/NotFoundPage'));
const ForbiddenPage = lazy(() => import('@/pages/ForbiddenPage'));
const ServerErrorPage = lazy(() => import('@/pages/ServerErrorPage'));

const AppRoutes = () => (
  <ErrorBoundary>
    <Suspense fallback={<LoadingScreen />}>
      <Routes>
        {/* Auth routes */}
        <Route element={<AuthLayout />}>
          <Route path="/login" element={<LoginPage />} />
        </Route>

        {/* Protected routes */}
        <Route element={<ProtectedRoute />}>
          <Route element={<MainLayout />}>
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            <Route path="/dashboard" element={<DashboardPage />} />
            <Route path="/users" element={<UserListPage />} />
            <Route path="/users/:id" element={<UserDetailPage />} />
          </Route>
        </Route>

        {/* Error routes */}
        <Route element={<BlankLayout />}>
          <Route path="/forbidden" element={<ForbiddenPage />} />
          <Route path="/server-error" element={<ServerErrorPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </Suspense>
  </ErrorBoundary>
);

export default AppRoutes;
```

## Protected Route Component

```jsx
// components/common/ProtectedRoute/ProtectedRoute.jsx
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useSelector } from 'react-redux';

const ProtectedRoute = ({ allowedRoles }) => {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  if (allowedRoles && !allowedRoles.includes(user?.role)) {
    return <Navigate to="/forbidden" replace />;
  }

  return <Outlet />;
};

export default ProtectedRoute;
```

## Main Layout with Responsive Sidebar

```jsx
// layouts/MainLayout.jsx
import { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { Menu } from 'lucide-react';
import Navbar from '@/components/common/Navbar/Navbar';
import Sidebar from '@/components/common/Sidebar/Sidebar';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import useMediaQuery from '@/hooks/useMediaQuery';

const MainLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const isDesktop = useMediaQuery('(min-width: 1024px)');

  return (
    <div className="min-h-screen bg-background">
      <Navbar>
        {!isDesktop && (
          <Sheet open={sidebarOpen} onOpenChange={setSidebarOpen}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" className="lg:hidden">
                <Menu className="h-5 w-5" />
                <span className="sr-only">Toggle menu</span>
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="w-72 p-0">
              <Sidebar onNavigate={() => setSidebarOpen(false)} />
            </SheetContent>
          </Sheet>
        )}
      </Navbar>

      <div className="flex">
        {/* Desktop sidebar */}
        {isDesktop && (
          <aside className="sticky top-16 h-[calc(100vh-4rem)] w-64 shrink-0 border-r">
            <Sidebar />
          </aside>
        )}

        {/* Main content */}
        <main className="flex-1 p-4 md:p-6 lg:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default MainLayout;
```

## useMediaQuery Hook

```javascript
// hooks/useMediaQuery.js
import { useState, useEffect } from 'react';

const useMediaQuery = (query) => {
  const [matches, setMatches] = useState(
    () => window.matchMedia(query).matches,
  );

  useEffect(() => {
    const mediaQuery = window.matchMedia(query);
    const handler = (event) => setMatches(event.matches);

    mediaQuery.addEventListener('change', handler);
    return () => mediaQuery.removeEventListener('change', handler);
  }, [query]);

  return matches;
};

export default useMediaQuery;
```

## useDebounce Hook

```javascript
// hooks/useDebounce.js
import { useState, useEffect } from 'react';

const useDebounce = (value, delay = 300) => {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
};

export default useDebounce;
```

## Data Table with Pagination

```jsx
// components/common/DataTable/DataTable.jsx
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Skeleton } from '@/components/ui/skeleton';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const DataTable = ({ columns, data, pagination, onPageChange, isLoading }) => {
  if (isLoading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 5 }).map((_, i) => (
          <Skeleton key={i} className="h-12 w-full" />
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {/* Desktop table */}
      <div className="hidden md:block rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map((col) => (
                <TableHead key={col.key} className={col.className}>
                  {col.label}
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.map((row) => (
              <TableRow key={row.id}>
                {columns.map((col) => (
                  <TableCell key={col.key}>
                    {col.render ? col.render(row) : row[col.key]}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Mobile card layout */}
      <div className="space-y-3 md:hidden">
        {data.map((row) => (
          <div key={row.id} className="rounded-lg border p-4 space-y-2">
            {columns.map((col) => (
              <div key={col.key} className="flex justify-between text-sm">
                <span className="text-muted-foreground">{col.label}</span>
                <span className="font-medium">
                  {col.render ? col.render(row) : row[col.key]}
                </span>
              </div>
            ))}
          </div>
        ))}
      </div>

      {/* Pagination */}
      {pagination && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            Page {pagination.page + 1} of {pagination.totalPages}
          </p>
          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              disabled={pagination.page === 0}
              onClick={() => onPageChange(pagination.page - 1)}
            >
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <Button
              variant="outline"
              size="sm"
              disabled={pagination.page >= pagination.totalPages - 1}
              onClick={() => onPageChange(pagination.page + 1)}
            >
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
};

export default DataTable;
```

## Toast Setup (shadcn Sonner)

```jsx
// In App.jsx — add the Toaster provider
import { Toaster } from '@/components/ui/sonner';

const App = () => (
  <Provider store={store}>
    <BrowserRouter>
      <AppRoutes />
      <Toaster position="top-right" richColors closeButton />
    </BrowserRouter>
  </Provider>
);

// Usage in any component
import { toast } from 'sonner';

const handleDelete = async (id) => {
  try {
    await userService.deleteUser(id);
    toast.success('User deleted successfully');
    dispatch(fetchUsers());
  } catch (error) {
    toast.error(error.response?.data?.message || 'Failed to delete user');
  }
};
```

## Environment Variables

```bash
# .env.development
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_APP_NAME=Breezeware
VITE_ENABLE_MOCK=false

# .env.production
VITE_API_BASE_URL=https://api.breezeware.com/api/v1
VITE_APP_NAME=Breezeware
VITE_ENABLE_MOCK=false
```

Rules:
- ALL env vars MUST start with `VITE_` to be exposed to the client
- Access via `import.meta.env.VITE_*`
- NEVER put secrets in frontend env vars — they're visible in the bundle
- Commit `.env.example`, gitignore `.env.development` and `.env.production`

## jsconfig.json (for IDE support)

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"]
}
```
