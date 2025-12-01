# TODO - Security, Offline, Notifications

Scope: tighten auth data handling, add offline resilience, and deliver notifications.

## Secure storage and sessions
- [x] Add an encryption layer around `flutter_secure_storage` for tokens (e.g., `SecureTokenStorage`), centralize key names, and document rotation.
- [x] Enforce session timeout/logout on refresh failure; clear secure storage and notify providers.
- [x] Remove/replace any `print` with `AppLogger` and scrub sensitive data from logs.

## Offline support
- [x] Introduce connectivity service to detect online/offline state.
- [x] Add local caches for dashboard/profile/history (e.g., `HomeLocalCache`, `ProfileLocalCache`) and serve cached data when offline. *(dashboard cache added, profile cache existing)*
- [x] Show an offline indicator banner/toast and queue retry for pending actions where feasible.
- [x] Handle “no cached data” gracefully with empty states and retry CTA.

## Notifications
- [x] Implement `LocalNotificationService`/FCM setup (pubspec deps: `firebase_messaging`, `flutter_local_notifications`), request permissions, and register device token.
- [x] Add scheduling helper for routine reminders and wire with settings screen toggle.
- [x] Handle foreground/background taps and navigation to the correct route.
