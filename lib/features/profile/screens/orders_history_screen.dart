import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = DummyDataProvider.orders;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'My Orders',
        showBackButton: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed('/order-details'),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderNumber,
                        style: AppTypography.labelLarge(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: order.status == 'Delivered'
                              ? AppColors.lightSuccess.withOpacity(0.2)
                              : order.status == 'Shipped'
                                  ? AppColors.lightTertiary.withOpacity(0.2)
                                  : AppColors.lightWarning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order.status,
                          style: AppTypography.labelSmall(
                            color: order.status == 'Delivered'
                                ? AppColors.lightSuccess
                                : order.status == 'Shipped'
                                    ? AppColors.lightTertiary
                                    : AppColors.lightWarning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${order.itemCount} items - \$${order.total}',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Placed on ${order.date.toString().split(' ')[0]}',
                    style: AppTypography.labelSmall(
                      color: isDark
                          ? AppColors.neutral_500
                          : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: PremiumButton(
                          label: 'View Details',
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/order-details'),
                        ),
                      ),
                      if (order.status != 'Delivered') ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: PremiumButton(
                            label: 'Track',
                            variant: ButtonVariant.outline,
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/order-tracking'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

