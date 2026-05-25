import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItemsAsync = ref.watch(wishlistItemsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = ref.watch(wishlistControllerProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'My Wishlist',
        showBackButton: true,
        actions: [
          if (wishlistItemsAsync.hasValue &&
              wishlistItemsAsync.value!.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Wishlist'),
                    content: const Text(
                      'Are you sure you want to remove all items from your wishlist?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await controller.clearWishlist();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: AppTypography.labelSmall(
                  color: isDark ? AppColors.darkError : AppColors.lightError,
                ),
              ),
            ),
        ],
      ),
      body: wishlistItemsAsync.when(
        data: (wishlistItems) {
          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: isDark
                        ? AppColors.neutral_500
                        : AppColors.neutral_400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: AppTypography.headline3(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save your favorite items here',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PremiumButton(
                    label: 'Start Shopping',
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/home'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: wishlistItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.network(
                        item.thumbnail,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: isDark
                                ? AppColors.darkSurfaceContainer
                                : AppColors.lightSurfaceContainer,
                            child: Icon(
                              Icons.image,
                              color: isDark
                                  ? AppColors.neutral_500
                                  : AppColors.neutral_400,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelLarge(
                                color: isDark
                                    ? AppColors.darkOnBackground
                                    : AppColors.lightOnBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating.toStringAsFixed(1)}',
                                  style: AppTypography.labelSmall(
                                    color: isDark
                                        ? AppColors.darkOnBackground
                                        : AppColors.lightOnBackground,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${item.reviewCount})',
                                  style: AppTypography.labelSmall(
                                    color: isDark
                                        ? AppColors.neutral_400
                                        : AppColors.neutral_600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '\$${item.discountedPrice.toStringAsFixed(2)}',
                                  style: AppTypography.labelLarge(
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                if (item.discountPercent > 0) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: AppTypography.labelSmall(
                                      color: isDark
                                          ? AppColors.neutral_400
                                          : AppColors.neutral_600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.removeFromWishlist(
                          item.title,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.delete_outline,
                          color: isDark
                              ? AppColors.darkError
                              : AppColors.lightError,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load wishlist',
                style: AppTypography.headline3(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PremiumButton(
                label: 'Retry',
                onPressed: () => ref.invalidate(wishlistItemsProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
