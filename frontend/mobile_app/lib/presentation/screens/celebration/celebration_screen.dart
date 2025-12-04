import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

enum MilestoneType {
  firstScan,
  goalCompleted,
  weekStreak,
  skinImprovement,
  communityPost,
}

class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({
    super.key,
    this.milestoneType = MilestoneType.firstScan,
    this.title,
    this.subtitle,
    this.onContinue,
  });

  final MilestoneType milestoneType;
  final String? title;
  final String? subtitle;
  final VoidCallback? onContinue;

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen>
    with TickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _startCelebration();
  }

  void _startCelebration() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Haptics.success();
    _confettiController.play();
    _scaleController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _fadeController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  _MilestoneData get _milestoneData {
    switch (widget.milestoneType) {
      case MilestoneType.firstScan:
        return _MilestoneData(
          icon: Icons.face_retouching_natural,
          title: widget.title ?? 'First Scan Complete!',
          subtitle: widget.subtitle ??
              'You\'ve taken the first step towards healthier skin.',
          badgeColor: AppColors.primary,
          gradient: AppColors.sunriseGradient,
        );
      case MilestoneType.goalCompleted:
        return _MilestoneData(
          icon: Icons.emoji_events_rounded,
          title: widget.title ?? 'Goal Achieved!',
          subtitle:
              widget.subtitle ?? 'You\'ve completed your skincare goal.',
          badgeColor: AppColors.success,
          gradient: const LinearGradient(
            colors: [Color(0xFFA8E6CF), Color(0xFF56C596)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case MilestoneType.weekStreak:
        return _MilestoneData(
          icon: Icons.local_fire_department_rounded,
          title: widget.title ?? '7-Day Streak!',
          subtitle: widget.subtitle ??
              'Consistency is key! Keep up the great work.',
          badgeColor: AppColors.warning,
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD166), Color(0xFFFF9F1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case MilestoneType.skinImprovement:
        return _MilestoneData(
          icon: Icons.trending_up_rounded,
          title: widget.title ?? 'Skin Score Improved!',
          subtitle: widget.subtitle ??
              'Your skin is showing real progress.',
          badgeColor: AppColors.info,
          gradient: const LinearGradient(
            colors: [Color(0xFF7EC8E3), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case MilestoneType.communityPost:
        return _MilestoneData(
          icon: Icons.groups_rounded,
          title: widget.title ?? 'First Post!',
          subtitle:
              widget.subtitle ?? 'Welcome to the community! Share your journey.',
          badgeColor: AppColors.secondary,
          gradient: const LinearGradient(
            colors: [Color(0xFFC5A9E0), Color(0xFF9B59B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _milestoneData;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(decoration: BoxDecoration(gradient: data.gradient)),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 10,
              minBlastForce: 5,
              emissionFrequency: 0.03,
              numberOfParticles: 30,
              gravity: 0.15,
              shouldLoop: false,
              colors: const [
                Color(0xFFFFB5C5),
                Color(0xFFA8E6CF),
                Color(0xFFC5A9E0),
                Color(0xFFFFD166),
                Colors.white,
              ],
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(),

                  // Badge with icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: data.badgeColor.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: data.gradient,
                          ),
                          child: Icon(
                            data.icon,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Title and subtitle
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          data.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          data.subtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Continue button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: HzPrimaryButton(
                      label: 'Continue',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () {
                        Haptics.selection();
                        if (widget.onContinue != null) {
                          widget.onContinue!();
                        } else {
                          context.go('/home');
                        }
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: data.badgeColor,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneData {
  const _MilestoneData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeColor,
    required this.gradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color badgeColor;
  final LinearGradient gradient;
}
