# TODO - Theme & UX Polish

Scope: finish dark mode, standardize spacing, and harden form/keyboard behaviors.

## Theme system
- [x] Wire `ThemeProvider` so `AppTheme.build(isDark)` is used in `main.dart`; persist choice via preferences and load on startup.
- [ ] Audit colors/gradients to ensure dark mode variants exist; avoid hardcoded light-only colors in widgets.
- [ ] Add a quick toggle entry (settings/profile) and ensure theme changes propagate without restart.

## Layout safety
- [ ] Wrap screens with `SafeArea` where content can collide with status bar/home indicator (login, home bottom sections, scan).
- [ ] Set `resizeToAvoidBottomInset` and add bottom padding using `viewInsets` for forms so keyboard does not cover inputs/CTA.
- [ ] Test on small devices (e.g., iPhone SE) and devices with notch/gesture nav.

## Spacing and design tokens
- [ ] Replace hardcoded paddings/gaps with `AppSpacing` across presentation layer; add any missing constants to the theme spec if needed.
- [ ] Ensure text styles come from theme (no ad-hoc `TextStyle` unless justified).

## Forms and validation
- [ ] Add real-time validation (on blur and on submit) for auth/profile forms with inline requirement indicators and success checkmarks.
- [ ] Provide friendly error copy and actionable fixes; keep error surfaces consistent (below field or via helper text).
- [ ] Add loading/empty/error states for all networked screens; reuse `app_loading_overlay` and skeleton components.
