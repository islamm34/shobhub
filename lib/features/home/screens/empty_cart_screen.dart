import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحديث السلة كل مرة تظهر فيها الشاشة
    ref.invalidate(cartItemsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartController = ref.watch(cartControllerProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
              ),
              const SizedBox(height: 24),
              Text(
                'Please Login',
                style: AppTypography.headline2(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Login to view your cart items',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Go to Login',
                onPressed: () => Navigator.of(context).pushNamed('/login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // ✅ التصحيح: استخدام cartItemsAsync.hasValue و cartItemsAsync.value
          if (cartItemsAsync.hasValue && cartItemsAsync.value!.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await cartController.clearCart();
                          if (mounted) {
                            Navigator.pop(context);
                            ref.invalidate(cartItemsProvider);
                          }
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: isDark ? AppColors.darkError : AppColors.lightError,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: AppTypography.headline3(
                      color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some items to get started',
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PremiumButton(
                    label: 'Start Shopping',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }

          final total = cartController.calculateTotal(cartItems);
          final totalItems = cartController.calculateTotalItems(cartItems);

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(cartItemsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item, isDark, cartController);
                    },
                  ),
                ),
              ),
              _buildBottomBar(isDark, total, totalItems),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: isDark ? AppColors.neutral_500 : AppColors.neutral_400),
              const SizedBox(height: 16),
              Text(
                'Failed to load cart',
                style: AppTypography.headline3(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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
                onPressed: () => ref.invalidate(cartItemsProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item, bool isDark, CartController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                  color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                  child: Icon(Icons.image, color: isDark ? AppColors.neutral_500 : AppColors.neutral_400),
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
                      color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${item.discountedPrice.toStringAsFixed(2)}',
                        style: AppTypography.labelLarge(
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          weight: FontWeight.bold,
                        ),
                      ),
                      if (item.discountPercentage > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: AppTypography.labelSmall(
                            color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.lightError,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${item.discountPercentage.toInt()}%',
                            style: AppTypography.labelSmall(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (item.quantity > 1) {
                            controller.updateQuantity(item.productId, item.quantity - 1);
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: AppTypography.headline4(
                          color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          controller.updateQuantity(item.productId, item.quantity + 1);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await controller.removeFromCart(item.productId);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.delete_outline,
                color: isDark ? AppColors.darkError : AppColors.lightError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isDark, double total, int totalItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              Text(
                '$totalItems',
                style: AppTypography.headline4(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTypography.headline4(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping:',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              Text(
                total > 50 ? 'Free' : '\$5.00',
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax (18%):',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              Text(
                '\$${(total * 0.18).toStringAsFixed(2)}',
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price:',
                style: AppTypography.headline4(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                ),
              ),
              Text(
                '\$${(total + (total > 50 ? 0 : 5) + (total * 0.18)).toStringAsFixed(2)}',
                style: AppTypography.headline3(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PremiumButton(
            label: 'Proceed to Checkout',
            onPressed: total > 0 ? () {
              Navigator.of(context).pushNamed('/shipping-address');
            } : () {},
          ),
        ],
      ),
    );
  }
}