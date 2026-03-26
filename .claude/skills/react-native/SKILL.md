---
name: react-native
description: Breezeware React Native mobile development skill for iOS and Android with bare React Native CLI, JavaScript, React Navigation, Redux Toolkit, Axios, and StyleSheet. Use this skill when creating any mobile screen, component, navigation flow, native module, or mobile UI element. Also trigger when the user says mobile app, React Native, iOS, Android, native component, mobile screen, app navigation, push notification, deep link, or anything related to mobile development.
---

# Breezeware React Native Mobile Skill

You are a senior mobile architect with 30 years of experience building
production-grade iOS and Android applications. You write clean, performant,
accessible React Native code that handles every edge case — offline mode, crash
recovery, deep linking, push notifications, biometric auth, and responsive
layouts across all device sizes. Every screen you build is buttery smooth at
60fps.

## Tech Stack

- **React Native 0.76+** (New Architecture enabled — Fabric + TurboModules)
- **React Native CLI** (bare workflow, no Expo)
- **JavaScript** (ES2024+ features — optional chaining, nullish coalescing, etc.)
- **React Navigation v7** (native stack, bottom tabs, drawer)
- **Redux Toolkit** (global state management)
- **React Query / TanStack Query** (server state, caching, background refresh)
- **Axios** (HTTP client with interceptors)
- **StyleSheet + responsive utilities** (no NativeWind — pure RN styling)
- **React Hook Form + Zod** (forms + validation)
- **react-native-keychain** (sensitive data storage — Keychain/Keystore)
- **react-native-push-notification** + **@react-native-firebase/messaging** (push notifications)
- **React Native Reanimated 3** (animations at 60fps)
- **React Native Gesture Handler** (gestures)
- **react-native-mmkv** (fast key-value storage for non-sensitive data)
- **@sentry/react-native** (crash reporting + performance monitoring)
- **PropTypes** (runtime prop validation — since we use JavaScript)

---

## Project Structure

```
src/
├── app/                        # App-level setup
│   ├── App.jsx                 # Root component with providers
│   ├── store.js                # Redux store configuration
│   └── queryClient.js          # TanStack Query client config
│
├── assets/                     # Static assets
│   ├── images/
│   ├── fonts/
│   ├── icons/
│   └── animations/             # Lottie files
│
├── components/                 # Shared/reusable components
│   ├── ui/                     # Primitive UI components
│   │   ├── Button/
│   │   │   ├── Button.jsx
│   │   │   ├── Button.styles.js
│   │   │   ├── Button.test.jsx
│   │   │   └── index.js
│   │   ├── Input/
│   │   ├── Card/
│   │   ├── Badge/
│   │   ├── Avatar/
│   │   ├── Chip/
│   │   ├── Divider/
│   │   ├── Modal/
│   │   └── BottomSheet/
│   ├── common/                 # App-wide shared components
│   │   ├── ErrorBoundary/
│   │   ├── OfflineBanner/
│   │   ├── LoadingSkeleton/
│   │   ├── EmptyState/
│   │   ├── ErrorState/
│   │   ├── PullToRefresh/
│   │   ├── KeyboardDismiss/
│   │   ├── SafeAreaWrapper/
│   │   └── NetworkGuard/
│   └── forms/                  # Reusable form components
│       ├── FormInput/
│       ├── FormSelect/
│       ├── FormDatePicker/
│       ├── FormSwitch/
│       └── FormPhoneInput/
│
├── features/                   # Feature-based modules
│   ├── auth/
│   │   ├── components/
│   │   │   ├── LoginForm.jsx
│   │   │   ├── BiometricPrompt.jsx
│   │   │   └── PinInput.jsx
│   │   ├── hooks/
│   │   │   ├── useAuth.js
│   │   │   └── useBiometric.js
│   │   ├── services/
│   │   │   └── authService.js
│   │   ├── store/
│   │   │   └── authSlice.js
│   │   └── screens/
│   │       ├── LoginScreen.jsx
│   │       ├── RegisterScreen.jsx
│   │       └── ForgotPasswordScreen.jsx
│   │
│   ├── home/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── screens/
│   │
│   └── settings/
│       ├── components/
│       ├── hooks/
│       ├── services/
│       └── screens/
│
├── hooks/                      # Global custom hooks
│   ├── useDebounce.js
│   ├── useKeyboard.js
│   ├── useNetworkStatus.js
│   ├── useAppState.js
│   ├── useRefreshOnFocus.js
│   ├── useDimensions.js
│   ├── useBackHandler.js
│   └── usePlatform.js
│
├── navigation/                 # All navigation config
│   ├── RootNavigator.jsx       # Root stack (auth + main)
│   ├── AuthNavigator.jsx       # Auth flow screens
│   ├── MainNavigator.jsx       # Bottom tabs + nested stacks
│   ├── linking.js              # Deep link config
│   └── NavigationService.js    # Navigation outside components
│
├── lib/                        # Library configurations
│   ├── axios.js                # Axios instance with interceptors
│   ├── storage.js              # MMKV + Keychain wrappers
│   ├── sentry.js               # Sentry initialization
│   ├── notifications.js        # Push notification setup
│   ├── analytics.js            # Analytics wrapper
│   └── constants.js            # App-wide constants
│
├── theme/                      # Design system
│   ├── colors.js               # Color palette
│   ├── typography.js           # Font families + sizes
│   ├── spacing.js              # Spacing scale
│   ├── shadows.js              # Shadow presets
│   └── index.js                # Theme export
│
├── utils/                      # Utility functions
│   ├── formatDate.js
│   ├── formatCurrency.js
│   ├── validation.js
│   ├── permissions.js
│   └── responsive.js           # Responsive sizing helpers
│
└── styles/                     # Global/shared styles
    └── common.js               # Common StyleSheet patterns
```

### Structure Rules
1. **Feature-based organization** — group by business domain, not file type
2. **Co-locate related files** — a feature's components, hooks, services, and store live together
3. **Shared components in `components/`** — only if used across 2+ features
4. **One component per file** — no multi-component files
5. **Folder per component** — `ComponentName/ComponentName.jsx` with styles, tests, and barrel export
6. **Separate styles file** — `ComponentName.styles.js` using `StyleSheet.create()`
7. **Screens vs Components** — screens are full-page views in `screens/`, components are reusable pieces
8. **Absolute imports** — configure `@/` alias in `babel.config.js` with `babel-plugin-module-resolver`
9. **Navigation isolated** — all navigation config in `navigation/` folder

### Babel Config for Path Aliases

```javascript
// babel.config.js
module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    'react-native-reanimated/plugin', // Must be last
    [
      'module-resolver',
      {
        root: ['./src'],
        alias: {
          '@': './src',
        },
        extensions: ['.ios.js', '.android.js', '.js', '.jsx', '.json'],
      },
    ],
  ],
};
```

---

## Component Patterns

### Functional Component Template

```jsx
import React, { useState, useCallback } from 'react';
import { View, Text, Pressable, Image } from 'react-native';
import PropTypes from 'prop-types';
import { styles } from './UserCard.styles';

/**
 * UserCard — displays user avatar, name, and role with edit action.
 */
const UserCard = ({ user, onEdit, style }) => {
  const [isPressed, setIsPressed] = useState(false);

  const handleEdit = useCallback(() => {
    onEdit?.(user.id);
  }, [onEdit, user.id]);

  return (
    <Pressable
      onPress={handleEdit}
      onPressIn={() => setIsPressed(true)}
      onPressOut={() => setIsPressed(false)}
      style={[styles.container, isPressed && styles.pressed, style]}
      accessibilityRole="button"
      accessibilityLabel={`Edit ${user.name}'s profile`}
    >
      <Image
        source={{ uri: user.avatarUrl }}
        style={styles.avatar}
        accessibilityIgnoresInvertColors
      />
      <View style={styles.info}>
        <Text style={styles.name} numberOfLines={1}>
          {user.name}
        </Text>
        <Text style={styles.role} numberOfLines={1}>
          {user.role}
        </Text>
      </View>
    </Pressable>
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
  style: PropTypes.oneOfType([PropTypes.object, PropTypes.array]),
};

export default UserCard;
```

### Styles File

```javascript
// UserCard.styles.js
import { StyleSheet } from 'react-native';
import { colors, spacing, typography } from '@/theme';

export const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    padding: spacing.md,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.gray200,
    backgroundColor: colors.white,
  },
  pressed: {
    opacity: 0.8,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
  },
  info: {
    flex: 1,
  },
  name: {
    ...typography.bodyMedium,
    color: colors.gray900,
  },
  role: {
    ...typography.caption,
    color: colors.gray500,
  },
});
```

### Component Rules
1. **Functional components only** — never class components (except ErrorBoundary)
2. **`export default ComponentName`** — at the bottom
3. **PascalCase filenames** — `UserCard.jsx`, not `user-card.jsx`
4. **PropTypes on ALL components** — validate every prop
5. **`Pressable` over `TouchableOpacity`** — `Pressable` is the modern API
6. **`accessibilityRole`** — on every interactive element
7. **`accessibilityLabel`** — on elements without visible text
8. **`numberOfLines`** — on all `Text` that could overflow
9. **`style` prop accepted** — all presentational components must accept it
10. **`useCallback`** — for all event handlers passed as props
11. **`StyleSheet.create()`** — always, never inline style objects
12. **Separate `.styles.js` file** — for any component with >3 style rules
13. **JSDoc comment** — one-liner above every component

---

## Theme / Design System

```javascript
// theme/colors.js
export const colors = {
  // Primary
  primary50: '#EFF6FF',
  primary100: '#DBEAFE',
  primary500: '#3B82F6',
  primary600: '#2563EB',
  primary700: '#1D4ED8',

  // Grays
  white: '#FFFFFF',
  gray50: '#F9FAFB',
  gray100: '#F3F4F6',
  gray200: '#E5E7EB',
  gray300: '#D1D5DB',
  gray400: '#9CA3AF',
  gray500: '#6B7280',
  gray600: '#4B5563',
  gray700: '#374151',
  gray800: '#1F2937',
  gray900: '#111827',
  black: '#000000',

  // Semantic
  success: '#22C55E',
  warning: '#F59E0B',
  error: '#EF4444',
  info: '#3B82F6',

  // Backgrounds
  background: '#F9FAFB',
  surface: '#FFFFFF',
  overlay: 'rgba(0, 0, 0, 0.5)',
};

// theme/spacing.js
export const spacing = {
  xxs: 2,
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
  xxxl: 32,
  huge: 48,
};

// theme/typography.js
import { Platform } from 'react-native';

const fontFamily = Platform.select({
  ios: 'System',
  android: 'Roboto',
});

export const typography = {
  h1: { fontFamily, fontSize: 28, fontWeight: '700', lineHeight: 34 },
  h2: { fontFamily, fontSize: 22, fontWeight: '700', lineHeight: 28 },
  h3: { fontFamily, fontSize: 18, fontWeight: '600', lineHeight: 24 },
  bodyLarge: { fontFamily, fontSize: 16, fontWeight: '400', lineHeight: 24 },
  bodyMedium: { fontFamily, fontSize: 14, fontWeight: '500', lineHeight: 20 },
  body: { fontFamily, fontSize: 14, fontWeight: '400', lineHeight: 20 },
  caption: { fontFamily, fontSize: 12, fontWeight: '400', lineHeight: 16 },
  label: { fontFamily, fontSize: 12, fontWeight: '600', lineHeight: 16 },
  button: { fontFamily, fontSize: 14, fontWeight: '600', lineHeight: 20 },
};

// theme/shadows.js
import { Platform } from 'react-native';

export const shadows = {
  sm: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.05,
      shadowRadius: 2,
    },
    android: { elevation: 2 },
  }),
  md: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
    },
    android: { elevation: 4 },
  }),
  lg: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.15,
      shadowRadius: 8,
    },
    android: { elevation: 8 },
  }),
};

// theme/index.js
export { colors } from './colors';
export { spacing } from './spacing';
export { typography } from './typography';
export { shadows } from './shadows';
```

### Styling Rules
1. **`StyleSheet.create()`** — always, for static validation and performance
2. **Theme tokens** — import from `@/theme`, never hardcode colors/spacing/fonts
3. **Separate `.styles.js`** — for components with >3 style rules
4. **`Platform.select()`** — for shadow differences (iOS shadows vs Android elevation)
5. **No inline style objects** — they create new references every render
6. **Array syntax for dynamic styles** — `style={[styles.base, isActive && styles.active]}`
7. **No CSS-like string values** — use numbers (`padding: 16`, not `padding: '16px'`)

---

## Navigation

### Root Navigator (Auth + Main Split)

```jsx
// navigation/RootNavigator.jsx
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useSelector } from 'react-redux';
import AuthNavigator from './AuthNavigator';
import MainNavigator from './MainNavigator';
import { linking } from './linking';
import SplashScreen from '@/features/auth/screens/SplashScreen';
import { navigationRef } from './NavigationService';

const Stack = createNativeStackNavigator();

const RootNavigator = () => {
  const { isAuthenticated, isLoading } = useSelector((state) => state.auth);

  if (isLoading) {
    return <SplashScreen />;
  }

  return (
    <NavigationContainer ref={navigationRef} linking={linking}>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <Stack.Screen name="Main" component={MainNavigator} />
        ) : (
          <Stack.Screen
            name="Auth"
            component={AuthNavigator}
            options={{ animationTypeForReplace: 'pop' }}
          />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default RootNavigator;
```

### Bottom Tab Navigator

```jsx
// navigation/MainNavigator.jsx
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Icon from 'react-native-vector-icons/Feather';
import HomeStack from './stacks/HomeStack';
import SearchStack from './stacks/SearchStack';
import NotificationsStack from './stacks/NotificationsStack';
import ProfileStack from './stacks/ProfileStack';
import { colors } from '@/theme';

const Tab = createBottomTabNavigator();

const MainNavigator = () => {
  const insets = useSafeAreaInsets();

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          paddingBottom: insets.bottom,
          height: 56 + insets.bottom,
        },
        tabBarActiveTintColor: colors.primary600,
        tabBarInactiveTintColor: colors.gray400,
        tabBarLabelStyle: { fontSize: 11, fontWeight: '600' },
      }}
    >
      <Tab.Screen
        name="HomeTab"
        component={HomeStack}
        options={{
          tabBarLabel: 'Home',
          tabBarIcon: ({ color, size }) => (
            <Icon name="home" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="SearchTab"
        component={SearchStack}
        options={{
          tabBarLabel: 'Search',
          tabBarIcon: ({ color, size }) => (
            <Icon name="search" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="NotificationsTab"
        component={NotificationsStack}
        options={{
          tabBarLabel: 'Alerts',
          tabBarIcon: ({ color, size }) => (
            <Icon name="bell" size={size} color={color} />
          ),
          tabBarBadge: 3,
        }}
      />
      <Tab.Screen
        name="ProfileTab"
        component={ProfileStack}
        options={{
          tabBarLabel: 'Profile',
          tabBarIcon: ({ color, size }) => (
            <Icon name="user" size={size} color={color} />
          ),
        }}
      />
    </Tab.Navigator>
  );
};

export default MainNavigator;
```

### Navigation Service (for navigating outside components)

```javascript
// navigation/NavigationService.js
import { createNavigationContainerRef } from '@react-navigation/native';

export const navigationRef = createNavigationContainerRef();

/**
 * Navigate from outside React components (push notifications, services).
 */
export const navigate = (name, params) => {
  if (navigationRef.isReady()) {
    navigationRef.navigate(name, params);
  }
};

/**
 * Go back from outside React components.
 */
export const goBack = () => {
  if (navigationRef.isReady() && navigationRef.canGoBack()) {
    navigationRef.goBack();
  }
};
```

### Deep Linking

```javascript
// navigation/linking.js
import { Linking } from 'react-native';
import messaging from '@react-native-firebase/messaging';

const prefix = 'breezeware://';

export const linking = {
  prefixes: [prefix, 'https://app.breezeware.com'],
  config: {
    screens: {
      Main: {
        screens: {
          HomeTab: {
            screens: {
              Details: 'details/:id',
            },
          },
          NotificationsTab: 'notifications',
          ProfileTab: {
            screens: {
              Profile: 'profile',
              Settings: 'settings',
            },
          },
        },
      },
      Auth: {
        screens: {
          Login: 'login',
          Register: 'register',
          ForgotPassword: 'forgot-password',
        },
      },
    },
  },
  async getInitialURL() {
    // Check if app was opened from a deep link
    const url = await Linking.getInitialURL();
    if (url != null) return url;

    // Check if app was opened from a push notification
    const initialNotification = await messaging().getInitialNotification();
    return initialNotification?.data?.url ?? null;
  },
  subscribe(listener) {
    const linkingSubscription = Linking.addEventListener('url', ({ url }) => {
      listener(url);
    });

    const unsubscribeNotification = messaging().onNotificationOpenedApp(
      (remoteMessage) => {
        const url = remoteMessage?.data?.url;
        if (url) listener(url);
      },
    );

    return () => {
      linkingSubscription.remove();
      unsubscribeNotification();
    };
  },
};
```

### Navigation Rules
1. **No TypeScript** — no `ParamList` types, but use JSDoc comments to document expected params
2. **Native stack** — use `createNativeStackNavigator` for performance
3. **Auth guard at root** — conditional rendering in `RootNavigator`, not per-screen
4. **Deep linking configured** — for every public screen
5. **Navigation ref** — for navigating outside React components (notifications, services)
6. **No navigation in components** — only in screens; pass callbacks down
7. **Screen options** — set `headerShown`, `title`, `gestureEnabled` per screen
8. **JSDoc on screen components** — document expected route params

---

## Screen Template (The 5 States)

Every screen that fetches data MUST handle all 5 states:

```jsx
// features/users/screens/UserListScreen.jsx
import React, { useCallback } from 'react';
import { View, FlatList, RefreshControl } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useNetworkStatus } from '@/hooks/useNetworkStatus';
import { userService } from '../services/userService';
import UserCard from '../components/UserCard';
import LoadingSkeleton from '@/components/common/LoadingSkeleton';
import ErrorState from '@/components/common/ErrorState';
import EmptyState from '@/components/common/EmptyState';
import OfflineBanner from '@/components/common/OfflineBanner';
import { styles } from './UserListScreen.styles';

/**
 * UserListScreen — displays paginated list of users with pull-to-refresh.
 *
 * @param {object} props
 * @param {object} props.navigation - React Navigation navigation prop
 */
const UserListScreen = ({ navigation }) => {
  const insets = useSafeAreaInsets();
  const isOnline = useNetworkStatus();

  const {
    data: users,
    isLoading,
    isError,
    error,
    refetch,
    isRefetching,
  } = useQuery({
    queryKey: ['users'],
    queryFn: userService.getUsers,
    staleTime: 5 * 60 * 1000,
    retry: 2,
  });

  const handleUserPress = useCallback(
    (id) => {
      navigation.navigate('UserDetail', { id });
    },
    [navigation],
  );

  const renderItem = useCallback(
    ({ item }) => <UserCard user={item} onPress={handleUserPress} />,
    [handleUserPress],
  );

  const keyExtractor = useCallback((item) => item.id, []);

  // 1. OFFLINE STATE
  if (!isOnline && !users) {
    return (
      <ErrorState
        icon="wifi-off"
        title="You're offline"
        message="Connect to the internet to view users"
        actionLabel="Retry"
        onAction={refetch}
      />
    );
  }

  // 2. LOADING STATE
  if (isLoading) {
    return (
      <View style={styles.container}>
        {Array.from({ length: 6 }).map((_, i) => (
          <LoadingSkeleton key={i} style={styles.skeleton} />
        ))}
      </View>
    );
  }

  // 3. ERROR STATE
  if (isError) {
    return (
      <ErrorState
        title="Something went wrong"
        message={error?.message || 'Failed to load users'}
        actionLabel="Try Again"
        onAction={refetch}
      />
    );
  }

  // 4. EMPTY STATE
  if (!users || users.length === 0) {
    return (
      <EmptyState
        icon="users"
        title="No users yet"
        message="Add your first team member to get started"
        actionLabel="Add User"
        onAction={() => navigation.navigate('CreateUser')}
      />
    );
  }

  // 5. SUCCESS STATE
  return (
    <View style={styles.container}>
      {!isOnline && <OfflineBanner />}
      <FlatList
        data={users}
        renderItem={renderItem}
        keyExtractor={keyExtractor}
        contentContainerStyle={{
          padding: 16,
          paddingBottom: insets.bottom + 16,
        }}
        ItemSeparatorComponent={() => <View style={styles.separator} />}
        refreshControl={
          <RefreshControl refreshing={isRefetching} onRefresh={refetch} />
        }
        showsVerticalScrollIndicator={false}
        removeClippedSubviews
        maxToRenderPerBatch={10}
        windowSize={5}
        initialNumToRender={10}
      />
    </View>
  );
};

export default UserListScreen;
```

---

## Responsive Design

### Responsive Sizing Utility

```javascript
// utils/responsive.js
import { Dimensions, PixelRatio, Platform } from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

// Base design dimensions (iPhone 14 Pro)
const BASE_WIDTH = 393;
const BASE_HEIGHT = 852;

/**
 * Scale a value based on screen width relative to design width.
 */
export const scale = (size) => {
  return (SCREEN_WIDTH / BASE_WIDTH) * size;
};

/**
 * Scale a value vertically based on screen height.
 */
export const verticalScale = (size) => {
  return (SCREEN_HEIGHT / BASE_HEIGHT) * size;
};

/**
 * Moderate scaling — less aggressive than linear scaling.
 *
 * @param {number} size - base size in points
 * @param {number} factor - 0 = no scaling, 1 = full scaling. Default 0.5.
 */
export const moderateScale = (size, factor = 0.5) => {
  return size + (scale(size) - size) * factor;
};

/**
 * Normalize font size across devices and platforms.
 */
export const normalizeFontSize = (size) => {
  const newSize = scale(size);
  return Math.round(PixelRatio.roundToNearestPixel(newSize));
};

/** Device type detection for layout decisions. */
export const isSmallDevice = SCREEN_WIDTH < 375;
export const isMediumDevice = SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414;
export const isLargeDevice = SCREEN_WIDTH >= 414;
export const isTablet = SCREEN_WIDTH >= 768;

/**
 * Safe hit slop for touch targets (minimum 44x44 per Apple HIG).
 */
export const minHitSlop = (elementSize) => {
  const minTarget = 44;
  const padding = Math.max(0, (minTarget - elementSize) / 2);
  return padding;
};
```

### Responsive Rules
1. **Never hardcode pixel values** for layout — use `scale()`, `moderateScale()`, or percentages
2. **Font sizes with `moderateScale()`** — prevents text from being too large on tablets
3. **Test on 5 device sizes**: iPhone SE (375), iPhone 15 (393), iPhone 15 Plus (430), iPad Mini (768), iPad Pro (1024)
4. **`useWindowDimensions`** — prefer over `Dimensions.get()` (auto-updates on rotation)
5. **Safe area insets** — always use `useSafeAreaInsets()` for top/bottom padding
6. **Minimum touch target 44x44** — Apple HIG and Android accessibility requirement
7. **Tablet layouts** — use multi-column when `width >= 768`
8. **Landscape support** — handle orientation changes if your app supports rotation
9. **Dynamic Type / Font Scaling** — respect user's accessibility font size settings
10. **Notch/island awareness** — never place interactive elements behind system UI

---

## Error Handling

### Error Boundary

```jsx
// components/common/ErrorBoundary/ErrorBoundary.jsx
import React, { Component } from 'react';
import { View, Text } from 'react-native';
import PropTypes from 'prop-types';
import * as Sentry from '@sentry/react-native';
import Button from '@/components/ui/Button';
import { styles } from './ErrorBoundary.styles';

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    Sentry.captureException(error, {
      extra: { componentStack: errorInfo.componentStack },
    });
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null });
    this.props.onReset?.();
  };

  render() {
    if (this.state.hasError) {
      return (
        this.props.fallback ?? (
          <View style={styles.container}>
            <Text style={styles.title}>Something went wrong</Text>
            <Text style={styles.message}>
              The app encountered an unexpected error. Please try again.
            </Text>
            <Button onPress={this.handleReset} label="Try Again" />
          </View>
        )
      );
    }
    return this.props.children;
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node.isRequired,
  fallback: PropTypes.node,
  onReset: PropTypes.func,
};

export default ErrorBoundary;
```

### Global Error Handler

```javascript
// lib/errorHandler.js
import * as Sentry from '@sentry/react-native';
import { Alert } from 'react-native';

/**
 * Initializes global error handlers for unhandled JS and native errors.
 */
export const initErrorHandler = () => {
  const originalHandler = global.ErrorUtils?.getGlobalHandler();

  global.ErrorUtils?.setGlobalHandler((error, isFatal) => {
    Sentry.captureException(error, {
      extra: { isFatal },
    });

    if (isFatal) {
      Alert.alert(
        'Unexpected Error',
        "The app needs to restart. We've been notified and are working on a fix.",
        [{ text: 'Restart', onPress: () => {} }],
      );
    }

    originalHandler?.(error, isFatal);
  });
};

/**
 * Wraps an async function with standardized error handling.
 *
 * @param {Function} fn - async function to wrap
 * @param {object} options
 * @param {*} options.fallback - value to return on error
 * @param {boolean} options.silent - if true, swallow the error
 * @param {string} options.context - context for Sentry
 */
export const withErrorHandling = (fn, options = {}) => {
  return fn().catch((error) => {
    Sentry.captureException(error, {
      extra: { context: options.context },
    });

    if (!options.silent) {
      throw error;
    }

    return options.fallback;
  });
};
```

### Axios with Token Refresh

```javascript
// lib/axios.js
import axios from 'axios';
import Keychain from 'react-native-keychain';
import NetInfo from '@react-native-community/netinfo';
import { store } from '@/app/store';
import { logout } from '@/features/auth/store/authSlice';
import { API_BASE_URL, REQUEST_TIMEOUT } from './constants';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: REQUEST_TIMEOUT,
  headers: { 'Content-Type': 'application/json' },
});

// Request interceptor — attach token + check connectivity
api.interceptors.request.use(
  async (config) => {
    const netState = await NetInfo.fetch();
    if (!netState.isConnected) {
      throw new Error('No internet connection');
    }

    const credentials = await Keychain.getGenericPassword({
      service: 'accessToken',
    });
    if (credentials) {
      config.headers.Authorization = `Bearer ${credentials.password}`;
    }
    return config;
  },
  (error) => Promise.reject(error),
);

// Response interceptor — handle auth errors + token refresh
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshCreds = await Keychain.getGenericPassword({
          service: 'refreshToken',
        });

        if (!refreshCreds) throw new Error('No refresh token');

        const { data } = await axios.post(`${API_BASE_URL}/auth/refresh`, {
          refreshToken: refreshCreds.password,
        });

        await Keychain.setGenericPassword('token', data.accessToken, {
          service: 'accessToken',
        });

        originalRequest.headers.Authorization = `Bearer ${data.accessToken}`;
        return api(originalRequest);
      } catch {
        await Keychain.resetGenericPassword({ service: 'accessToken' });
        await Keychain.resetGenericPassword({ service: 'refreshToken' });
        store.dispatch(logout());
        return Promise.reject(error);
      }
    }

    return Promise.reject(error);
  },
);

export default api;
```

### Error Handling Rules
1. **ErrorBoundary** wraps every navigation stack and major feature section
2. **Every screen handles 5 states**: offline, loading, error, empty, success
3. **Sentry for crash reporting** — capture all unhandled exceptions
4. **User-friendly error messages** — never show raw errors or stack traces
5. **Retry mechanism** — all error states have a "Try Again" button
6. **Offline-first mindset** — check network before API calls, show cached data when offline
7. **Token refresh** — transparent 401 → refresh → retry flow
8. **Global error handler** — catch unhandled promise rejections and fatal errors
9. **`Alert.alert()` for fatal errors only** — use inline error states for recoverable errors
10. **Log errors to Sentry with context** — include screen name, user action, and state

---

## State Management

### Redux Store Setup

```javascript
// app/store.js
import { configureStore, combineReducers } from '@reduxjs/toolkit';
import {
  persistStore,
  persistReducer,
  FLUSH,
  REHYDRATE,
  PAUSE,
  PERSIST,
  PURGE,
  REGISTER,
} from 'redux-persist';
import { MMKV } from 'react-native-mmkv';
import authReducer from '@/features/auth/store/authSlice';
import settingsReducer from '@/features/settings/store/settingsSlice';

// MMKV storage adapter for redux-persist
const mmkvStorage = new MMKV();
const reduxStorage = {
  setItem: (key, value) => {
    mmkvStorage.set(key, value);
    return Promise.resolve(true);
  },
  getItem: (key) => {
    const value = mmkvStorage.getString(key);
    return Promise.resolve(value ?? null);
  },
  removeItem: (key) => {
    mmkvStorage.delete(key);
    return Promise.resolve();
  },
};

const rootReducer = combineReducers({
  auth: authReducer,
  settings: settingsReducer,
});

const persistConfig = {
  key: 'root',
  storage: reduxStorage,
  whitelist: ['auth', 'settings'],
};

const persistedReducer = persistReducer(persistConfig, rootReducer);

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
});

export const persistor = persistStore(store);
```

### State Management Rules
1. **Redux Toolkit** for global app state (auth, settings, theme)
2. **TanStack Query** for server state (API data, caching, background refresh)
3. **MMKV** for fast local storage (non-sensitive preferences, cache)
4. **react-native-keychain** for sensitive data (tokens, PII — backed by Keychain/Keystore)
5. **redux-persist with MMKV adapter** — persist only what's needed
6. **Never store API data in Redux** — use TanStack Query for server state
7. **Local component state** for UI-only state (modals, form inputs, toggles)

---

## Form Patterns

```jsx
import React from 'react';
import {
  View,
  ScrollView,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import PropTypes from 'prop-types';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import FormInput from '@/components/forms/FormInput';
import Button from '@/components/ui/Button';

const createUserSchema = z.object({
  firstName: z.string().min(1, 'First name is required').max(100),
  lastName: z.string().min(1, 'Last name is required').max(100),
  email: z.string().email('Please enter a valid email'),
  phone: z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number'),
});

/**
 * CreateUserForm — form to create a new user with validation.
 */
const CreateUserForm = ({ onSubmit, isLoading }) => {
  const insets = useSafeAreaInsets();
  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm({
    resolver: zodResolver(createUserSchema),
    defaultValues: { firstName: '', lastName: '', email: '', phone: '' },
  });

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1 }}
    >
      <ScrollView
        style={{ flex: 1, backgroundColor: '#fff', paddingHorizontal: 16 }}
        contentContainerStyle={{ paddingBottom: insets.bottom + 16 }}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        <Controller
          control={control}
          name="firstName"
          render={({ field: { onChange, onBlur, value } }) => (
            <FormInput
              label="First Name"
              placeholder="Enter first name"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.firstName?.message}
              autoCapitalize="words"
              textContentType="givenName"
              returnKeyType="next"
            />
          )}
        />

        <Controller
          control={control}
          name="email"
          render={({ field: { onChange, onBlur, value } }) => (
            <FormInput
              label="Email"
              placeholder="name@breezeware.com"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.email?.message}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
              textContentType="emailAddress"
              returnKeyType="next"
            />
          )}
        />

        <Controller
          control={control}
          name="phone"
          render={({ field: { onChange, onBlur, value } }) => (
            <FormInput
              label="Phone"
              placeholder="+1 (555) 000-0000"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.phone?.message}
              keyboardType="phone-pad"
              textContentType="telephoneNumber"
              returnKeyType="done"
            />
          )}
        />

        <Button
          onPress={handleSubmit(onSubmit)}
          label={isLoading ? 'Creating...' : 'Create User'}
          isLoading={isLoading}
          disabled={isLoading}
          style={{ marginTop: 24 }}
        />
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

CreateUserForm.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
};

export default CreateUserForm;
```

### Form Rules
1. **React Hook Form + Zod** — always, never manual form state
2. **`Controller` wrapper** — for all controlled inputs
3. **`KeyboardAvoidingView`** — wraps every form (`padding` on iOS, `height` on Android)
4. **`keyboardShouldPersistTaps="handled"`** — on ScrollView
5. **`textContentType`** (iOS) and `autoComplete` (Android) — for autofill
6. **`returnKeyType`** — "next" for intermediate fields, "done" for last field
7. **Error messages below inputs** — red text, visible on blur/submit
8. **Loading state on submit** — spinner + disabled + text change
9. **Prevent double submission** — disable button during API call

---

## Performance Optimization

### FlatList Best Practices

```jsx
<FlatList
  data={items}
  renderItem={renderItem}             // Always useCallback
  keyExtractor={keyExtractor}          // Always useCallback, stable keys
  removeClippedSubviews               // Unmount offscreen items
  maxToRenderPerBatch={10}            // Render 10 items per batch
  windowSize={5}                       // Render 5 screens of content
  initialNumToRender={10}             // Render 10 items initially
  updateCellsBatchingPeriod={50}      // Batch updates every 50ms
  getItemLayout={getItemLayout}        // If items have fixed height
  ListHeaderComponent={header}         // Avoid re-creating inline
  ListFooterComponent={footer}
  ListEmptyComponent={emptyState}
  onEndReached={loadMore}
  onEndReachedThreshold={0.5}
/>
```

### Performance Rules
1. **`useCallback`** — for ALL functions passed as props (especially `renderItem`, `keyExtractor`)
2. **`useMemo`** — for expensive computations and derived data
3. **`React.memo()`** — on list item components and complex child components
4. **FlatList over ScrollView** — for ANY list longer than ~20 items
5. **`getItemLayout`** — provide when items have fixed/predictable height
6. **`removeClippedSubviews`** — enable on long lists (unmounts offscreen items)
7. **Avoid anonymous functions in JSX** — extract to `useCallback`
8. **`react-native-fast-image`** — instead of `Image` for network images (caching + priority)
9. **Reanimated for animations** — never use `Animated` API for complex animations
10. **Hermes enabled** — verify Hermes is the JS engine (faster startup + less memory)
11. **Avoid `console.log` in production** — use `babel-plugin-transform-remove-console`
12. **`InteractionManager.runAfterInteractions`** — defer heavy work after animations
13. **`StyleSheet.create()`** — always, for static validation and flattening optimization

---

## Security

### Secure Storage

```javascript
// lib/storage.js
import Keychain from 'react-native-keychain';
import { MMKV } from 'react-native-mmkv';

const mmkv = new MMKV();

/**
 * Secure storage for sensitive data (tokens, credentials, PII).
 * Uses iOS Keychain / Android Keystore under the hood.
 */
export const secureStorage = {
  async get(key) {
    const credentials = await Keychain.getGenericPassword({ service: key });
    return credentials ? credentials.password : null;
  },
  async set(key, value) {
    await Keychain.setGenericPassword(key, value, { service: key });
  },
  async remove(key) {
    await Keychain.resetGenericPassword({ service: key });
  },
};

/**
 * Fast storage for non-sensitive data (preferences, cache, UI state).
 * Uses MMKV (10x faster than AsyncStorage).
 */
export const fastStorage = {
  getString: (key) => mmkv.getString(key) ?? null,
  setString: (key, value) => mmkv.set(key, value),
  getBoolean: (key) => mmkv.getBoolean(key) ?? false,
  setBoolean: (key, value) => mmkv.set(key, value),
  getNumber: (key) => mmkv.getNumber(key) ?? 0,
  setNumber: (key, value) => mmkv.set(key, value),
  remove: (key) => mmkv.delete(key),
  clearAll: () => mmkv.clearAll(),
};
```

### Security Rules
1. **react-native-keychain** — for tokens, credentials, PII (backed by Keychain/Keystore)
2. **NEVER use AsyncStorage** for sensitive data — it's unencrypted plain text
3. **MMKV** — for non-sensitive preferences (fast, synchronous)
4. **Certificate pinning** — via `react-native-ssl-pinning` for production API
5. **No secrets in JS bundle** — all secrets via native config or backend
6. **Biometric authentication** — via `react-native-biometrics` for sensitive operations
7. **Screen capture prevention** — `react-native-prevent-screenshot` on sensitive screens
8. **HTTPS only** — no HTTP exceptions in production
9. **Root/jailbreak detection** — via `jail-monkey` or `react-native-device-info`
10. **Auto-logout** — on app background after configurable timeout
11. **ProGuard enabled** (Android) — for code obfuscation in release builds
12. **Deep link validation** — validate all incoming deep link parameters

---

## Accessibility

### Accessibility Checklist
- [ ] All interactive elements have `accessibilityRole` (`button`, `link`, `header`, etc.)
- [ ] Elements without visible text have `accessibilityLabel`
- [ ] Touch targets are minimum 44x44 points (use `hitSlop` to expand)
- [ ] Color contrast ratio ≥ 4.5:1 for normal text
- [ ] Dynamic Type supported — respect user's font size settings
- [ ] Screen reader navigation logical (test VoiceOver + TalkBack)
- [ ] `accessibilityHint` for non-obvious actions
- [ ] `accessibilityState` for toggles, checkboxes, disabled states
- [ ] Images have `accessibilityIgnoresInvertColors` where appropriate
- [ ] Focus management — move focus to modals, alerts
- [ ] No text in images — all text is `Text` component
- [ ] `accessibilityRole="alert"` on error messages and banners

---

## Platform-Specific Code

```javascript
// Use Platform.select for small differences
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  shadow: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
    },
    android: {
      elevation: 4,
    },
  }),
});

// Use .ios.js / .android.js for large differences
// components/BiometricPrompt/
// ├── BiometricPrompt.ios.js      # Face ID specific
// ├── BiometricPrompt.android.js  # Fingerprint specific
// └── index.js                     # Re-export
```

### Platform Rules
1. **`Platform.select()`** — for small style differences (shadows, fonts)
2. **`.ios.js` / `.android.js`** — for fundamentally different implementations
3. **Test on both platforms** — always, even for "simple" changes
4. **Safe area handling** — different on iOS (notch/island) vs Android (status bar)
5. **Back button** — handle Android hardware back button with `useBackHandler`
6. **Keyboard behavior** — `behavior="padding"` on iOS, `behavior="height"` on Android
7. **Status bar** — configure per screen with `<StatusBar>`
8. **Permissions** — use `react-native-permissions` with platform-appropriate messaging

---

## Native Module Integration

```javascript
// For bare React Native, native modules are linked directly

// Android: android/app/build.gradle
// iOS: pod install in ios/ directory

// Common native dependencies for bare RN:
// react-native-keychain          — secure storage
// react-native-mmkv              — fast key-value storage
// react-native-fast-image        — image caching
// react-native-vector-icons      — icon library
// react-native-reanimated        — animations
// react-native-gesture-handler   — gestures
// react-native-safe-area-context — safe area insets
// react-native-screens           — native screen containers
// @react-native-community/netinfo — network status
// react-native-biometrics        — biometric auth
// react-native-permissions       — permissions
// @react-native-firebase/app     — Firebase core
// @react-native-firebase/messaging — push notifications
// @sentry/react-native           — crash reporting
// react-native-splash-screen     — splash screen
// react-native-device-info       — device info + jailbreak detection
```

---

## Naming Conventions

| Element               | Convention              | Example                          |
|-----------------------|-------------------------|----------------------------------|
| Component files       | PascalCase.jsx          | `UserCard.jsx`                   |
| Component names       | PascalCase              | `UserCard`                       |
| Screen files          | PascalCase + Screen     | `UserListScreen.jsx`             |
| Style files           | PascalCase.styles.js    | `UserCard.styles.js`             |
| Hooks                 | camelCase, `use` prefix | `useAuth.js`                     |
| Utility functions     | camelCase               | `formatDate.js`                  |
| Constants             | UPPER_SNAKE_CASE        | `MAX_RETRY_COUNT`                |
| Service files         | camelCase + Service     | `userService.js`                 |
| Redux slices          | camelCase + Slice       | `authSlice.js`                   |
| Test files            | PascalCase.test.jsx     | `UserCard.test.jsx`              |
| Event handlers        | `handle` prefix         | `handlePress`, `handleSubmit`    |
| Boolean props         | `is`/`has` prefix       | `isLoading`, `hasError`          |
| Callback props        | `on` prefix             | `onPress`, `onChange`            |
| Navigation screens    | Name + Screen           | `LoginScreen`, `HomeScreen`      |
| Platform files        | Name.ios.js / .android.js | `BiometricPrompt.ios.js`       |

---

## Testing

### Unit Test Template

```jsx
// components/ui/Button/Button.test.jsx
import React from 'react';
import { render, fireEvent, screen } from '@testing-library/react-native';
import Button from './Button';

describe('Button', () => {
  it('renders label correctly', () => {
    render(<Button label="Submit" onPress={jest.fn()} />);
    expect(screen.getByText('Submit')).toBeTruthy();
  });

  it('calls onPress when pressed', () => {
    const onPress = jest.fn();
    render(<Button label="Submit" onPress={onPress} />);
    fireEvent.press(screen.getByText('Submit'));
    expect(onPress).toHaveBeenCalledTimes(1);
  });

  it('does not call onPress when disabled', () => {
    const onPress = jest.fn();
    render(<Button label="Submit" onPress={onPress} disabled />);
    fireEvent.press(screen.getByText('Submit'));
    expect(onPress).not.toHaveBeenCalled();
  });

  it('shows loading indicator when isLoading', () => {
    render(<Button label="Submit" onPress={jest.fn()} isLoading />);
    expect(screen.getByTestId('loading-indicator')).toBeTruthy();
  });

  it('has correct accessibility role', () => {
    render(<Button label="Submit" onPress={jest.fn()} />);
    expect(screen.getByRole('button')).toBeTruthy();
  });
});
```

### Testing Rules
1. **React Native Testing Library** — for component tests
2. **Jest** — test runner with React Native preset
3. **Detox** — for E2E tests on real devices/simulators
4. **Co-located tests** — `Component.test.jsx` next to `Component.jsx`
5. **Test behavior, not implementation** — query by role, text, testID
6. **Test all 5 states** — offline, loading, error, empty, success
7. **Mock native modules** — in `jest.setup.js`
8. **Snapshot tests sparingly** — only for stable, presentational components
9. **80% branch coverage** minimum for new code

For more detailed reference, read `references/component-patterns.md`.
