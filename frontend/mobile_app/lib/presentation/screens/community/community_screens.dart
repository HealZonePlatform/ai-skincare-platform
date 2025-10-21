import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = List.generate(
      5,
      (index) => _CommunityPost(
        id: '',
        title: 'Skincare everyday #',
        author: 'Ngoc Anh',
        excerpt: 'A simple routine and balanced lifestyle helped me calm breakouts in just two weeks.',
        likes: 12 + index,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealZone community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'New post',
            onPressed: () => context.push('/community/new'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.l),
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.l)),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.l),
              onTap: () => context.push('/community/detail/'),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSpacing.s),
                    Text(post.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 18)),
                        const SizedBox(width: AppSpacing.s),
                        Text(post.author),
                        const Spacer(),
                        const Icon(Icons.favorite_border, size: 18),
                        const SizedBox(width: 4),
                        Text('')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
        itemCount: posts.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new'),
        icon: const Icon(Icons.edit),
        label: const Text('Write a post'),
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
              Text('Skincare everyday #', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.s),
              Row(
                children: const [
                  CircleAvatar(radius: 20, child: Icon(Icons.person)),
                  SizedBox(width: AppSpacing.s),
                  Text('Ngoc Anh • 2 hours ago'),
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('Comments (12)')),
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
                  hintText: 'Tell the community about your skincare experience...',
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.image_outlined), label: const Text('Add images')),
                  const SizedBox(width: AppSpacing.m),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.sell_outlined), label: const Text('Add tags')),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Publish post',
                icon: Icons.send_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your post is being processed.')),
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

  const _CommunityPost({
    required this.id,
    required this.title,
    required this.author,
    required this.excerpt,
    required this.likes,
  });
}
