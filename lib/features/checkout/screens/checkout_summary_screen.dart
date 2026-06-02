import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class CheckoutSummaryScreen extends ConsumerWidget {
  const CheckoutSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartController = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Order Review',
        showBackButton: true,
      ),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80),
                  const SizedBox(height: 16),
                  Text('Your cart is empty'),
                  const SizedBox(height: 24),
                  PremiumButton(
                    label: 'Start Shopping',
                    onPressed: () => context.go('/home'),
                  ),
                ],
              ),
            );
          }

          final subtotal = cartController.calculateTotal(cartItems);
          final shipping = subtotal > 50 ? 0.0 : 5.0;
          final tax = subtotal * 0.18;
          final total = subtotal + shipping + tax;
          final totalItems = cartController.calculateTotalItems(cartItems);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Items
                Text(
                  'Order Items ($totalItems)',
                  style: AppTypography.headline4(
                    color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => Divider(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                                  child: const Icon(Icons.image),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelLarge(
                                      color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity}',
                                    style: AppTypography.bodySmall(
                                      color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${(item.totalPrice).toStringAsFixed(2)}',
                              style: AppTypography.labelLarge(
                                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Price Summary
                Text(
                  'Price Details',
                  style: AppTypography.headline4(
                    color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow(isDark, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildPriceRow(isDark, 'Shipping', shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildPriceRow(isDark, 'Tax (18%)', '\$${tax.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      const SizedBox(height: 12),
                      _buildPriceRow(
                        isDark,
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // User Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information',
                        style: AppTypography.labelLarge(
                          color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.displayName ?? user?.email ?? 'Guest',
                        style: AppTypography.bodyMedium(
                          color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                        ),
                      ),
                      Text(
                        user?.email ?? 'No email',
                        style: AppTypography.bodySmall(
                          color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PremiumButton(
                  label: 'Place Order',
                  onPressed: () async {
                    // TODO: Save order to Firestore
                    await cartController.clearCart();
                    if (context.mounted) {
                      context.go('/order-success');
                    }
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildPriceRow(bool isDark, String label, String value, {bool isTotal = false}) {
    if (isTotal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.headline4(
              color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
            ),
          ),
          Text(
            value,
            style: AppTypography.headline4(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              weight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium(
            color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium(
            color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
          ),
        ),
      ],
    );
  }
}