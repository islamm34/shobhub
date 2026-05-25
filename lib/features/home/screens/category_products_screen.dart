import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryName;

  const CategoryProductsScreen({
    Key? key,
    required this.categorySlug,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 20;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await ApiService().fetchProductsByCategory(widget.categorySlug);

      if (result != null && result.products.isNotEmpty) {
        setState(() {
          _products = result.products;
          _currentSkip = _limit;
          _hasMore = result.products.length == _limit;
          _isLoading = false;
        });
      } else {
        setState(() {
          _products = [];
          _isLoading = false;
          _hasMore = false;
        });
      }
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await ApiService().fetchProductsByCategory(widget.categorySlug);

      if (result != null && result.products.isNotEmpty) {
        setState(() {
          _products.addAll(result.products);
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
      _products = [];
      _currentSkip = 0;
      _hasMore = true;
      _isLoading = true;
    });
    await _loadProducts();
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
      appBar: PremiumAppBar(
        title: widget.categoryName,
        showBackButton: true,
      ),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${_products.length} products found',
                  style: AppTypography.bodyMedium(
                    color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index >= _products.length) {
                      return const SizedBox();
                    }
                    final product = _products[index];
                    return _buildProductCard(product, isDark);
                  },
                  childCount: _products.length,
                ),
              ),
            ),
            if (_isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                ),
              ),
            if (!_hasMore && _products.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'You\'ve seen all products in ${widget.categoryName}',
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_products.isEmpty && !_isLoading)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 80,
                          color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: AppTypography.headline3(
                            color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No products available in ${widget.categoryName}',
                          style: AppTypography.bodyMedium(
                            color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        PremiumButton(
                          label: 'Browse All Products',
                          onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildProductCard(ProductModel product, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/product-detail',
        arguments: {'productId': product.id ?? 0},
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  children: [
                    Image.network(
                      product.thumbnail ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: isDark ? AppColors.neutral_600 : AppColors.neutral_400,
                          ),
                        );
                      },
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightError,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: AppTypography.labelSmall(color: Colors.white),
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
                      color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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
                          color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: AppTypography.labelSmall(
                          color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
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
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          weight: FontWeight.bold,
                        ),
                      ),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${product.price?.toStringAsFixed(2)}',
                          style: AppTypography.labelSmall(
                            color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                          ),
                        ),
                      ],
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