import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';

class HomeMockData {
  HomeMockData._();

  static HomeDashboard dashboard = const HomeDashboard(
    greetingName: 'Hana',
    heroStats: [
      HomeHeroStat(
        label: 'Hydration',
        value: '62%',
        icon: 'water_drop',
        detail: '+4 today',
        color: 0xFF4C9AFF,
      ),
      HomeHeroStat(
        label: 'Streak',
        value: '12 days',
        icon: 'local_fire_department',
        detail: 'On track',
        color: 0xFF6F52ED,
      ),
      HomeHeroStat(
        label: 'Recovery',
        value: 'Low redness',
        icon: 'eco',
        detail: 'Gentle mode',
        color: 0xFF4DB6AC,
      ),
    ],
    pulse: HomePulse(
      score: 82,
      trend: [0.46, 0.5, 0.58, 0.62, 0.66, 0.7, 0.74],
      delta: '+4 vs yesterday',
      mood: 'Calm barrier',
      updated: 'Synced 8 min ago',
    ),
    pulseHighlights: [
      HomePulseHighlight(
        label: 'Moisture',
        value: '64% sweet spot',
        icon: 'water_drop',
        color: 0xFF4C9AFF,
      ),
      HomePulseHighlight(
        label: 'Resilience',
        value: 'Low redness',
        icon: 'favorite',
        color: 0xFF4DB6AC,
      ),
      HomePulseHighlight(
        label: 'Environment',
        value: 'Indoor 26C / 58%',
        icon: 'cloud',
        color: 0xFFF4A259,
      ),
    ],
    insights: [
      HomeInsight(
        title: 'Moisture score',
        caption: 'Completed 3/5 deep hydration sessions this week.',
        icon: 'water_drop',
        progress: 0.6,
        iconColor: 0xFF4C9AFF,
      ),
      HomeInsight(
        title: 'Scan consistency',
        caption: 'Night scans maintained for 12 consecutive days.',
        icon: 'radar',
        progress: 0.8,
        iconColor: 0xFF6F52ED,
      ),
      HomeInsight(
        title: 'Barrier strength',
        caption: 'Recovery nights keep irritation risk under 2%.',
        icon: 'shield_moon',
        progress: 0.72,
        iconColor: 0xFF4DB6AC,
      ),
    ],
    routines: [
      HomeRoutine(
        title: 'Morning care',
        icon: 'sunny',
        steps: [
          'Enzyme cleanser',
          'Chamomile toner',
          'Vitamin C serum',
          'Barrier cream',
          'SPF 50 sunscreen',
        ],
        focus: 'Hydrate, brighten, and protect',
        minutes: 7,
        bestMoment: '7 AM',
        accentColor: 0xFFF4A259,
      ),
      HomeRoutine(
        title: 'Night repair',
        icon: 'nightlight',
        steps: [
          'Oil cleanser',
          'Gentle gel wash',
          'Mild BHA toner',
          'Recovery serum',
          'Sleeping mask',
        ],
        focus: 'Soothe barrier after the day',
        minutes: 9,
        bestMoment: '9 PM',
        accentColor: 0xFF8A8E5A,
      ),
    ],
    articles: [
      HomeArticle(
        title: 'Minimal night routine',
        subtitle: 'Three essential steps to keep your skin glowing.',
        icon: 'timeline',
        readingTime: '3 min read',
        route: '/community/detail/1',
        heroColor: 0xFF7C8CFF,
      ),
      HomeArticle(
        title: 'Skin cycling in 7 days',
        subtitle: 'Alternate acids and recovery nights without irritation.',
        icon: 'autorenew',
        readingTime: '5 min read',
        route: '/community/detail/2',
        heroColor: 0xFFF48FB1,
      ),
    ],
    products: [
      HomeProduct(
        name: 'Skin1004 Madagascar Ampoule',
        benefit: 'Soothes sensitive skin and restores the moisture barrier.',
        rating: 4.8,
        icon: 'science',
        route: '/products/serum-centella',
        badge: 'Barrier repair',
        color: 0xFF90CAF9,
        imageUrl: null,
      ),
      HomeProduct(
        name: 'La Roche-Posay Effaclar Duo+',
        benefit: 'Targets breakouts and helps fade fresh marks.',
        rating: 4.7,
        icon: 'medical_services',
        route: '/products/effaclar-duo',
        badge: 'Acne control',
        color: 0xFFF48FB1,
        imageUrl: null,
      ),
      HomeProduct(
        name: 'Paula\'s Choice BHA 2%',
        benefit: 'Unclogs pores, refines texture, and keeps congestion down.',
        rating: 4.9,
        icon: 'blur_on',
        route: '/products/pc-bha',
        badge: 'Texture reset',
        color: 0xFFCE93D8,
        imageUrl: null,
      ),
    ],
  );
}
