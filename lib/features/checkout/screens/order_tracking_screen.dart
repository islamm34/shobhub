import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = DummyDataProvider.orders[0];

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Track Order',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status
            Text(
              'Order ${order.orderNumber}',
              style: AppTypography.headline3(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 20),
            // Timeline
            PremiumCard(
              child: Column(
                children: [
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Order Placed',
                    subtitle: 'Dec 24, 2024',
                    isCompleted: true,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Processing',
                    subtitle: 'Dec 25, 2024',
                    isCompleted: true,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Shipped',
                    subtitle: 'Dec 26, 2024',
                    isCompleted: true,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Out for Delivery',
                    subtitle: 'Dec 27, 2024',
                    isCompleted: false,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Delivered',
                    subtitle: 'Dec 28, 2024',
                    isCompleted: false,
                    isActive: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Shipping Details
            Text(
              'Shipping Details',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shipping To',
                              style: AppTypography.labelSmall(
                                color: isDark
                                    ? AppColors.neutral_400
                                    : AppColors.neutral_600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sarah Anderson, New York, NY 10001',
                              style: AppTypography.bodyMedium(
                                color: isDark
                                    ? AppColors.darkOnBackground
                                    : AppColors.lightOnBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tracking Number',
                              style: AppTypography.labelSmall(
                                color: isDark
                                    ? AppColors.neutral_400
                                    : AppColors.neutral_600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              'SHP-24-12-001-ABC123XYZ',
                              style: AppTypography.bodyMedium(
                                color: isDark
                                    ? AppColors.darkOnBackground
                                    : AppColors.lightOnBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Back to Orders',
              variant: ButtonVariant.outline,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/orders-history'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required bool isDark,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? (isDark
                        ? AppColors.darkSuccess
                        : AppColors.lightSuccess)
                    : (isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightSurfaceContainer),
                border: Border.all(
                  color: isCompleted
                      ? (isDark
                          ? AppColors.darkSuccess
                          : AppColors.lightSuccess)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelLarge(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.labelSmall(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 11, top: 8, bottom: 8),
      child: SizedBox(
        height: 20,
        child: VerticalDivider(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          thickness: 2,
        ),
      ),
    );
  }
}

