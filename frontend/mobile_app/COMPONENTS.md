# UI Components (frontend/mobile_app)

This app uses a comprehensive UI kit under `lib/presentation/widgets`. Below are the components and how to use them.

## Core Components

### Buttons
- `HzPrimaryButton({label, onPressed, isLoading, icon})`: Full-width CTA with optional loader
- `HzSecondaryButton({label, onPressed, icon})`: Outlined alternative

### Loading & Error
- `HzSkeleton`, `AppLoadingOverlay`: Skeleton/overlay components
- `OfflineBanner`: Connectivity indicator

### Navigation
- `ShellScaffold`: Wraps tabbed routes with scan FAB

---

## Brand Identity Widgets (NEW)

### Icons (`widgets/icons/`)
```dart
import '.../widgets/icons/skin_type_icons.dart';
import '.../widgets/icons/ingredient_icons.dart';

// Skin type icons
SkinTypeIcon(skinType: SkinType.oily, size: 24)

// Ingredient icons  
IngredientIcon(name: 'niacinamide', size: 20)
```

### Skincare Visual Elements
| Widget | Import | Usage |
|--------|--------|-------|
| `SkinCompatibilityIndicator` | `skin_compatibility_indicator.dart` | Match score with breakdown |
| `StarRating` | `star_rating.dart` | Interactive/readonly ratings |
| `SkinConcernBadge` | `skin_concern_badge.dart` | Concern tags with colors |

---

### Routine Widgets (`widgets/routine/`)
```dart
import '.../widgets/routine/routine_widgets.dart';

// Step card with timeline
RoutineStepCard(step: step, isLast: false)

// Progress tracker
RoutineProgressTracker(completed: 3, total: 5)

// Timeline with reordering
RoutineTimelineView(steps: steps, onReorder: onReorder)

// Walkthrough mode
RoutineWalkthrough(steps: steps, onComplete: onComplete)
```

Categories: Cleanse, Tone, Treat, Moisturize, Protect, Special

---

### Community Widgets (`widgets/community/`)
```dart
import '.../widgets/community/community_widgets.dart';

// Post card (text, image, beforeAfter, routine, review)
CommunityPostCard(post: post)

// Product review with pros/cons
ProductReviewCard(review: review)

// Shareable routine
SharedRoutineCard(routine: routine)

// Skin journey timeline
SkinJourneyCard(entries: entries)
```

---

### Premium Widgets (`widgets/premium/`)
```dart
import '.../widgets/premium/premium_widgets.dart';

// 5 tiers: Free, Silver, Gold, Platinum, Diamond
PremiumBadge(tier: PremiumTier.gold, animate: true)

// Lock overlay
PremiumLock(
  child: featureWidget,
  requiredTier: PremiumTier.platinum,
  currentTier: user.tier,
)

// Subscription card
PremiumSubscriptionCard(
  tier: PremiumTier.gold,
  price: '9.99',
  features: ['AI Analysis', 'Unlimited Scans'],
  isPopular: true,
)
```

---

### Education Widgets (`widgets/education/`)
```dart
import '.../widgets/education/education_widgets.dart';

// Skincare tips (6 categories)
SkincareTipCard(tip: tip)
DailyTipWidget(tip: tip)

// Ingredient spotlight
IngredientSpotlight(ingredient: ingredient)

// Calendar tracking
SkinCalendar(month: 12, year: 2024, entries: entries)

// Streak widget
StreakWidget(currentStreak: 7, longestStreak: 14, weekData: weekData)

// Goal tracker
SkinGoalCard(goal: goal)
```

---

## Widget Structure

```
widgets/
├── icons/              # Skin type, ingredient icons
├── routine/            # Steps, progress, timeline
├── community/          # Posts, reviews, sharing
├── premium/            # Badges, locks, subscriptions
├── education/          # Tips, calendar, streaks
├── form/               # Requirement checklist
├── illustrations/      # Skincare illustrations
└── ui_kit/             # Layout, headers, chips, cards
```
