import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';

int _parseColor(Object? value, {int fallback = 0xFF4C9AFF}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    final normalized = value.replaceAll('#', '').trim();
    try {
      return int.parse('0xFF$normalized');
    } catch (_) {
      return fallback;
    }
  }
  return fallback;
}

double _parseDouble(Object? value, {double fallback = 0.0}) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}

int _parseInt(Object? value, {int fallback = 0}) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}

String _parseString(Object? value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }
  return value.toString();
}

class HomeDashboardDto {
  const HomeDashboardDto({
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
  final List<HomeHeroStatDto> heroStats;
  final HomePulseDto pulse;
  final List<HomePulseHighlightDto> pulseHighlights;
  final List<HomeInsightDto> insights;
  final List<HomeRoutineDto> routines;
  final List<HomeArticleDto> articles;
  final List<HomeProductDto> products;

  factory HomeDashboardDto.fromJson(Map<String, dynamic> json) {
    final heroStatsJson = (json['heroStats'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final pulseHighlightsJson = (json['pulseHighlights'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final insightsJson = (json['insights'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final routinesJson = (json['routines'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final articlesJson = (json['articles'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final productsJson = (json['products'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    return HomeDashboardDto(
      greetingName: _parseString(json['greetingName'], fallback: 'Friend'),
      heroStats: heroStatsJson
          .map(
            (item) =>
                HomeHeroStatDto.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
      pulse: HomePulseDto.fromJson(
        (json['pulse'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      ),
      pulseHighlights: pulseHighlightsJson
          .map(
            (item) => HomePulseHighlightDto.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      insights: insightsJson
          .map(
            (item) =>
                HomeInsightDto.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
      routines: routinesJson
          .map(
            (item) =>
                HomeRoutineDto.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
      articles: articlesJson
          .map(
            (item) =>
                HomeArticleDto.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
      products: productsJson
          .map(
            (item) =>
                HomeProductDto.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
    );
  }

  HomeDashboard toEntity() {
    return HomeDashboard(
      greetingName: greetingName,
      heroStats: heroStats.map((dto) => dto.toEntity()).toList(),
      pulse: pulse.toEntity(),
      pulseHighlights: pulseHighlights.map((dto) => dto.toEntity()).toList(),
      insights: insights.map((dto) => dto.toEntity()).toList(),
      routines: routines.map((dto) => dto.toEntity()).toList(),
      articles: articles.map((dto) => dto.toEntity()).toList(),
      products: products.map((dto) => dto.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greetingName': greetingName,
      'heroStats': heroStats.map((e) => e.toJson()).toList(),
      'pulse': pulse.toJson(),
      'pulseHighlights': pulseHighlights.map((e) => e.toJson()).toList(),
      'insights': insights.map((e) => e.toJson()).toList(),
      'routines': routines.map((e) => e.toJson()).toList(),
      'articles': articles.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class HomeHeroStatDto {
  const HomeHeroStatDto({
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

  factory HomeHeroStatDto.fromJson(Map<String, dynamic> json) {
    return HomeHeroStatDto(
      label: _parseString(json['label']),
      value: _parseString(json['value']),
      icon: _parseString(json['icon']),
      detail: _parseString(json['detail']),
      color: _parseColor(json['color']),
    );
  }

  HomeHeroStat toEntity() {
    return HomeHeroStat(
      label: label,
      value: value,
      icon: icon,
      detail: detail,
      color: color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'icon': icon,
      'detail': detail,
      'color': color,
    };
  }
}

class HomePulseDto {
  const HomePulseDto({
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

  factory HomePulseDto.fromJson(Map<String, dynamic> json) {
    final trendJson = json['trend'] as List<dynamic>? ?? <dynamic>[];
    return HomePulseDto(
      score: _parseInt(json['score'], fallback: 0),
      trend: trendJson
          .map(
            (item) => _parseDouble(item, fallback: 0.0),
          )
          .toList(),
      delta: _parseString(json['delta']),
      mood: _parseString(json['mood']),
      updated: _parseString(json['updated']),
    );
  }

  HomePulse toEntity() {
    return HomePulse(
      score: score,
      trend: trend,
      delta: delta,
      mood: mood,
      updated: updated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'trend': trend,
      'delta': delta,
      'mood': mood,
      'updated': updated,
    };
  }
}

class HomePulseHighlightDto {
  const HomePulseHighlightDto({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final int color;

  factory HomePulseHighlightDto.fromJson(Map<String, dynamic> json) {
    return HomePulseHighlightDto(
      label: _parseString(json['label']),
      value: _parseString(json['value']),
      icon: _parseString(json['icon']),
      color: _parseColor(json['color']),
    );
  }

  HomePulseHighlight toEntity() {
    return HomePulseHighlight(
      label: label,
      value: value,
      icon: icon,
      color: color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'icon': icon,
      'color': color,
    };
  }
}

class HomeInsightDto {
  const HomeInsightDto({
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

  factory HomeInsightDto.fromJson(Map<String, dynamic> json) {
    return HomeInsightDto(
      title: _parseString(json['title']),
      caption: _parseString(json['caption']),
      icon: _parseString(json['icon']),
      progress: _parseDouble(json['progress'], fallback: 0.0),
      iconColor: _parseColor(json['iconColor']),
    );
  }

  HomeInsight toEntity() {
    return HomeInsight(
      title: title,
      caption: caption,
      icon: icon,
      progress: progress,
      iconColor: iconColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'caption': caption,
      'icon': icon,
      'progress': progress,
      'iconColor': iconColor,
    };
  }
}

class HomeRoutineDto {
  const HomeRoutineDto({
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

  factory HomeRoutineDto.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'] as List<dynamic>? ?? <dynamic>[];
    return HomeRoutineDto(
      title: _parseString(json['title']),
      icon: _parseString(json['icon']),
      steps: stepsJson.map((item) => _parseString(item)).toList(),
      focus: _parseString(json['focus']),
      minutes: _parseInt(json['minutes'], fallback: 0),
      bestMoment: _parseString(json['bestMoment']),
      accentColor: _parseColor(json['accentColor'], fallback: 0xFF6F52ED),
    );
  }

  HomeRoutine toEntity() {
    return HomeRoutine(
      title: title,
      icon: icon,
      steps: steps,
      focus: focus,
      minutes: minutes,
      bestMoment: bestMoment,
      accentColor: accentColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'steps': steps,
      'focus': focus,
      'minutes': minutes,
      'bestMoment': bestMoment,
      'accentColor': accentColor,
    };
  }
}

class HomeArticleDto {
  const HomeArticleDto({
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

  factory HomeArticleDto.fromJson(Map<String, dynamic> json) {
    return HomeArticleDto(
      title: _parseString(json['title']),
      subtitle: _parseString(json['subtitle']),
      icon: _parseString(json['icon']),
      readingTime: _parseString(json['readingTime']),
      route: _parseString(json['route']),
      heroColor: _parseColor(json['heroColor'], fallback: 0xFF7C8CFF),
    );
  }

  HomeArticle toEntity() {
    return HomeArticle(
      title: title,
      subtitle: subtitle,
      icon: icon,
      readingTime: readingTime,
      route: route,
      heroColor: heroColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'readingTime': readingTime,
      'route': route,
      'heroColor': heroColor,
    };
  }
}

class HomeProductDto {
  const HomeProductDto({
    required this.name,
    required this.benefit,
    required this.rating,
    required this.icon,
    required this.route,
    required this.badge,
    required this.color,
    required this.imageUrl,
  });

  final String name;
  final String benefit;
  final double rating;
  final String icon;
  final String route;
  final String badge;
  final int color;
  final String? imageUrl;

  factory HomeProductDto.fromJson(Map<String, dynamic> json) {
    return HomeProductDto(
      name: _parseString(json['name']),
      benefit: _parseString(json['benefit']),
      rating: _parseDouble(json['rating'], fallback: 0.0),
      icon: _parseString(json['icon']),
      route: _parseString(json['route']),
      badge: _parseString(json['badge']),
      color: _parseColor(json['color'], fallback: 0xFF90CAF9),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  HomeProduct toEntity() {
    return HomeProduct(
      name: name,
      benefit: benefit,
      rating: rating,
      icon: icon,
      route: route,
      badge: badge,
      color: color,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'benefit': benefit,
      'rating': rating,
      'icon': icon,
      'route': route,
      'badge': badge,
      'color': color,
      'imageUrl': imageUrl,
    };
  }
}
