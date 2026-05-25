import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final int? productId;
  const ProductDetailScreen({super.key, this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;
  late Future<ProductModel?> _productDetailsFuture;
  int? _productId;

  @override
  void initState() {
    super.initState();
    _productId = widget.productId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    if (_productId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('productId')) {
        _productId = args['productId'] as int;
      } else {
        _productId = 1;
      }
    }
    _productDetailsFuture = ApiService().fetchProductDetails(_productId!);
  }

  void _toggleWishlist(ProductModel product) async {
    final controller = ref.read(wishlistControllerProvider);
    final wishlistItemsAsync = ref.read(wishlistItemsProvider);

    bool isInWishlist = false;
    wishlistItemsAsync.whenData((items) {
      isInWishlist = items.any((item) => item.id == product.id);
    });

    if (isInWishlist) {
      await controller.removeFromWishlist(product.id! as String);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from wishlist'),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      await controller.addToWishlist(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to wishlist'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wishlistItemsAsync = ref.watch(wishlistItemsProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Product Details',
        showBackButton: true,
        actions: [
          FutureBuilder<ProductModel?>(
            future: _productDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final product = snapshot.data!;
                return wishlistItemsAsync.when(
                  data: (wishlistItems) {
                    final isInWishlist = wishlistItems.any((item) => item.id == product.id);
                    return GestureDetector(
                      onTap: () => _toggleWishlist(product),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceContainer
                              : AppColors.lightSurfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist ? AppColors.lightTertiary : null,
                        ),
                      ),
                    );
                  },
                  loading: () => Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.favorite_border),
                  ),
                  error: (_, __) => Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.favorite_border),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.lightSurfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.favorite_border),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<ProductModel?>(
        future: _productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: isDark
                        ? AppColors.neutral_500
                        : AppColors.neutral_600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load product',
                    style: AppTypography.headline3(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PremiumButton(label: 'Retry', onPressed: _loadProductDetails),
                ],
              ),
            );
          }

          final product = snapshot.data!;
          final discountedPrice = product.discountedPrice;
          final savedAmount = product.savedAmount;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: product.images?.length ?? 1,
                      itemBuilder: (context, index) {
                        final imageUrl = product.images?.isNotEmpty == true
                            ? product.images![index]
                            : (product.thumbnail ?? '');
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceContainer
                                : AppColors.lightSurfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: isDark
                                        ? AppColors.neutral_600
                                        : AppColors.neutral_300,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.title ?? 'Product',
                    style: AppTypography.headline3(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: AppTypography.headline2(
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              if (product.discountPercent > 0) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${product.price?.toStringAsFixed(2)}',
                                  style: AppTypography.bodyMedium(
                                    color: isDark
                                        ? AppColors.neutral_400
                                        : AppColors.neutral_600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightError,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${product.discountPercent}%',
                                    style: AppTypography.labelSmall(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (savedAmount > 0)
                            Text(
                              'You save \$${savedAmount.toStringAsFixed(2)}',
                              style: AppTypography.labelSmall(
                                color: Colors.green,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            product.isInStock ? 'In Stock' : 'Out of Stock',
                            style: AppTypography.labelSmall(
                              color: product.isInStock
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed('/product-reviews'),
                            child: Text(
                              '${product.averageRating.toStringAsFixed(1)} (${product.reviewCount} Reviews)',
                              style: AppTypography.labelSmall(
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: AppTypography.headline4(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description ?? 'No description available',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTile(isDark, 'Brand', product.brand ?? 'Unknown'),
                  _buildInfoTile(isDark, 'SKU', product.sku ?? 'N/A'),
                  _buildInfoTile(isDark, 'Weight', '${product.weight}g'),
                  _buildInfoTile(
                    isDark,
                    'Shipping',
                    product.shippingInformation ?? 'Standard shipping',
                  ),
                  _buildInfoTile(
                    isDark,
                    'Warranty',
                    product.warrantyInformation ?? 'No warranty',
                  ),
                  _buildInfoTile(
                    isDark,
                    'Return Policy',
                    product.returnPolicy ?? 'No returns',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quantity',
                    style: AppTypography.headline4(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          if (quantity > 1) quantity--;
                        }),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$quantity',
                        style: AppTypography.headline4(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => setState(() => quantity++),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PremiumButton(
                    label: 'Add to Cart',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added $quantity item(s) to cart',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  PremiumButton(
                    label: 'Buy Now',
                    variant: ButtonVariant.outline,
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/shipping-address'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.labelMedium(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}