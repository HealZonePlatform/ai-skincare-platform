import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const posts = <_CommunityPost>[
      _CommunityPost(
        id: '1',
        title: 'Morning glow up - niacinamide focus',
        author: 'Ngoc Anh',
        excerpt:
            'Swapped harsh scrubs for a gentle gel cleanser and layered niacinamide serum. Breakouts calmed in 10 days.',
        likes: 42,
        comments: 12,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Niacinamide', 'SPF', 'Sensitive'],
      ),
      _CommunityPost(
        id: '2',
        title: 'Before/After: 4-week hyperpigmentation routine',
        author: 'Bao Tran',
        excerpt:
            'Vitamin C in the AM, azelaic acid at night, and consistent SPF made a huge difference. Sharing product list!',
        likes: 67,
        comments: 18,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Dark spots', 'Vitamin C', 'SPF'],
      ),
      _CommunityPost(
        id: '3',
        title: 'Barrier repair after over-exfoliation',
        author: 'Linh',
        excerpt:
            'I stopped all actives, focused on ceramides + moisturizer sandwiches. Skin bounced back faster than expected.',
        likes: 35,
        comments: 9,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Barrier care', 'Ceramide', 'SOS'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealZone Community'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ],
      ),
      body: posts.isEmpty
          ? const _EmptyCommunityState()
          : ListView.separated(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.xxl,
                top: AppSpacing.l,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: _CommunityHero(),
                  );
                }
                final post = posts[index - 1];
                return _PostCard(post: post);
              },
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.m),
              itemCount: posts.length + 1,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Haptics.medium();
          if (context.mounted) {
            context.push('/community/new');
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Share Story'),
      ),
    );
  }
}

class _EmptyCommunityState extends StatelessWidget {
  const _EmptyCommunityState();

  @override
  Widget build(BuildContext context) {
    return IllustratedMessage(
      icon: Icons.forum_outlined,
      title: 'No posts yet',
      message: 'Share your skincare journey to inspire the HealZone family.',
      actionLabel: 'Write a post',
      onAction: () => context.push('/community/new'),
      accent: AppColors.primary,
      illustration: IllustrationType.emptyCommunity,
    );
  }
}

class _CommunityHero extends StatelessWidget {
  const _CommunityHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: AppColors.sunriseGradient,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: AppShadows.softGlow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            child: const Icon(Icons.auto_awesome_rounded),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HealZone Community',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Share routines, before/after wins and products that changed your skin.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final _CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.mild,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () async {
          await Haptics.selection();
          if (context.mounted) {
            context.push('/community/detail/${post.id}');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l, vertical: AppSpacing.xs),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  post.author[0].toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                post.author,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Shared recently',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Stack(
                children: [
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image.asset(
                      post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.l,
                    right: AppSpacing.l,
                    bottom: AppSpacing.l,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: post.tags
                            .map(
                              (tag) => Container(
                                margin:
                                    const EdgeInsets.only(right: AppSpacing.s),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.m,
                                  vertical: AppSpacing.s / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: AppSpacing.m,
                        runSpacing: AppSpacing.s,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite,
                                  size: 22, color: AppColors.secondary),
                              const SizedBox(width: AppSpacing.s),
                              Text(
                                '${post.likes} likes',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.chat_bubble_outline,
                                  size: 22, color: AppColors.textSecondary),
                              const SizedBox(width: AppSpacing.xs),
                              Text('${post.comments} comments',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                          const Icon(Icons.bookmark_border,
                              size: 22, color: AppColors.textSecondary),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    post.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    post.excerpt,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityDetailScreen extends StatelessWidget {
  const CommunityDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skincare everyday #',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.s),
              const Row(
                children: [
                  CircleAvatar(radius: 20, child: Icon(Icons.person)),
                  SizedBox(width: AppSpacing.s),
                  Text('Ngoc Anh â€¢ 2 hours ago'),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Morning routine: micellar water, gentle gel cleanser, chamomile toner, niacinamide serum and SPF50. '
                    'In the evening I switch to an oil cleanser and a recovery serum to calm the skin after a long day.',
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border)),
                  const Spacer(),
                  TextButton(
                      onPressed: () {}, child: const Text('Comments (12)')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityNewPostScreen extends StatefulWidget {
  const CommunityNewPostScreen({super.key});

  @override
  State<CommunityNewPostScreen> createState() => _CommunityNewPostScreenState();
}

class _CommunityNewPostScreenState extends State<CommunityNewPostScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share your story')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText:
                      'Tell the community about your skincare experience...',
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Add images')),
                  const SizedBox(width: AppSpacing.m),
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sell_outlined),
                      label: const Text('Add tags')),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Publish post',
                icon: Icons.send_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Your post is being processed.')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityPost {
  final String id;
  final String title;
  final String author;
  final String excerpt;
  final int likes;
  final int comments;
  final String imageUrl;
  final List<String> tags;

  const _CommunityPost({
    required this.id,
    required this.title,
    required this.author,
    required this.excerpt,
    required this.likes,
    required this.comments,
    required this.imageUrl,
    required this.tags,
  });
}

