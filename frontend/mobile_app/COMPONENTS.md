# UI Components (frontend/mobile_app)

This app uses a lightweight UI kit under `lib/presentation/widgets` and `lib/presentation/screens/home/widgets`. Below are the most common pieces and how to use them safely.

## Buttons
- `HzPrimaryButton({label, onPressed, isLoading, icon})`: Full-width CTA with optional loader. Disable via `isLoading` instead of nulling `onPressed` to keep layout stable.
- `HzSecondaryButton({label, onPressed, icon})`: Outlined alternative for cancel/secondary actions.

Usage:
```dart
HzPrimaryButton(
  label: 'Continue',
  icon: Icons.check_circle,
  isLoading: state.isSaving,
  onPressed: state.isSaving ? null : _submit,
);
```

## HeroHeader (Home)
- Props: `greetingName`, `heroStats`, `score`.
- Behaviour: Quick Scan button triggers `/scan/permission`, logs analytics, and plays a light haptic.
- Layout: Uses gradients and a fixed height; wrap in a `SizedBox` when embedding outside the Home screen.

## PulseCard
- Props: `PulseModel pulse`, `List<PulseHighlightModel> highlights`.
- Shows skin pulse score, sparkline, and highlight pills. Provide at least one highlight for optimal layout; if `trend` is empty, the component renders a “No data yet” message.

## InsightCards
- Props: `List<InsightModel> insights`.
- Empty list → neutral empty state box.
- On wide layouts (`>700px`) cards render in a row; otherwise they stack with spacing. Supply `progress` as a value between `0` and `1`.

## Lists & Carousels
- `ProductCarousel`, `RoutineCarousel`, `ArticleList` all accept pre-mapped view models from `HomeViewData`. Pass routes that exist in `GoRouter` to keep navigation consistent.
- For offline mode, surface cached data by toggling `usingCache` flags in providers (already handled in `HomeProvider`).

## Loading & Error Surfaces
- `HzSkeleton` and `AppLoadingOverlay` are the preferred skeleton/overlay components.
- `OfflineBanner` listens to `ConnectivityProvider` and should stay mounted near the top of the widget tree (it is already included in `MyApp`).

## Navigation Shell
- `ShellScaffold` wraps tabbed routes and injects the scan FAB. FAB toggles between scan and close icons depending on whether the current route starts with `/scan`.
- When adding new tabs, update `_tabs` in `ShellScaffold` and ensure `AppRouter` routes are nested under the shell.
