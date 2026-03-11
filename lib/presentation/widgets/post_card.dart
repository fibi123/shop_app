import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../core/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: appColors.border),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags row
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: post.tags
                    .take(3)
                    .map((tag) => _TagChip(tag: tag))
                    .toList(),
              ),
            const SizedBox(height: 10),
            // Title
            Text(
              post.title,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Body preview
            Text(
              post.body,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Footer
            Row(
              children: [
                _ReactionItem(
                  icon: Icons.thumb_up_rounded,
                  count: post.likes,
                  color: appColors.success,
                ),
                const SizedBox(width: 12),
                _ReactionItem(
                  icon: Icons.thumb_down_rounded,
                  count: post.dislikes,
                  color: appColors.danger,
                ),
                const SizedBox(width: 12),
                _ReactionItem(
                  icon: Icons.visibility_rounded,
                  count: post.views,
                  color: appColors.textSecondary,
                ),
                const Spacer(),
                Text(
                  'Read more',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 9,
          color: primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ReactionItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _ReactionItem({
    required this.icon,
    required this.count,
    required this.color,
  });

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          _format(count),
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
