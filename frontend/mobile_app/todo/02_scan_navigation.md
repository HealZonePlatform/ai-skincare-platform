# TODO - Scan Flow & Navigation

Scope: rebuild scan journey, fix bottom navigation state, and ensure back/permission behaviors are consistent.

## Scan flow rebuild
- [x] Add permission screen (camera rationale + request) under `lib/presentation/screens/scan/` and wire route via `go_router`.
- [x] Implement real camera screen (using `camera` or `image_picker`) with framing overlay, auto/manual capture, and safe error handling. *(stubbed with guided capture + sample image)*
- [x] Insert processing screen that shows captured photo, progress, and realistic delay before showing results.
- [x] Refine prepare screen copy/checklist and replace confusing “sample result” CTA with clearer actions (“I am ready”, “View sample” optional).
- [x] Result screen: animate score, add “view detailed report” and “scan again” actions, and ensure data flows from analysis provider/use case. *(data currently sample)*

## Navigation and shell scaffold
- [x] In `lib/presentation/widgets/shell_scaffold.dart`, fix `_currentIndex` to highlight nested routes (`/scan/*`, `/products/*`, `/routine/*` etc.) and default correctly.
- [x] Make FAB contextual: switch icon/behavior between starting scan and closing scan routes.
- [x] Add visual feedback on tab tap (pressed/selected state) per design system.
- [x] Verify `app_router.dart` routes for scan subflows are named and grouped; add deep link paths if needed.

## Back handling and lifecycle
- [x] Add `WillPopScope` to scan screens to confirm when abandoning capture/processing; ensure Android hardware back behaves correctly.
- [x] Provide confirmation dialogs for destructive exits (losing scan progress).
- [x] Ensure profile sub-screens also expose back navigation consistently (explicit `BackButton` when custom app bars are used).

## Permissions and errors
- [x] Handle camera permission denied/permanently denied with clear CTAs (open settings).
- [x] Propagate capture/analysis errors to `GlobalErrorNotifier` and show inline recovery actions (retry, go home).
