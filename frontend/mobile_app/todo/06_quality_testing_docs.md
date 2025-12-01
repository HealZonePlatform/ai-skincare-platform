# TODO - Quality, Testing, Docs

Scope: build test coverage, automate checks, and close documentation gaps.

## Tests
- [ ] Create/validate `test/` structure (domain/data/presentation/core) and add unit tests for providers (auth, home, theme, onboarding, user_profile).
- [ ] Add use case tests (login/register/logout, get_home_dashboard, update_profile) and repository tests (auth, home, profile).
- [ ] Add widget tests for UI kit components (pulse card, insight cards, hero header, buttons) and screen smoke tests where practical.
- [ ] Fill `integration_test/` with critical flows (login → home → scan happy path) and set coverage target ≥70%.

## CI/CD
- [ ] Add GitHub Actions workflow: checkout → flutter pub get → analyze → test → build apk artifact; publish coverage if available.
- [ ] Keep secrets/env out of the pipeline; document required `dart-define` and cache strategy.

## Analytics and crash reporting
- [ ] Define analytics event catalog (auth, scan, engagement, errors) and ensure `AnalyticsService` logs consistently.
- [ ] Integrate crash reporting (Sentry or Crashlytics) and hook `FlutterError.onError` and `Zone` error handling.

## Documentation and hygiene
- [ ] Write `API.md` with base URLs, endpoints, request/response samples, and error codes aligned with backend.
- [ ] Add `COMPONENTS.md` to document UI kit usage, props, and do/dont with screenshots later.
- [ ] Expand README with local setup (backend, env vars, iOS run), troubleshooting, and demo account notes.
- [ ] Audit `TODO` comments across the codebase; create issues or resolve, and remove stale items.
- [ ] Audit `pubspec.yaml` for unused deps (e.g., encrypt, permission_handler) and document why kept ones are required.
