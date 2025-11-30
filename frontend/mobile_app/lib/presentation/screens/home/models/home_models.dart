import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';

class HomeViewData {
  HomeViewData({
    required this.greetingName,
    required this.heroStats,
    required this.pulse,
    required this.pulseHighlights,
    required this.insights,
    required this.routines,
    required this.articles,
    required this.products,
  });

  final String greetingName;
  final List<HeroStatModel> heroStats;
  final PulseModel pulse;
  final List<PulseHighlightModel> pulseHighlights;
  final List<InsightModel> insights;
  final List<RoutineModel> routines;
  final List<ArticleModel> articles;
  final List<ProductModel> products;

  factory HomeViewData.fromEntity(HomeDashboard dashboard) {
    return HomeViewData(
      greetingName: dashboard.greetingName,
      heroStats: dashboard.heroStats
          .map(
            (stat) => HeroStatModel(
              label: stat.label,
              value: stat.value,
              detail: stat.detail,
              color: _colorFromHex(stat.color),
              icon: _resolveIcon(stat.icon, Icons.timelapse_rounded),
            ),
          )
          .toList(),
      pulse: PulseModel(
        score: dashboard.pulse.score,
        trend: dashboard.pulse.trend,
        delta: dashboard.pulse.delta,
        mood: dashboard.pulse.mood,
        updated: dashboard.pulse.updated,
      ),
      pulseHighlights: dashboard.pulseHighlights
          .map(
            (highlight) => PulseHighlightModel(
              label: highlight.label,
              value: highlight.value,
              icon: _resolveIcon(highlight.icon, Icons.bubble_chart_outlined),
              color: _colorFromHex(highlight.color),
            ),
          )
          .toList(),
      insights: dashboard.insights
          .map(
            (insight) => InsightModel(
              title: insight.title,
              caption: insight.caption,
              icon: _resolveIcon(insight.icon, Icons.chat_bubble_outline),
              progress: insight.progress,
              iconColor: _colorFromHex(insight.iconColor),
            ),
          )
          .toList(),
      routines: dashboard.routines
          .map(
            (routine) => RoutineModel(
              title: routine.title,
              focus: routine.focus,
              steps: routine.steps,
              minutes: routine.minutes,
              bestMoment: routine.bestMoment,
              icon: _resolveIcon(routine.icon, Icons.timer_outlined),
              accentColor: _colorFromHex(routine.accentColor),
            ),
          )
          .toList(),
      articles: dashboard.articles
          .map(
            (article) => ArticleModel(
              title: article.title,
              subtitle: article.subtitle,
              icon: _resolveIcon(article.icon, Icons.timeline_rounded),
              readingTime: article.readingTime,
              route: article.route,
              heroColor: _colorFromHex(article.heroColor),
            ),
          )
          .toList(),
      products: dashboard.products
          .map(
            (product) => ProductModel(
              name: product.name,
              benefit: product.benefit,
              rating: product.rating,
              icon: _resolveIcon(product.icon, Icons.star_rounded),
              route: product.route,
              badge: product.badge,
              color: _colorFromHex(product.color),
              imageUrl: product.imageUrl,
              placeholderAsset: AppAssets.productPlaceholder,
            ),
          )
          .toList(),
    );
  }
}

class HeroStatModel {
  const HeroStatModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.detail,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final String detail;
  final Color color;
}

class PulseModel {
  const PulseModel({
    required this.score,
    required this.trend,
    required this.delta,
    required this.mood,
    required this.updated,
  });

  final int score;
  final List<double> trend;
  final String delta;
  final String mood;
  final String updated;
}

class PulseHighlightModel {
  const PulseHighlightModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class InsightModel {
  const InsightModel({
    required this.title,
    required this.caption,
    required this.icon,
    required this.progress,
    required this.iconColor,
  });

  final String title;
  final String caption;
  final IconData icon;
  final double progress;
  final Color iconColor;
}

class RoutineModel {
  const RoutineModel({
    required this.title,
    required this.icon,
    required this.steps,
    required this.focus,
    required this.minutes,
    required this.bestMoment,
    required this.accentColor,
  });

  final String title;
  final IconData icon;
  final List<String> steps;
  final String focus;
  final int minutes;
  final String bestMoment;
  final Color accentColor;
}

class ArticleModel {
  const ArticleModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.readingTime,
    required this.route,
    required this.heroColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String readingTime;
  final String route;
  final Color heroColor;
}

class ProductModel {
  const ProductModel({
    required this.name,
    required this.benefit,
    required this.rating,
    required this.icon,
    required this.route,
    required this.badge,
    required this.color,
    required this.placeholderAsset,
    this.imageUrl,
  });

  final String name;
  final String benefit;
  final double rating;
  final IconData icon;
  final String route;
  final String badge;
  final Color color;
  final String placeholderAsset;
  final String? imageUrl;
}

Color _colorFromHex(int hex) => Color(hex);

IconData _resolveIcon(String key, IconData fallback) {
  const lookup = <String, IconData>{
    'water_drop': Icons.water_drop_outlined,
    'local_fire_department': Icons.local_fire_department_outlined,
    'eco': Icons.eco_outlined,
    'monitor_heart': Icons.monitor_heart_outlined,
    'favorite': Icons.favorite_outline,
    'cloud': Icons.wb_cloudy_outlined,
    'radar': Icons.radar_outlined,
    'shield_moon': Icons.shield_moon_outlined,
    'sunny': Icons.wb_sunny_outlined,
    'nightlight': Icons.nightlight_outlined,
    'timeline': Icons.timeline_rounded,
    'autorenew': Icons.autorenew_rounded,
    'science': Icons.science_outlined,
    'medical_services': Icons.medical_services_outlined,
    'blur_on': Icons.blur_on_outlined,
    'auto_awesome': Icons.auto_awesome,
    'center_focus': Icons.center_focus_strong_rounded,
    'chat_bubble': Icons.chat_bubble_outline,
    'notifications': Icons.notifications_outlined,
    'star': Icons.star_rounded,
    'timer': Icons.timer_outlined,
    'bubble_chart': Icons.bubble_chart_outlined,
    'person': Icons.person_outline,
    'timelapse': Icons.timelapse_rounded,
  };

  return lookup[key] ?? fallback;
}
