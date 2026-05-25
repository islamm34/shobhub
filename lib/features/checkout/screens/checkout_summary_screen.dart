import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class CheckoutSummaryScreen extends StatelessWidget {
  const CheckoutSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = DummyDataProvider.currentUser;
    final address = DummyDataProvider.addresses[0];
    List<Product> cartItems = DummyDataProvider.products.take(2).toList();

    final subtotal = 549.98;
    final shipping = 50.0;
    final tax = 90.0;
    final total = subtotal + shipping + tax;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Order Review',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Items
            Text(
              'Order Items',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                children: cartItems
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          if (idx < cartItems.length - 1) ...[
                            const SizedBox(height: 12),
                            Divider(
                              color:
                                  isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Price Summary
            Text(
              'Price Details',
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
                        'Subtotal',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.neutral_400
                              : AppColors.neutral_600,
                        ),
                      ),
                      Text(
                        '\$$subtotal',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.neutral_400
                              : AppColors.neutral_600,
                        ),
                      ),
                      Text(
                        '\$$shipping',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.neutral_400
                              : AppColors.neutral_600,
                        ),
                      ),
                      Text(
                        '\$$tax',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 12),
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
                        '\$${total.toStringAsFixed(2)}',
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
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Place Order',
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/order-success'),
            ),
          ],
        ),
      ),
    );
  }
}

