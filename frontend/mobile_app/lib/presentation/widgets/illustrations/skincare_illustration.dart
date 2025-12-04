import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

enum IllustrationType {
  emptyScan,
  emptyGoals,
  emptyCommunity,
  emptyArticles,
  emptyProducts,
  emptyHistory,
  errorState,
  celebration,
}

class SkincareIllustration extends StatelessWidget {
  const SkincareIllustration({
    super.key,
    required this.type,
    this.size = 220,
    this.showGlow = true,
  });

  final IllustrationType type;
  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final palette = _illustrationPalettes[type]!;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _GlowBackdrop(
            size: size,
            palette: palette,
            showGlow: showGlow,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: size * 0.58,
              height: size * 0.58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [palette.primary, palette.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.24),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: size * 0.12,
                    right: size * 0.12,
                    child: _Orb(
                      size: size * 0.14,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  Icon(
                    palette.glyph,
                    size: size * 0.26,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          ...palette.orbs.map(
            (orb) => _OrbWidget(
              spec: orb,
              size: size,
              accent: palette.accent,
            ),
          ),
          ...palette.badges.map(
            (badge) => _Badge(
              spec: badge,
              size: size,
              accent: palette.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBackdrop extends StatelessWidget {
  const _GlowBackdrop({
    required this.size,
    required this.palette,
    required this.showGlow,
  });

  final double size;
  final _IllustrationPalette palette;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              palette.primary.withValues(alpha: 0.18),
              palette.secondary.withValues(alpha: 0.12),
              Colors.transparent,
            ],
            stops: const [0.2, 0.6, 1],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: size * 0.08,
              top: size * 0.08,
              child: _Orb(
                size: size * 0.22,
                color: palette.secondary.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              right: size * 0.04,
              bottom: size * 0.04,
              child: _Orb(
                size: size * 0.16,
                color: palette.accent.withValues(alpha: 0.12),
              ),
            ),
            if (showGlow)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size * 0.9,
                  height: size * 0.24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        palette.accent.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.spec,
    required this.size,
    required this.accent,
  });

  final _BadgeSpec spec;
  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size * 0.36;
    return Align(
      alignment: spec.alignment,
      child: Container(
        constraints: BoxConstraints(minWidth: resolvedSize * 0.72),
        padding: EdgeInsets.symmetric(
          horizontal: resolvedSize * 0.18,
          vertical: resolvedSize * 0.12,
        ),
        decoration: BoxDecoration(
          color: (spec.background ?? accent.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              spec.icon,
              size: resolvedSize * 0.24,
              color: spec.foreground ?? AppColors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              spec.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: spec.foreground ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbWidget extends StatelessWidget {
  const _OrbWidget({
    required this.spec,
    required this.size,
    required this.accent,
  });

  final _OrbSpec spec;
  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final orbSize = size * spec.sizeFactor;
    return Align(
      alignment: spec.alignment,
      child: _Orb(
        size: orbSize,
        color: spec.color ?? accent.withValues(alpha: spec.opacity),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: size * 0.5,
            spreadRadius: -size * 0.12,
          ),
        ],
      ),
    );
  }
}

class _IllustrationPalette {
  const _IllustrationPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.glyph,
    required this.badges,
    required this.orbs,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final IconData glyph;
  final List<_BadgeSpec> badges;
  final List<_OrbSpec> orbs;
}

class _BadgeSpec {
  const _BadgeSpec({
    required this.alignment,
    required this.icon,
    required this.label,
    this.background,
    this.foreground,
  });

  final Alignment alignment;
  final IconData icon;
  final String label;
  final Color? background;
  final Color? foreground;
}

class _OrbSpec {
  const _OrbSpec({
    required this.alignment,
    required this.sizeFactor,
    required this.opacity,
    this.color,
  });

  final Alignment alignment;
  final double sizeFactor;
  final double opacity;
  final Color? color;
}

const _illustrationPalettes = <IllustrationType, _IllustrationPalette>{
  IllustrationType.emptyScan: _IllustrationPalette(
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
    accent: AppColors.accent,
    glyph: Icons.center_focus_strong_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.82, -0.55),
        icon: Icons.camera_alt_outlined,
        label: 'Scan ready',
      ),
      _BadgeSpec(
        alignment: Alignment(0.78, 0.3),
        icon: Icons.auto_awesome_rounded,
        label: 'AI glow',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.9, 0.2),
        sizeFactor: 0.26,
        opacity: 0.28,
        color: Color(0x40FFB5C5),
      ),
      _OrbSpec(
        alignment: Alignment(0.7, -0.65),
        sizeFactor: 0.18,
        opacity: 0.2,
      ),
      _OrbSpec(
        alignment: Alignment(-0.15, 0.9),
        sizeFactor: 0.16,
        opacity: 0.18,
        color: Color(0x389A7FB5),
      ),
    ],
  ),
  IllustrationType.emptyGoals: _IllustrationPalette(
    primary: AppColors.secondary,
    secondary: AppColors.secondaryLight,
    accent: AppColors.primary,
    glyph: Icons.emoji_events_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.82, -0.62),
        icon: Icons.flag_outlined,
        label: 'New goal',
      ),
      _BadgeSpec(
        alignment: Alignment(0.82, 0.36),
        icon: Icons.track_changes_rounded,
        label: 'Progress',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.75, 0.1),
        sizeFactor: 0.2,
        opacity: 0.25,
        color: Color(0x38E08A9D),
      ),
      _OrbSpec(
        alignment: Alignment(0.15, -0.88),
        sizeFactor: 0.14,
        opacity: 0.22,
      ),
      _OrbSpec(
        alignment: Alignment(0.76, 0.05),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x38A8E6CF),
      ),
    ],
  ),
  IllustrationType.emptyCommunity: _IllustrationPalette(
    primary: AppColors.accent,
    secondary: AppColors.accentLight,
    accent: AppColors.primary,
    glyph: Icons.forum_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.86, -0.32),
        icon: Icons.favorite_border,
        label: 'Kind vibes',
      ),
      _BadgeSpec(
        alignment: Alignment(0.85, 0.18),
        icon: Icons.image_outlined,
        label: 'Share shots',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.7, -0.74),
        sizeFactor: 0.18,
        opacity: 0.2,
      ),
      _OrbSpec(
        alignment: Alignment(0.12, 0.88),
        sizeFactor: 0.16,
        opacity: 0.2,
      ),
      _OrbSpec(
        alignment: Alignment(0.82, -0.12),
        sizeFactor: 0.18,
        opacity: 0.2,
        color: Color(0x38C5A9E0),
      ),
    ],
  ),
  IllustrationType.emptyArticles: _IllustrationPalette(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    glyph: Icons.menu_book_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.84, -0.44),
        icon: Icons.auto_stories_rounded,
        label: 'Stories',
      ),
      _BadgeSpec(
        alignment: Alignment(0.82, 0.2),
        icon: Icons.insights_outlined,
        label: 'Tips',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.74, 0.08),
        sizeFactor: 0.22,
        opacity: 0.22,
        color: Color(0x38C5A9E0),
      ),
      _OrbSpec(
        alignment: Alignment(0.18, -0.82),
        sizeFactor: 0.16,
        opacity: 0.2,
        color: Color(0x38FFB5C5),
      ),
      _OrbSpec(
        alignment: Alignment(0.82, 0.24),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x38A8E6CF),
      ),
    ],
  ),
  IllustrationType.emptyProducts: _IllustrationPalette(
    primary: AppColors.accent,
    secondary: AppColors.secondary,
    accent: AppColors.primary,
    glyph: Icons.spa_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.82, -0.48),
        icon: Icons.eco_outlined,
        label: 'Clean',
      ),
      _BadgeSpec(
        alignment: Alignment(0.84, 0.16),
        icon: Icons.science_outlined,
        label: 'Derm tested',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.68, 0.12),
        sizeFactor: 0.22,
        opacity: 0.22,
        color: Color(0x38A8E6CF),
      ),
      _OrbSpec(
        alignment: Alignment(0.22, -0.78),
        sizeFactor: 0.16,
        opacity: 0.2,
        color: Color(0x38FFC4C4),
      ),
      _OrbSpec(
        alignment: Alignment(0.82, 0.26),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x38C5A9E0),
      ),
    ],
  ),
  IllustrationType.emptyHistory: _IllustrationPalette(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    accent: AppColors.secondary,
    glyph: Icons.history_toggle_off_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.82, -0.52),
        icon: Icons.timeline,
        label: 'Track',
      ),
      _BadgeSpec(
        alignment: Alignment(0.82, 0.18),
        icon: Icons.center_focus_strong_rounded,
        label: 'Scan',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.7, 0.1),
        sizeFactor: 0.22,
        opacity: 0.22,
        color: Color(0x38C5A9E0),
      ),
      _OrbSpec(
        alignment: Alignment(0.18, -0.8),
        sizeFactor: 0.16,
        opacity: 0.2,
        color: Color(0x38A8E6CF),
      ),
      _OrbSpec(
        alignment: Alignment(0.84, 0.24),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x38FFB5C5),
      ),
    ],
  ),
  IllustrationType.errorState: _IllustrationPalette(
    primary: AppColors.danger,
    secondary: AppColors.dangerLight,
    accent: AppColors.warning,
    glyph: Icons.cloud_off_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.82, -0.45),
        icon: Icons.refresh_rounded,
        label: 'Retry',
      ),
      _BadgeSpec(
        alignment: Alignment(0.78, 0.22),
        icon: Icons.shield_outlined,
        label: 'Safe',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.74, 0.08),
        sizeFactor: 0.22,
        opacity: 0.24,
        color: Color(0x38FFE8B3),
      ),
      _OrbSpec(
        alignment: Alignment(0.24, -0.84),
        sizeFactor: 0.14,
        opacity: 0.18,
      ),
      _OrbSpec(
        alignment: Alignment(0.78, 0.04),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x38FF8A8A),
      ),
    ],
  ),
  IllustrationType.celebration: _IllustrationPalette(
    primary: AppColors.secondary,
    secondary: AppColors.primary,
    accent: AppColors.accent,
    glyph: Icons.auto_awesome_rounded,
    badges: [
      _BadgeSpec(
        alignment: Alignment(-0.8, -0.5),
        icon: Icons.emoji_events_outlined,
        label: 'Milestone',
      ),
      _BadgeSpec(
        alignment: Alignment(0.85, 0.1),
        icon: Icons.spa_rounded,
        label: 'Glow on',
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
      ),
    ],
    orbs: [
      _OrbSpec(
        alignment: Alignment(-0.66, 0.14),
        sizeFactor: 0.22,
        opacity: 0.22,
        color: Color(0x387AC4AB),
      ),
      _OrbSpec(
        alignment: Alignment(0.2, -0.78),
        sizeFactor: 0.16,
        opacity: 0.2,
      ),
      _OrbSpec(
        alignment: Alignment(0.84, 0.32),
        sizeFactor: 0.2,
        opacity: 0.2,
        color: Color(0x33E08A9D),
      ),
    ],
  ),
};
