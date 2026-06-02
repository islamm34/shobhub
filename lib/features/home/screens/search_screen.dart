import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../models/category_model.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;

  const SearchScreen({super.key, this.initialCategory, String? category});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<ProductModel> searchResults = [];
  List<CategoryModel> categories = [];
  List<String> recentSearches = [];
  List<String> selectedFilters = [];
  bool showResults = false;
  bool isLoading = false;
  String? selectedCategory;

  // تحميل لانهائي
  List<ProductModel> _allProducts = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 20;
  late ScrollController _scrollController;

  bool _isCategoryMode =
      true; // true: عرض منتجات التصنيف, false: عرض نتائج البحث

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadCategories();
    _loadRecentSearches();

    if (widget.initialCategory != null) {
      selectedCategory = widget.initialCategory;
      _isCategoryMode = true;
      _loadProductsByCategory(widget.initialCategory!);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isCategoryMode && !_isLoadingMore && _hasMore) {
        _loadMoreProductsByCategory();
      }
    }
  }

  Future<void> _loadRecentSearches() async {
    // تحميل عمليات البحث السابقة من SharedPreferences (يمكن إضافته لاحقاً)
    setState(() {
      recentSearches = ['Headphones', 'Watch', 'Shoes', 'Laptop', 'Phone'];
    });
  }

  Future<void> _loadCategories() async {
    final cats = await ApiService().fetchCategories();
    if (mounted) {
      setState(() {
        categories = cats;
      });
    }
  }

  Future<void> _loadProductsByCategory(String categorySlug) async {
    setState(() {
      _isCategoryMode = true;
      isLoading = true;
      _allProducts = [];
      _currentSkip = 0;
      _hasMore = true;
      showResults = true;
    });

    try {
      final result = await ApiService().fetchProductsByCategory(categorySlug);
      if (mounted) {
        setState(() {
          _allProducts = result?.products ?? [];
          _hasMore = (result?.products.length ?? 0) == _limit;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading products by category: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProductsByCategory() async {
    if (_isLoadingMore || !_hasMore || selectedCategory == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentSkip += _limit;
      final result = await ApiService().fetchProductsByCategory(
        selectedCategory!,
      );

      if (result != null && result.products.isNotEmpty) {
        setState(() {
          _allProducts.addAll(result.products);
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

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        showResults = false;
        searchResults = [];
        _isCategoryMode = false;
      });
      return;
    }

    setState(() {
      _isCategoryMode = false;
      isLoading = true;
      showResults = true;
    });

    try {
      final result = await ApiService().searchProducts(query);
      if (mounted) {
        setState(() {
          searchResults = result?.products ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onCategoryTap(CategoryModel category) {
    setState(() {
      selectedCategory = category.slug;
      searchController.clear();
    });
    _loadProductsByCategory(category.slug!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(title: 'Search Products', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark
                              ? AppColors.neutral_500
                              : AppColors.neutral_600,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchController.clear();
                                    showResults = false;
                                    searchResults = [];
                                    _isCategoryMode = false;
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: isDark
                                      ? AppColors.neutral_500
                                      : AppColors.neutral_600,
                                ),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _performSearch(value);
                        } else {
                          setState(() {
                            showResults = false;
                            _isCategoryMode = false;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categories Row (أيقونات التصنيفات)
                  if (categories.isNotEmpty && !showResults)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse Categories',
                          style: AppTypography.headline4(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length > 8
                                ? 8
                                : categories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return _buildCategoryItem(category, isDark);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Filter Chips
                  if (showResults && !_isCategoryMode)
                    Wrap(
                      spacing: 8,
                      children: ['On Sale', 'Premium', 'Trending']
                          .map(
                            (filter) => PremiumChip(
                              label: filter,
                              isSelected: selectedFilters.contains(filter),
                              onTap: () => setState(() {
                                if (selectedFilters.contains(filter)) {
                                  selectedFilters.remove(filter);
                                } else {
                                  selectedFilters.add(filter);
                                }
                              }),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
            Expanded(
              child: !showResults
                  ? _buildRecentSearches(isDark)
                  : _buildResults(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category, bool isDark) {
    final isSelected = selectedCategory == category.slug;

    return GestureDetector(
      onTap: () => _onCategoryTap(category),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        isDark
                            ? AppColors.darkSecondary
                            : AppColors.lightSecondary,
                      ],
                    )
                  : null,
              color: !isSelected
                  ? (isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightSurfaceContainer)
                  : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1,
              ),
            ),
            child: Icon(
              _getCategoryIcon(category.name ?? ''),
              size: 32,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              category.name?.split(' ').first ?? 'Category',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall(
                color: isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('phone') || name.contains('smartphone')) {
      return Icons.smartphone;
    } else if (name.contains('beauty')) {
      return Icons.spa;
    } else if (name.contains('furniture')) {
      return Icons.weekend;
    } else if (name.contains('fragrance') || name.contains('perfume')) {
      return Icons.emoji_emotions;
    } else if (name.contains('groceries')) {
      return Icons.local_grocery_store;
    } else if (name.contains('laptop') || name.contains('electronics')) {
      return Icons.laptop;
    } else if (name.contains('sport')) {
      return Icons.sports_soccer;
    } else if (name.contains('clothing')) {
      return Icons.checkroom;
    } else {
      return Icons.category;
    }
  }

  Widget _buildRecentSearches(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: AppTypography.headline4(
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
          ),
          const SizedBox(height: 12),
          if (recentSearches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No recent searches',
                  style: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.neutral_400
                        : AppColors.neutral_600,
                  ),
                ),
              ),
            )
          else
            Column(
              children: recentSearches
                  .map(
                    (search) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 18,
                            color: isDark
                                ? AppColors.neutral_500
                                : AppColors.neutral_600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                searchController.text = search;
                                _performSearch(search);
                              },
                              child: Text(
                                search,
                                style: AppTypography.bodyMedium(
                                  color: isDark
                                      ? AppColors.darkOnBackground
                                      : AppColors.lightOnBackground,
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: isDark
                                ? AppColors.neutral_500
                                : AppColors.neutral_600,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 24),
          Text(
            'Popular Categories',
            style: AppTypography.headline4(
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories
                .take(6)
                .map(
                  (category) => PremiumChip(
                    label: category.name ?? 'Category',
                    onTap: () => _onCategoryTap(category),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(bool isDark) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      );
    }

    final displayProducts = _isCategoryMode ? _allProducts : searchResults;
    final isEmpty = displayProducts.isEmpty;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _isCategoryMode
                  ? '${displayProducts.length} products found in ${selectedCategory ?? "this category"}'
                  : '${displayProducts.length} results found',
              style: AppTypography.bodyMedium(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
          ),
        ),
        if (isEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: isDark
                          ? AppColors.neutral_500
                          : AppColors.neutral_400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: AppTypography.headline4(
                        color: isDark
                            ? AppColors.darkOnBackground
                            : AppColors.lightOnBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try searching with different keywords',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.neutral_400
                            : AppColors.neutral_600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PremiumButton(
                      label: 'Browse Categories',
                      onPressed: () {
                        setState(() {
                          showResults = false;
                          _isCategoryMode = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= displayProducts.length) {
                  return const SizedBox();
                }
                final product = displayProducts[index];
                return _buildProductCard(product, isDark);
              }, childCount: displayProducts.length),
            ),
          ),
        if (_isCategoryMode && _isLoadingMore)
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
        if (_isCategoryMode && !_hasMore && _allProducts.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'You\'ve seen all products',
                  style: AppTypography.bodySmall(
                    color: isDark
                        ? AppColors.neutral_400
                        : AppColors.neutral_600,
                  ),
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/product-detail', extra: product.id ?? 0),
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
                    if (product.discountPercent > 0)
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
                            '-${product.discountPercent}%',
                            style: AppTypography.labelSmall(
                              color: Colors.white,
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
                      if (product.discountPercent > 0) ...[
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

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
