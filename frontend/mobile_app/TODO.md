# TODO - Flutter Mobile App

## Phase 1 - Critical (Week 1-2)
- [x] Backend integration (placeholder): tao `HomeProvider` goi `AnalysesApiService` (hoac mock service tam thoi). Chua co backend: tao interface + stub return fake data, TODO: thay bang API that, ket noi refresh token, map DTO -> entity -> UI model.
- [x] Home screen refactor: tach `presentation/screens/home_screen.dart` thanh folder `presentation/screens/home/` (hero_header.dart, pulse_card.dart, insight_cards.dart, routine_carousel.dart, article_list.dart) + `models/home_models.dart`. Cap nhat router import.
- [x] Performance UI: bo nested ListView, them lazy load + infinite scroll lich su (HistoryScreen), dung OptimizedNetworkImage cacheWidth/cacheHeight, shimmer skeleton via `HzSkeleton`, RefreshIndicator home/history.
- [x] Error handling: HomeProvider co error state, HistoryScreen dung `ErrorState` retry, providers da boc try-catch; next: ap validation cho form theo `input_validators.dart` (phase sau).

## Phase 2 - Enhanced (Week 3-4)
- [x] Theme/dark mode: them palette dark trong `theme/app_theme.dart` + `AppColors`, toggle/persist `ThemeProvider` (`shared_preferences`), default `ThemeMode.system`, UI toggle trong Profile Overview.
- [x] Accessibility: bo sung `Semantics`/tooltip cho quick scan, article card, product card, routine actions, pulse highlight; History tile co semantics; de nghi tiep tuc review contrast/colorScheme cho cac widget khac.
- [ ] Testing: them unit test cho usecases/repositories (`test/domain`, `test/data`), provider tests (`test/presentation/providers`), widget tests cho UI kit, integration test luong auth + scan fake backend.

## Phase 3 - UX (Week 5-6)
- [ ] Onboarding/quiz: flow trong `presentation/screens/onboarding/`, flag first-run (`shared_preferences`), router entry trong `app_router.dart`.
- [ ] UX quick wins: `RefreshIndicator` cho home, thay `HzSkeleton` bang shimmer, tao `ErrorStateWidget` dung chung (no internet/server/empty/not found).
- [ ] Notifications & feedback: tich hop local notification reminder routine (push hook TODO khi backend san), them `HapticFeedback` cho action chinh.

## Phase 4 - Analytics & Social (Week 7-8)
- [ ] Analytics events: log screen view, button tap, scan completed, product view qua `core/analytics/analytics_service.dart` (ten event camelCase). Them testing stub khi backend analytics chua san.
- [ ] Social/sharing (optional): chia se ket qua, review/rating product, referral. Dat sau khi backend social mo.
