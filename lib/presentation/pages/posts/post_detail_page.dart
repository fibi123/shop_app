import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../core/theme/app_theme.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
            tooltip: 'Save',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 16),

            // Title
            Text(post.title, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 12),

            // Meta
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'User #${post.userId}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.circle, size: 4, color: appColors.textSecondary),
                const SizedBox(width: 12),
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: appColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_formatNum(post.views)} views',
                  style: TextStyle(
                    fontSize: 12,
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: appColors.border),
            const SizedBox(height: 20),

            // Body
            Text(
              post.body,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
            ),
            const SizedBox(height: 32),
            Divider(color: appColors.border),
            const SizedBox(height: 20),

            // Reactions
            Text('Reactions', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                _ReactionButton(
                  icon: Icons.thumb_up_rounded,
                  label: 'Likes',
                  count: post.likes,
                  color: appColors.success,
                ),
                const SizedBox(width: 10),
                _ReactionButton(
                  icon: Icons.thumb_down_rounded,
                  label: 'Dislikes',
                  count: post.dislikes,
                  color: appColors.danger,
                ),
                const SizedBox(width: 10),
                _ReactionButton(
                  icon: Icons.visibility_rounded,
                  label: 'Views',
                  count: post.views,
                  color: appColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              _format(count),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: appColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
