# React Native Component Patterns & Recipes Reference

## App Root with All Providers

```jsx
// app/App.jsx
import React, { useEffect } from 'react';
import { StatusBar } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/integration/react';
import { QueryClientProvider } from '@tanstack/react-query';
import SplashScreen from 'react-native-splash-screen';
import { store, persistor } from './store';
import { queryClient } from './queryClient';
import RootNavigator from '@/navigation/RootNavigator';
import ErrorBoundary from '@/components/common/ErrorBoundary';
import { initErrorHandler } from '@/lib/errorHandler';
import { initNotifications } from '@/lib/notifications';

const App = () => {
  useEffect(() => {
    initErrorHandler();
    initNotifications();
    SplashScreen.hide();
  }, []);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <Provider store={store}>
          <PersistGate loading={null} persistor={persistor}>
            <QueryClientProvider client={queryClient}>
              <ErrorBoundary>
                <StatusBar barStyle="dark-content" />
                <RootNavigator />
              </ErrorBoundary>
            </QueryClientProvider>
          </PersistGate>
        </Provider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
};

export default App;
```

## TanStack Query Client Configuration

```javascript
// app/queryClient.js
import { QueryClient } from '@tanstack/react-query';
import NetInfo from '@react-native-community/netinfo';
import { onlineManager } from '@tanstack/react-query';

// Auto-manage online status
onlineManager.setEventListener((setOnline) => {
  return NetInfo.addEventListener((state) => {
    setOnline(!!state.isConnected);
  });
});

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,        // 5 minutes
      gcTime: 30 * 60 * 1000,           // 30 minutes
      retry: 2,
      retryDelay: (attempt) => Math.min(1000 * 2 ** attempt, 30000),
      refetchOnWindowFocus: false,       // Not relevant for mobile
      refetchOnReconnect: true,          // Refetch when back online
    },
    mutations: {
      retry: 1,
    },
  },
});
```

## Custom Hooks

### useNetworkStatus

```javascript
// hooks/useNetworkStatus.js
import { useState, useEffect } from 'react';
import NetInfo from '@react-native-community/netinfo';

const useNetworkStatus = () => {
  const [isConnected, setIsConnected] = useState(true);

  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener((state) => {
      setIsConnected(state.isConnected ?? true);
    });

    return () => unsubscribe();
  }, []);

  return isConnected;
};

export default useNetworkStatus;
```

### useAppState

```javascript
// hooks/useAppState.js
import { useEffect, useRef, useState } from 'react';
import { AppState } from 'react-native';

const useAppState = () => {
  const appState = useRef(AppState.currentState);
  const [currentState, setCurrentState] = useState(appState.current);

  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextState) => {
      appState.current = nextState;
      setCurrentState(nextState);
    });

    return () => subscription.remove();
  }, []);

  return currentState;
};

export default useAppState;
```

### useBackHandler

```javascript
// hooks/useBackHandler.js
import { useEffect } from 'react';
import { BackHandler } from 'react-native';

/**
 * Handle Android hardware back button.
 *
 * @param {Function} handler - return true to prevent default back behavior
 */
const useBackHandler = (handler) => {
  useEffect(() => {
    const subscription = BackHandler.addEventListener(
      'hardwareBackPress',
      handler,
    );

    return () => subscription.remove();
  }, [handler]);
};

export default useBackHandler;
```

### useKeyboard

```javascript
// hooks/useKeyboard.js
import { useState, useEffect } from 'react';
import { Keyboard, Platform } from 'react-native';

const useKeyboard = () => {
  const [keyboard, setKeyboard] = useState({
    isVisible: false,
    height: 0,
  });

  useEffect(() => {
    const showEvent =
      Platform.OS === 'ios' ? 'keyboardWillShow' : 'keyboardDidShow';
    const hideEvent =
      Platform.OS === 'ios' ? 'keyboardWillHide' : 'keyboardDidHide';

    const showSub = Keyboard.addListener(showEvent, (e) => {
      setKeyboard({ isVisible: true, height: e.endCoordinates.height });
    });

    const hideSub = Keyboard.addListener(hideEvent, () => {
      setKeyboard({ isVisible: false, height: 0 });
    });

    return () => {
      showSub.remove();
      hideSub.remove();
    };
  }, []);

  return keyboard;
};

export default useKeyboard;
```

### useRefreshOnFocus

```javascript
// hooks/useRefreshOnFocus.js
import { useCallback } from 'react';
import { useFocusEffect } from '@react-navigation/native';

/**
 * Refetch data when screen comes into focus.
 *
 * @param {Function} refetch - the refetch function from useQuery
 */
const useRefreshOnFocus = (refetch) => {
  useFocusEffect(
    useCallback(() => {
      refetch();
    }, [refetch]),
  );
};

export default useRefreshOnFocus;
```

### useDebounce

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

## Reusable UI Components

### Button Component

```jsx
// components/ui/Button/Button.jsx
import React from 'react';
import { Pressable, Text, ActivityIndicator } from 'react-native';
import PropTypes from 'prop-types';
import { styles, getVariantStyle, getTextStyle, getSizeStyle } from './Button.styles';

/**
 * Button — primary UI button with variants, sizes, and loading state.
 */
const Button = ({
  label,
  onPress,
  variant = 'primary',
  size = 'md',
  isLoading = false,
  disabled = false,
  icon,
  style,
}) => {
  const isDisabled = disabled || isLoading;

  return (
    <Pressable
      onPress={onPress}
      disabled={isDisabled}
      accessibilityRole="button"
      accessibilityLabel={label}
      accessibilityState={{ disabled: isDisabled, busy: isLoading }}
      style={({ pressed }) => [
        styles.base,
        getVariantStyle(variant),
        getSizeStyle(size),
        isDisabled && styles.disabled,
        pressed && styles.pressed,
        style,
      ]}
    >
      {isLoading ? (
        <ActivityIndicator
          testID="loading-indicator"
          color={variant === 'primary' || variant === 'destructive' ? '#fff' : '#1F2937'}
          size="small"
          style={styles.loader}
        />
      ) : icon ? (
        icon
      ) : null}
      <Text style={[styles.label, getTextStyle(variant, size)]}>
        {label}
      </Text>
    </Pressable>
  );
};

Button.propTypes = {
  label: PropTypes.string.isRequired,
  onPress: PropTypes.func.isRequired,
  variant: PropTypes.oneOf(['primary', 'secondary', 'destructive', 'ghost', 'outline']),
  size: PropTypes.oneOf(['sm', 'md', 'lg']),
  isLoading: PropTypes.bool,
  disabled: PropTypes.bool,
  icon: PropTypes.node,
  style: PropTypes.oneOfType([PropTypes.object, PropTypes.array]),
};

export default Button;
```

```javascript
// components/ui/Button/Button.styles.js
import { StyleSheet } from 'react-native';
import { colors, spacing, typography } from '@/theme';

export const styles = StyleSheet.create({
  base: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
  },
  disabled: {
    opacity: 0.5,
  },
  pressed: {
    opacity: 0.85,
  },
  loader: {
    marginRight: spacing.sm,
  },
  label: {
    ...typography.button,
  },
});

const variantStyles = {
  primary: { backgroundColor: colors.primary600 },
  secondary: { backgroundColor: colors.gray100 },
  destructive: { backgroundColor: colors.error },
  ghost: { backgroundColor: 'transparent' },
  outline: {
    backgroundColor: 'transparent',
    borderWidth: 1,
    borderColor: colors.gray300,
  },
};

const textVariantColors = {
  primary: colors.white,
  secondary: colors.gray900,
  destructive: colors.white,
  ghost: colors.primary600,
  outline: colors.gray900,
};

const sizeStyles = {
  sm: { minHeight: 36, paddingHorizontal: spacing.md },
  md: { minHeight: 44, paddingHorizontal: spacing.lg },
  lg: { minHeight: 52, paddingHorizontal: spacing.xl },
};

const textSizes = {
  sm: { fontSize: 12 },
  md: { fontSize: 14 },
  lg: { fontSize: 16 },
};

export const getVariantStyle = (variant) => variantStyles[variant];
export const getSizeStyle = (size) => sizeStyles[size];
export const getTextStyle = (variant, size) => ({
  color: textVariantColors[variant],
  ...textSizes[size],
});
```

### FormInput Component

```jsx
// components/forms/FormInput/FormInput.jsx
import React, { forwardRef } from 'react';
import { View, Text, TextInput } from 'react-native';
import PropTypes from 'prop-types';
import { styles } from './FormInput.styles';

/**
 * FormInput — labeled text input with error and hint support.
 */
const FormInput = forwardRef(
  ({ label, error, hint, style, ...props }, ref) => {
    return (
      <View style={[styles.container, style]}>
        <Text style={styles.label}>{label}</Text>
        <TextInput
          ref={ref}
          style={[styles.input, error && styles.inputError]}
          placeholderTextColor="#9CA3AF"
          accessibilityLabel={label}
          accessibilityState={{ disabled: props.editable === false }}
          {...props}
        />
        {error && (
          <Text style={styles.error} accessibilityRole="alert">
            {error}
          </Text>
        )}
        {hint && !error && <Text style={styles.hint}>{hint}</Text>}
      </View>
    );
  },
);

FormInput.displayName = 'FormInput';

FormInput.propTypes = {
  label: PropTypes.string.isRequired,
  error: PropTypes.string,
  hint: PropTypes.string,
  style: PropTypes.oneOfType([PropTypes.object, PropTypes.array]),
  editable: PropTypes.bool,
};

export default FormInput;
```

```javascript
// components/forms/FormInput/FormInput.styles.js
import { StyleSheet } from 'react-native';
import { colors, spacing, typography } from '@/theme';

export const styles = StyleSheet.create({
  container: {
    marginBottom: spacing.lg,
  },
  label: {
    ...typography.label,
    color: colors.gray700,
    marginBottom: spacing.xs,
  },
  input: {
    ...typography.body,
    color: colors.gray900,
    borderWidth: 1,
    borderColor: colors.gray300,
    borderRadius: 12,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    backgroundColor: colors.white,
  },
  inputError: {
    borderColor: colors.error,
    backgroundColor: '#FEF2F2',
  },
  error: {
    ...typography.caption,
    color: colors.error,
    marginTop: spacing.xxs,
  },
  hint: {
    ...typography.caption,
    color: colors.gray500,
    marginTop: spacing.xxs,
  },
});
```

### EmptyState Component

```jsx
// components/common/EmptyState/EmptyState.jsx
import React from 'react';
import { View, Text } from 'react-native';
import PropTypes from 'prop-types';
import Icon from 'react-native-vector-icons/Feather';
import Button from '@/components/ui/Button';
import { styles } from './EmptyState.styles';

/**
 * EmptyState — shown when a list or section has no data.
 */
const EmptyState = ({ icon, title, message, actionLabel, onAction }) => {
  return (
    <View style={styles.container}>
      <Icon name={icon} size={48} color="#D1D5DB" />
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.message}>{message}</Text>
      {actionLabel && onAction && (
        <Button
          label={actionLabel}
          onPress={onAction}
          variant="primary"
          style={styles.button}
        />
      )}
    </View>
  );
};

EmptyState.propTypes = {
  icon: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  message: PropTypes.string.isRequired,
  actionLabel: PropTypes.string,
  onAction: PropTypes.func,
};

export default EmptyState;
```

### ErrorState Component

```jsx
// components/common/ErrorState/ErrorState.jsx
import React from 'react';
import { View, Text } from 'react-native';
import PropTypes from 'prop-types';
import Icon from 'react-native-vector-icons/Feather';
import Button from '@/components/ui/Button';
import { styles } from './ErrorState.styles';

/**
 * ErrorState — shown when data fetching fails.
 */
const ErrorState = ({
  icon = 'alert-circle',
  title,
  message,
  actionLabel = 'Try Again',
  onAction,
}) => {
  return (
    <View style={styles.container}>
      <Icon name={icon} size={48} color="#EF4444" />
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.message}>{message}</Text>
      {onAction && (
        <Button
          label={actionLabel}
          onPress={onAction}
          variant="outline"
          style={styles.button}
        />
      )}
    </View>
  );
};

ErrorState.propTypes = {
  icon: PropTypes.string,
  title: PropTypes.string.isRequired,
  message: PropTypes.string.isRequired,
  actionLabel: PropTypes.string,
  onAction: PropTypes.func,
};

export default ErrorState;
```

### OfflineBanner Component

```jsx
// components/common/OfflineBanner/OfflineBanner.jsx
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Animated, { SlideInUp, SlideOutUp } from 'react-native-reanimated';
import Icon from 'react-native-vector-icons/Feather';
import { colors, typography, spacing } from '@/theme';

/**
 * OfflineBanner — animated banner shown when device is offline.
 */
const OfflineBanner = () => {
  const insets = useSafeAreaInsets();

  return (
    <Animated.View
      entering={SlideInUp}
      exiting={SlideOutUp}
      style={[styles.container, { paddingTop: insets.top + spacing.sm }]}
      accessibilityRole="alert"
      accessibilityLabel="You are offline. Some features may not work."
    >
      <Icon name="wifi-off" size={14} color="#fff" />
      <Text style={styles.text}>No internet connection</Text>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.sm,
    backgroundColor: colors.error,
    paddingVertical: spacing.sm,
  },
  text: {
    ...typography.caption,
    fontWeight: '500',
    color: colors.white,
  },
});

export default OfflineBanner;
```

## Push Notification Setup (Firebase)

```javascript
// lib/notifications.js
import messaging from '@react-native-firebase/messaging';
import PushNotification from 'react-native-push-notification';
import { Platform } from 'react-native';
import { navigate } from '@/navigation/NavigationService';
import api from './axios';

/**
 * Initialize push notification handlers and register token.
 */
export const initNotifications = async () => {
  // Request permission (iOS only — Android grants by default < API 33)
  const authStatus = await messaging().requestPermission();
  const enabled =
    authStatus === messaging.AuthorizationStatus.AUTHORIZED ||
    authStatus === messaging.AuthorizationStatus.PROVISIONAL;

  if (!enabled) return;

  // Get FCM token
  const token = await messaging().getToken();

  // Register token with backend
  await api.post('/devices', { pushToken: token, platform: Platform.OS });

  // Token refresh
  messaging().onTokenRefresh(async (newToken) => {
    await api.post('/devices', { pushToken: newToken, platform: Platform.OS });
  });

  // Android notification channel
  if (Platform.OS === 'android') {
    PushNotification.createChannel(
      {
        channelId: 'default',
        channelName: 'Default',
        importance: 4, // HIGH
        vibrate: true,
      },
      () => {},
    );
  }

  // Foreground notification handler
  messaging().onMessage(async (remoteMessage) => {
    PushNotification.localNotification({
      channelId: 'default',
      title: remoteMessage.notification?.title,
      message: remoteMessage.notification?.body || '',
      userInfo: remoteMessage.data,
    });
  });

  // Background/quit notification tap handler
  messaging().onNotificationOpenedApp((remoteMessage) => {
    const screen = remoteMessage?.data?.screen;
    if (screen) {
      navigate(screen, remoteMessage.data?.params);
    }
  });

  // App opened from killed state via notification
  const initialNotification = await messaging().getInitialNotification();
  if (initialNotification?.data?.screen) {
    // Delay to ensure navigation is ready
    setTimeout(() => {
      navigate(initialNotification.data.screen, initialNotification.data.params);
    }, 1000);
  }
};
```

## Biometric Authentication

```javascript
// features/auth/hooks/useBiometric.js
import { useState, useEffect, useCallback } from 'react';
import ReactNativeBiometrics from 'react-native-biometrics';

const rnBiometrics = new ReactNativeBiometrics();

/**
 * Hook for biometric authentication (Face ID / Touch ID / Fingerprint).
 */
const useBiometric = () => {
  const [isAvailable, setIsAvailable] = useState(false);
  const [biometricType, setBiometricType] = useState(null);

  useEffect(() => {
    checkAvailability();
  }, []);

  const checkAvailability = async () => {
    const { available, biometryType } = await rnBiometrics.isSensorAvailable();
    setIsAvailable(available);

    if (biometryType === ReactNativeBiometrics.TouchID) {
      setBiometricType('fingerprint');
    } else if (biometryType === ReactNativeBiometrics.FaceID) {
      setBiometricType('facial');
    } else if (biometryType === ReactNativeBiometrics.Biometrics) {
      setBiometricType('fingerprint');
    }
  };

  const authenticate = useCallback(async () => {
    const { success } = await rnBiometrics.simplePrompt({
      promptMessage: 'Verify your identity',
      cancelButtonText: 'Cancel',
    });
    return success;
  }, []);

  return { isAvailable, biometricType, authenticate };
};

export default useBiometric;
```

## Environment Configuration

```javascript
// lib/constants.js
import Config from 'react-native-config';

export const API_BASE_URL =
  Config.API_BASE_URL || 'http://localhost:8080/api/v1';
export const REQUEST_TIMEOUT = 15000;
export const MAX_RETRY_COUNT = 3;
export const STALE_TIME = 5 * 60 * 1000;   // 5 minutes
export const CACHE_TIME = 30 * 60 * 1000;  // 30 minutes
export const DEBOUNCE_DELAY = 300;
export const PAGE_SIZE = 20;
```

```bash
# .env.development
API_BASE_URL=http://localhost:8080/api/v1
SENTRY_DSN=https://xxx@sentry.io/xxx
APP_NAME=Breezeware Dev

# .env.staging
API_BASE_URL=https://staging-api.breezeware.com/api/v1
SENTRY_DSN=https://xxx@sentry.io/xxx
APP_NAME=Breezeware Staging

# .env.production
API_BASE_URL=https://api.breezeware.com/api/v1
SENTRY_DSN=https://xxx@sentry.io/xxx
APP_NAME=Breezeware
```

Rules:
- Use `react-native-config` for environment variables
- NEVER bundle secrets in the JS bundle — they can be extracted
- Separate `.env.development`, `.env.staging`, `.env.production`
- Access via `Config.VARIABLE_NAME`
- Add `.env*` to `.gitignore`, commit `.env.example`
