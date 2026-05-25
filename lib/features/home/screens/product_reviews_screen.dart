import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Review> reviews = DummyDataProvider.reviews;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = DummyDataProvider.products[0];

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Reviews',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Summary
            PremiumCard(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${product.rating}',
                        style: AppTypography.displayLarge(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            color: i < 4 ? Colors.amber : Colors.grey,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.reviewCount} reviews',
                        style: AppTypography.labelSmall(
                          color:
                              isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 5; i >= 1; i--)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  '$i',
                                  style: AppTypography.labelSmall(
                                    color: isDark
                                        ? AppColors.darkOnBackground
                                        : AppColors.lightOnBackground,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: 0.8 - (i * 0.1),
                                    minHeight: 4,
                                    backgroundColor: isDark
                                        ? AppColors.darkSurfaceContainer
                                        : AppColors.lightSurfaceContainer,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Reviews List
            Text(
              'Customer Reviews',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: reviews
                  .map((review) => PremiumCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Info
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.darkSurfaceContainer
                                        : AppColors.lightSurfaceContainer,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: isDark
                                        ? AppColors.darkOnBackground
                                        : AppColors.lightOnBackground,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.userName,
                                        style: AppTypography.labelLarge(
                                          color: isDark
                                              ? AppColors.darkOnBackground
                                              : AppColors.lightOnBackground,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                Icons.star_rounded,
                                                color: i < review.rating.toInt()
                                                    ? Colors.amber
                                                    : Colors.grey,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            review.date.toString().split(' ')[0],
                                            style: AppTypography.labelSmall(
                                              color: isDark
                                                  ? AppColors.neutral_500
                                                  : AppColors.neutral_600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review.title,
                              style: AppTypography.labelLarge(
                                color: isDark
                                    ? AppColors.darkOnBackground
                                    : AppColors.lightOnBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.comment,
                              style: AppTypography.bodyMedium(
                                color: isDark
                                    ? AppColors.neutral_400
                                    : AppColors.neutral_600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_outlined,
                                        size: 16,
                                        color: isDark
                                            ? AppColors.neutral_500
                                            : AppColors.neutral_600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${review.helpful}',
                                        style: AppTypography.labelSmall(
                                          color: isDark
                                              ? AppColors.neutral_500
                                              : AppColors.neutral_600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

