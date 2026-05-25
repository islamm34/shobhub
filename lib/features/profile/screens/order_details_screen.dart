import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = DummyDataProvider.orders[0];
    final address = DummyDataProvider.addresses[0];

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Order Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number & Status
            PremiumCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: AppTypography.labelLarge(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.date.toString().split(' ')[0],
                        style: AppTypography.labelSmall(
                          color: isDark
                              ? AppColors.neutral_400
                              : AppColors.neutral_600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightSuccess.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.status,
                      style: AppTypography.labelSmall(
                        color: AppColors.lightSuccess,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Items
            Text(
              'Items',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                children: order.items
                    .asMap()
                    .entries
                    .map((entry) {
                      int idx = entry.key;
                      Product product = entry.value;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceContainer
                                      : AppColors.lightSurfaceContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.image),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelLarge(
                                        color: isDark
                                            ? AppColors.darkOnBackground
                                            : AppColors.lightOnBackground,
                                      ),
                                    ),
                                    Text(
                                      'Qty: 1',
                                      style: AppTypography.bodySmall(
                                        color: isDark
                                            ? AppColors.neutral_400
                                            : AppColors.neutral_600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${product.price}',
                                style: AppTypography.labelLarge(
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (idx < order.items.length - 1) ...[
                            const SizedBox(height: 12),
                            Divider(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Shipping Address
            Text(
              'Shipping Address',
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
                  Text(
                    address.name,
                    style: AppTypography.labelLarge(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.street,
                    style: AppTypography.bodySmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                  Text(
                    '${address.city}, ${address.state} ${address.zipCode}',
                    style: AppTypography.bodySmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${address.phone}',
                    style: AppTypography.labelSmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Price Summary
            Text(
              'Price Summary',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTypography.headline4(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                      Text(
                        '\$${order.total}',
                        style: AppTypography.headline4(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

