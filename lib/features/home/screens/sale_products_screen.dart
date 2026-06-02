import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../models/wishlist_item.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

// ✅ Provider محلي لتحديث حالة القلب فوراً
final localWishlistProvider = StateProvider<Set<int>>((ref) => {});

class SaleProductsScreen extends ConsumerStatefulWidget {
  const SaleProductsScreen({super.key});

  @override
  ConsumerState<SaleProductsScreen> createState() => _SaleProductsScreenState();
}

class _SaleProductsScreenState extends ConsumerState<SaleProductsScreen> {
  List<ProductModel> _saleProducts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 20;

  // ✅ مجموعة محلية لتتبع المنتجات المفضلة مؤقتاً
  Set<int> _localWishlist = {};

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadSaleProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ تحميل الـ Wishlist المحلي من الـ Provider
    final savedWishlist = ref.read(wishlistItemsProvider).valueOrNull;
    if (savedWishlist != null) {
      _localWishlist = savedWishlist.map((item) => item.id).toSet();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreSaleProducts();
    }
  }

  Future<void> _loadSaleProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await ApiService().fetchProducts(
        limit: _limit,
        skip: _currentSkip,
      );

      if (result != null && result.products.isNotEmpty) {
        final saleItems = result.products
            .where((p) => (p.discountPercentage ?? 0) > 0)
            .toList();

        setState(() {
          _saleProducts = saleItems;
          _currentSkip += _limit;
          _hasMore = result.products.length == _limit;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      }
    } catch (e) {
      print('Error loading sale products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreSaleProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await ApiService().fetchProducts(
        limit: _limit,
        skip: _currentSkip,
      );

      if (result != null && result.products.isNotEmpty) {
        final newSaleItems = result.products
            .where((p) => (p.discountPercentage ?? 0) > 0)
            .toList();

        setState(() {
          _saleProducts.addAll(newSaleItems);
          _currentSkip += _limit;
          _hasMore = result.products.length == _limit;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _hasMore = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _saleProducts = [];
      _currentSkip = 0;
      _hasMore = true;
      _isLoading = true;
    });
    await _loadSaleProducts();
  }

  void _toggleWishlist(ProductModel product) async {
    final controller = ref.read(wishlistControllerProvider);
    final isCurrentlyInWishlist = _localWishlist.contains(product.id);

    // ✅ تحديث الواجهة فوراً (تغيير لون القلب)
    setState(() {
      if (isCurrentlyInWishlist) {
        _localWishlist.remove(product.id);
      } else {
        _localWishlist.add(product.id!);
      }
    });

    try {
      if (isCurrentlyInWishlist) {
        await controller.removeFromWishlist(product.title!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from wishlist'),
              backgroundColor: Colors.grey,
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        await controller.addToWishlist(product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to wishlist'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
      // ✅ تحديث الـ Provider الخلفي (اختياري، في الخلفية)
      ref.invalidate(wishlistItemsProvider);
    } catch (e) {
      // ✅ في حالة الخطأ، نرجع الحالة السابقة
      setState(() {
        if (isCurrentlyInWishlist) {
          _localWishlist.add(product.id!);
        } else {
          _localWishlist.remove(product.id);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(title: 'Summer Sale', showBackButton: true),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightError,
                      AppColors.lightTertiary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_offer,
                        color: AppColors.lightError,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summer Sale!',
                            style: AppTypography.headline3(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get up to 40% off on selected items',
                            style: AppTypography.bodyMedium(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${_saleProducts.length} products on sale',
                  style: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.neutral_400
                        : AppColors.neutral_600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= _saleProducts.length) {
                    return const SizedBox();
                  }
                  final product = _saleProducts[index];
                  return _buildProductCard(product, isDark);
                }, childCount: _saleProducts.length),
              ),
            ),
            if (_isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),
              ),
            if (!_hasMore && _saleProducts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'You\'ve seen all sale products',
                      style: AppTypography.bodySmall(
                        color: isDark
                            ? AppColors.neutral_400
                            : AppColors.neutral_600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_saleProducts.isEmpty && !_isLoading)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 80,
                          color: isDark
                              ? AppColors.neutral_500
                              : AppColors.neutral_400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products on sale',
                          style: AppTypography.headline3(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for amazing deals',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PremiumButton(
                          label: 'Browse All Products',
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      ProductModel product,
      bool isDark,
      ) {
    // ✅ استخدام الحالة المحلية لتحديد لون القلب
    final isInWishlist = _localWishlist.contains(product.id);
    final discountPercent = product.discountPercent;

    return GestureDetector(
      onTap: () => context.push(
        '/product-detail',
        extra: product.id ?? 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      product.thumbnail ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark
                              ? AppColors.darkSurfaceContainer
                              : AppColors.lightSurfaceContainer,
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: isDark
                                ? AppColors.neutral_600
                                : AppColors.neutral_400,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightError,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-$discountPercent%',
                          style: AppTypography.labelSmall(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _toggleWishlist(product),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: isInWishlist ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'Product',
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
                      Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product.averageRating.toStringAsFixed(1)}',
                        style: AppTypography.labelSmall(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
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
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: AppTypography.labelLarge(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${product.price?.toStringAsFixed(2)}',
                        style: AppTypography.labelSmall(
                          color: isDark
                              ? AppColors.neutral_400
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
      ),
    );
  }
}