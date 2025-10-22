# HealZone Mobile Assets Guide

Add the artwork below to `assets/images/` so the UI can render the branded imagery without placeholders.

> 👉 **Tip:** export PNG (transparent background where possible) unless noted.

| File | Recommended Size | Notes / Usage |
| --- | --- | --- |
| `logo_full.png` | 1024×1024 | Square lockup placed on splash, login, register. Transparent background. |
| `logo_mark.png` | 256×256 | Icon-only version for AppBar/avatar chips. |
| `hero_wave.png` | 1920×900 | Soft gradient or abstract wave used on the home hero background. |
| `onboarding_1.png` | 1400×900 | Illustration for onboarding intro (AI skincare theme). |
| `product_placeholder.png` | 800×800 | Neutral product shot for catalogue cards when no image is available. |
| `analysis_placeholder.png` | 1400×900 | Visual used in profile history cards/detail when analysis image is missing. |

### Adding the files
1. Export the assets with the dimensions above.
2. Copy them into `frontend/mobile_app/assets/images/`.
3. Run `flutter pub get` (Android Studio: *Tools > Flutter > Pub get*).
4. Rebuild the app (`flutter run …`) to see the artwork applied.

The UI already handles missing assets (falls back to gradients/icons), so app won’t crash if a file is absent.
