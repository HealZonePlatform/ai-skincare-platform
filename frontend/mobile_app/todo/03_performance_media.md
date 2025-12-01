# TODO - Performance & Media

Scope: remove scroll jank, optimize image loading, and tame animations.

## Lists and slivers
- [x] Refactor `lib/presentation/screens/home/widgets/product_carousel.dart` to avoid nested `ListView`; use `SliverList` or horizontal `CustomScrollView` with `itemExtent` and `cacheExtent`.
- [x] Apply the same pattern to `lib/presentation/screens/home/widgets/routine_carousel.dart` and any other horizontal carousels.
- [x] Review `home_screen.dart` scroll structure to ensure only one primary scroll view; avoid `ListView` inside `CustomScrollView`.
- [x] Profile scroll performance with Flutter DevTools (low-end Android target) and adjust cache extents accordingly.

## Image optimization
- [x] Update `lib/presentation/widgets/optimized_network_image.dart` to compute cache sizes based on device pixel ratio (`memCacheWidth`, `maxWidthDiskCache` etc.).
- [x] Add cache width/height to all `CachedNetworkImage` usages; add `cacheWidth`/`cacheHeight` to `Image.asset` where large assets are used.
- [x] Add shimmer/placeholder and error widgets that are lightweight (no heavy gradients); ensure consistent aspect ratios.
- [x] Consider preloading critical hero images on home/scan entry points.

## Animation lifecycle
- [x] In `scan` screens, `_ScanPrepareScreenState`, `scan_capture` equivalents, and `home/widgets/pulse_card.dart`, wrap `AnimationController` with `WidgetsBindingObserver` to pause on background and dispose safely.
- [x] Audit onboarding animations (`lib/presentation/screens/onboarding/`) for the same lifecycle handling; avoid unnecessary repeats when offscreen.
- [x] Measure CPU usage with DevTools during animations and cap durations/curves if needed.
