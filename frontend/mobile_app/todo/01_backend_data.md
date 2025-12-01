# TODO - Backend & Data

Scope: replace mock data with real APIs, keep clean architecture boundaries, and harden session handling.

## Dashboard integration
- [x] Swap mock fetch in `lib/data/home/datasources/home_remote_data_source.dart` to `ApiClient.get('/api/v1/dashboard')`; map `DioException` to `NetworkException` and bubble domain-friendly errors.
- [x] Update `lib/data/home/repositories/home_repository_impl.dart` to remove `HomeMockData`, return `HomeDashboard` from remote, and use mappers for all fields; add offline cache fallback.
- [x] Ensure `lib/presentation/providers/home_provider.dart` loads via the use case only and surfaces loading/error/empty states; add refresh support that reuses the same use case.

## DTO + domain mapping
- [x] Add explicit DTO-to-entity converters for dashboard models (pulse, insight, routine, article, product) with null/default safety.
- [x] Audit auth/profile/analysis modules to ensure remote models are isolated from domain entities (auth datasource mapping/validation added).
- [x] Keep naming camelCase/PascalCase per Dart conventions; avoid `any` and keep types explicit.

## Token and session flow
- [x] Add a refresh-fail path that forces logout/clear secure storage and notifies `AuthSessionObserver` (in `ApiClient` 401 flow).
- [x] Guard concurrent refresh attempts (single flight) and queue pending requests until refresh completes.
- [x] Verify `flutter_secure_storage` usage for access/refresh tokens; centralize keys and lifetimes in one place with encryption wrapper.

## Environment and config
- [x] Confirm base URLs/timeouts/SSL flags come from `lib/config/environment.dart` per env (dev/staging/prod) and are consumed by `ApiClient`/`network_config.dart`.
- [x] Add build-time `--dart-define` wiring for `APP_ENV` if missing; document values in README.

## Error handling and logging
- [x] Replace `print`/debug logs in data layer with `AppLogger` at proper levels; strip sensitive fields (email/password/tokens/URLs).
- [x] Ensure `GlobalErrorNotifier` receives domain exceptions only; convert lower-layer errors before surfacing to presentation.
