import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../core/theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail placeholder with icon
              _ProductThumbnail(productId: product.id, category: product.category),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: appColors.textSecondary,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: appColors.success,
                          ),
                        ),
                        const Spacer(),
                        _RatingChip(rating: product.rating),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: appColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  final int productId;
  final String category;

  const _ProductThumbnail({required this.productId, required this.category});

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
      case 'food':
        return Icons.local_grocery_store_rounded;
      case 'home-decoration':
      case 'furniture':
        return Icons.chair_rounded;
      case 'tops':
      case 'womens-dresses':
      case 'mens-shirts':
      case 'mens-shoes':
      case 'womens-shoes':
      case 'womens-bags':
      case 'mens-watches':
      case 'womens-watches':
      case 'womens-jewellery':
      case 'sunglasses':
        return Icons.checkroom_rounded;
      case 'automotive':
        return Icons.directions_car_rounded;
      case 'motorcycle':
      case 'vehicle':
        return Icons.two_wheeler_rounded;
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
    final color = _colorForId(productId);
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Icon(_iconForCategory(category), color: color, size: 26),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;

  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 11),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
