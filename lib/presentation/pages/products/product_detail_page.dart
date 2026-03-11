import 'package:flutter/material.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/theme/app_theme.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  IconData _iconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'smartphones':
      case 'mobile-accessories':
        return Icons.smartphone_rounded;
      case 'laptops':
      case 'tablets':
        return Icons.laptop_rounded;
      case 'fragrances':
      case 'beauty':
      case 'skin-care':
        return Icons.spa_rounded;
      case 'groceries':
        return Icons.local_grocery_store_rounded;
      case 'home-decoration':
      case 'furniture':
        return Icons.chair_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  Color _colorForId(int id) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6584),
      const Color(0xFF43E97B),
      const Color(0xFFFFB347),
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final heroColor = _colorForId(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ──────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: heroColor.withOpacity(0.15),
            iconTheme: IconThemeData(color: appColors.textPrimary),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: heroColor.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: heroColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: heroColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _iconForCategory(product.category),
                        color: heroColor,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: product.stock > 0
                      ? appColors.success.withOpacity(0.12)
                      : appColors.danger.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: product.stock > 0
                        ? appColors.success.withOpacity(0.3)
                        : appColors.danger.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  product.stock > 0 ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: product.stock > 0 ? appColors.success : appColors.danger,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          // ── Content ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + category
                  Text(
                    product.title,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: appColors.textSecondary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price row
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (product.discountPercentage > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.danger.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: appColors.danger.withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            '${product.discountPercentage.toStringAsFixed(1)}% OFF',
                            style: TextStyle(
                              fontSize: 10,
                              color: appColors.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.star_rounded,
                        iconColor: Colors.amber,
                        value: product.rating.toStringAsFixed(1),
                        label: 'Rating',
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.inventory_2_outlined,
                        iconColor: appColors.success,
                        value: product.stock.toString(),
                        label: 'Stock',
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.local_offer_outlined,
                        iconColor: theme.colorScheme.primary,
                        value:
                            '${product.discountPercentage.toStringAsFixed(0)}%',
                        label: 'Discount',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Divider(color: appColors.border),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  if (product.tags.isNotEmpty) ...[
                    Text('Tags', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: appColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                color: appColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
