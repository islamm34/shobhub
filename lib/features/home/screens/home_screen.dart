import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../models/category_model.dart';
import '../../../models/wishlist_item.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';
import 'empty_cart_screen.dart';
import 'empty_wishlist_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentNavIndex = 0;

  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 30;

  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([_loadCategories(), _loadProducts()]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadCategories() async {
    final categories = await ApiService().fetchCategories();
    if (mounted) {
      setState(() {
        _categories = categories;
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      final result = await ApiService().fetchProducts(
        limit: _limit,
        skip: _currentSkip,
      );

      if (result != null && result.products.isNotEmpty) {
        setState(() {
          _allProducts.addAll(result.products);
          _currentSkip += _limit;
          _hasMore = result.products.length == _limit;
        });
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadProducts();

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _allProducts = [];
      _currentSkip = 0;
      _hasMore = true;
    });
    await _loadInitialData();
    ref.invalidate(wishlistItemsProvider);
  }

  void _toggleWishlist(ProductModel product) async {
    final controller = ref.read(wishlistControllerProvider);
    final currentUser = ref.read(currentUserProvider);

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add to wishlist'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      context.push('/login');
      return;
    }

    final wishlistItemsAsync = ref.read(wishlistItemsProvider);
    final wishlistItems = wishlistItemsAsync.valueOrNull ?? [];
    final isInWishlist = wishlistItems.any(
      (item) => item.title == product.title,
    );

    try {
      if (isInWishlist) {
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
    } catch (e) {
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

  void _navigateToSaleProducts() {
    context.push('/sale-products');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final wishlistItemsAsync = ref.watch(wishlistItemsProvider);
    final isLoggedIn = user != null;
    // ✅ إذا لم يكن المستخدم مسجل دخوله، اعرض رسالة
    if (!isLoggedIn) {
      return Scaffold(
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
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You need to login to access this content',
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Go to Login',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        ),
      );
    }
    final dummyUser = DummyDataProvider.currentUser;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          // Home Tab
          RefreshIndicator(
            onRefresh: _refreshData,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  )
                : _buildHomeView(
                    isDark,
                    wishlistItemsAsync.valueOrNull ?? [],
                    user,
                  ),
          ),
          // Categories Tab
          _buildCategoriesView(isDark),
          // Wishlist Tab
          isLoggedIn
              ? wishlistItemsAsync.when(
                  data: (wishlistItems) =>
                      _buildWishlistView(isDark, wishlistItems),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                )
              : _buildLoginRequiredView(isDark, 'Your Wishlist'),
          // Cart Tab
          const CartScreen(),
          // Profile Tab
          _buildProfileView(dummyUser, isDark),
        ],
      ),
      bottomNavigationBar: _buildGlassBottomNavigationBar(isDark),
    );
  }

  Widget _buildLoginRequiredView(bool isDark, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.headline3(
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please login to continue',
            style: AppTypography.bodyMedium(
              color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
            ),
          ),
          const SizedBox(height: 24),
          PremiumButton(
            label: 'Login',
            onPressed: () => context.push('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeView(
    bool isDark,
    List<WishlistItem> wishlistItems,
    firebase_auth.User? user,
  ) {
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDark, user),
                  const SizedBox(height: 20),
                  _buildSearchBar(isDark),
                  const SizedBox(height: 20),
                  _buildBanner(isDark),
                  const SizedBox(height: 24),
                  _buildCategoriesSection(isDark),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Best Sellers', isDark),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.gridCrossAxisCount(context),
                childAspectRatio: ResponsiveHelper.itemAspectRatio(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= _allProducts.length) {
                  return const SizedBox();
                }
                final product = _allProducts[index];
                return _buildProductCard(product, isDark, wishlistItems);
              }, childCount: _allProducts.length),
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
          if (!_hasMore && _allProducts.isNotEmpty)
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
      ),
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    bool isDark,
    List<WishlistItem> wishlistItems,
  ) {
    final isInWishlist = wishlistItems.any((item) => item.id == product.id);

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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
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

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headline4(
            color: isDark
                ? AppColors.darkOnBackground
                : AppColors.lightOnBackground,
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/best-sellers'),
          child: Text(
            'See All',
            style: AppTypography.labelMedium(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, firebase_auth.User? user) {
    final userName =
        user?.displayName ?? user?.email?.split('@').first ?? 'Guest';
    final userEmail = user?.email ?? 'Sign in to continue';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            Text(
              userEmail,
              style: AppTypography.bodySmall(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/notifications'),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkSurfaceContainer
                  : AppColors.lightSurfaceContainer,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.lightSurfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.search,
              color: isDark ? AppColors.neutral_500 : AppColors.neutral_600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search products...',
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_500 : AppColors.neutral_600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Summer Collection',
                  style: AppTypography.headline3(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Up to 40% Off',
                  style: AppTypography.bodyLarge(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _navigateToSaleProducts,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Shop Now',
                      style: AppTypography.labelMedium(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(bool isDark) {
    final displayCategories = _categories.length > 4
        ? _categories.take(4).toList()
        : _categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentNavIndex = 1),
              child: Text(
                'See All',
                style: AppTypography.labelMedium(
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = displayCategories[index];
              return CategoryCard(
                categoryName: category.name ?? 'Category',
                icon: Icons.shopping_bag_rounded,
                onTap: () => context.push(
                  '/category-products',
                  extra: {
                    'category': category.slug ?? '',
                    'categoryName': category.name ?? 'Category',
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesView(bool isDark) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Categories',
              style: AppTypography.headline3(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  onTap: () => context.push(
                    '/category-products',
                    extra: {
                      'category': category.slug ?? '',
                      'categoryName': category.name ?? 'Category',
                    },
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          size: 40,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category.name ?? 'Category',
                          textAlign: TextAlign.center,
                          style: AppTypography.headline4(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistView(bool isDark, List<WishlistItem> wishlistItems) {
    if (wishlistItems.isNotEmpty) {
      return const WishlistScreen();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: AppTypography.headline3(
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding your favorite items',
            style: AppTypography.bodyMedium(
              color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
            ),
          ),
          const SizedBox(height: 24),
          PremiumButton(
            label: 'Start Shopping',
            onPressed: () => setState(() => _currentNavIndex = 0),
          ),
        ],
      ),
    );
  }

  Widget _buildCartView(bool isDark) {
    return const CartScreen();
  }

  Widget _buildGlassBottomNavigationBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isDark ? Colors.black : Colors.white).withOpacity(0.2),
                  (isDark ? Colors.black : Colors.white).withOpacity(0.15),
                ],
              ),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SalomonBottomBar(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
              backgroundColor: Colors.transparent,
              selectedItemColor: isDark
                  ? AppColors.darkPrimary
                  : AppColors.lightPrimary,
              unselectedItemColor: isDark
                  ? AppColors.neutral_500
                  : AppColors.neutral_600,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home_rounded, size: 24),
                  title: const Text(''),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.grid_3x3_rounded, size: 24),
                  title: const Text(''),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.grid_3x3_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.favorite_rounded, size: 24),
                  title: const Text(''),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.shopping_cart_rounded, size: 24),
                  title: const Text(''),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person_rounded, size: 24),
                  title: const Text(''),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(User user, bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: AppTypography.headline3(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  Text(
                    user.email,
                    style: AppTypography.bodySmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              isDark: isDark,
              onTap: () => context.push('/edit-profile'),
            ),
            _buildProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              isDark: isDark,
              onTap: () => context.push('/orders-history'),
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              isDark: isDark,
              onTap: () => context.push('/notifications'),
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              isDark: isDark,
              onTap: () => context.push('/settings'),
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              isDark: isDark,
              onTap: () => context.push('/help-support'),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Sign Out',
              variant: ButtonVariant.outline,
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                if (mounted) {
                  ref.invalidate(wishlistItemsProvider);
                  context.go('/welcome');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppColors.neutral_500 : AppColors.neutral_600,
            ),
          ],
        ),
      ),
    );
  }
}
