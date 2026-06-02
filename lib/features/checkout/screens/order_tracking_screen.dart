import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            Text(
              'Order #ORD-${DateTime.now().millisecondsSinceEpoch}',
              style: AppTypography.headline3(
                color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Order Placed',
                    subtitle: DateTime.now().toString().split(' ')[0],
                    isCompleted: true,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Processing',
                    subtitle: 'Expected today',
                    isCompleted: false,
                    isActive: true,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Shipped',
                    subtitle: 'Pending',
                    isCompleted: false,
                    isActive: false,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Out for Delivery',
                    subtitle: 'Pending',
                    isCompleted: false,
                    isActive: false,
                  ),
                  _buildTimelineLine(isDark),
                  _buildTimelineStep(
                    isDark: isDark,
                    title: 'Delivered',
                    subtitle: 'Pending',
                    isCompleted: false,
                    isActive: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shipping To',
                              style: AppTypography.labelSmall(
                                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Islam Mohamed, New York, NY 10001',
                              style: AppTypography.bodyMedium(
                                color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tracking Number',
                              style: AppTypography.labelSmall(
                                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              'SHP-${DateTime.now().millisecondsSinceEpoch}',
                              style: AppTypography.bodyMedium(
                                color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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
              onPressed: () => context.pop(),
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
                    ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                    : (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer),
                border: Border.all(
                  color: isCompleted
                      ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
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
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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