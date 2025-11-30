class HomeDashboard {
  const HomeDashboard({
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
  final List<HomeHeroStat> heroStats;
  final HomePulse pulse;
  final List<HomePulseHighlight> pulseHighlights;
  final List<HomeInsight> insights;
  final List<HomeRoutine> routines;
  final List<HomeArticle> articles;
  final List<HomeProduct> products;
}

class HomeHeroStat {
  const HomeHeroStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.detail,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final String detail;
  final int color;
}

class HomePulse {
  const HomePulse({
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

class HomePulseHighlight {
  const HomePulseHighlight({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final int color;
}

class HomeInsight {
  const HomeInsight({
    required this.title,
    required this.caption,
    required this.icon,
    required this.progress,
    required this.iconColor,
  });

  final String title;
  final String caption;
  final String icon;
  final double progress;
  final int iconColor;
}

class HomeRoutine {
  const HomeRoutine({
    required this.title,
    required this.icon,
    required this.steps,
    required this.focus,
    required this.minutes,
    required this.bestMoment,
    required this.accentColor,
  });

  final String title;
  final String icon;
  final List<String> steps;
  final String focus;
  final int minutes;
  final String bestMoment;
  final int accentColor;
}

class HomeArticle {
  const HomeArticle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.readingTime,
    required this.route,
    required this.heroColor,
  });

  final String title;
  final String subtitle;
  final String icon;
  final String readingTime;
  final String route;
  final int heroColor;
}

class HomeProduct {
  const HomeProduct({
    required this.name,
    required this.benefit,
    required this.rating,
    required this.icon,
    required this.route,
    required this.badge,
    required this.color,
    this.imageUrl,
  });

  final String name;
  final String benefit;
  final double rating;
  final String icon;
  final String route;
  final String badge;
  final int color;
  final String? imageUrl;
}
