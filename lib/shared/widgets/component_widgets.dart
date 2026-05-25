import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_glassmorphism.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool useGlassEffect;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;

  const PremiumAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.useGlassEffect = true,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final titleCol = titleColor ??
        (isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: AppShadows.elevationSm,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headline4(color: titleCol),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

class FloatingGlassBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const FloatingGlassBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  State<FloatingGlassBottomNavigationBar> createState() =>
      _FloatingGlassBottomNavigationBarState();
}

class _FloatingGlassBottomNavigationBarState
    extends State<FloatingGlassBottomNavigationBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.items.length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    if (widget.currentIndex < _controllers.length) {
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(FloatingGlassBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      if (oldWidget.currentIndex < _controllers.length) {
        _controllers[oldWidget.currentIndex].reverse();
      }
      if (widget.currentIndex < _controllers.length) {
        _controllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor =
    isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final unselectedColor = isDark ? AppColors.neutral_500 : AppColors.neutral_600;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withOpacity(0.95)
                : AppColors.lightSurface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withOpacity(0.5)
                  : AppColors.lightBorder.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: AppShadows.elevationLg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              widget.items.length,
                  (index) {
                final item = widget.items[index];
                final isSelected = widget.currentIndex == index;

                return GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: AnimatedBuilder(
                    animation: _controllers[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_controllers[index].value * 0.08),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient:
                                  GlassmorphismEffects.luxuryGradient(
                                      isDark: isDark),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: selectedColor.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: IconTheme(
                                    data: const IconThemeData(
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    child: item.icon!,
                                  ),
                                ),
                              )
                            else
                              IconTheme(
                                data: IconThemeData(
                                  color: unselectedColor,
                                  size: 24,
                                ),
                                child: item.icon!,
                              ),
                            if (item.label != null && isSelected) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.label!,
                                style: AppTypography.labelSmall(
                                  color: selectedColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumProductCard extends StatefulWidget {
  final String productName;
  final String productImage;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final String? badge;
  final Color? badgeColor;

  const PremiumProductCard({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.price,
    this.originalPrice = 0,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.badge,
    this.badgeColor,
  }) : super(key: key);

  @override
  State<PremiumProductCard> createState() => _PremiumProductCardState();
}

class _PremiumProductCardState extends State<PremiumProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discountPercentage = widget.originalPrice > 0
        ? ((widget.originalPrice - widget.price) / widget.originalPrice * 100)
        .toInt()
        : 0;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.97)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.elevationMd,
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withOpacity(0.5)
                  : AppColors.lightBorder.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightSurfaceContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Image
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.image,
                            color: isDark
                                ? Colors.grey[600]
                                : Colors.grey[500],
                            size: 40,
                          ),
                        ),
                      ),
                      // Badge
                      if (widget.badge != null)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.badgeColor ??
                                  (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.badge!,
                              style: AppTypography.labelSmall(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // Discount Badge
                      if (discountPercentage > 0)
                        Positioned(
                          top: 12,
                          right: 12,
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
                              '-$discountPercentage%',
                              style: AppTypography.labelSmall(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // Favorite Button
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: widget.onFavoriteTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface)
                                  .withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: AppShadows.elevationSm,
                            ),
                            child: Icon(
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.lightTertiary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Product Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelLarge(
                        color: isDark
                            ? AppColors.darkOnBackground
                            : AppColors.lightOnBackground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.rating}',
                          style: AppTypography.labelSmall(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.reviewCount})',
                          style: AppTypography.labelSmall(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: AppTypography.labelLarge(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            weight: FontWeight.w700,
                          ),
                        ),
                        if (widget.originalPrice > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${widget.originalPrice.toStringAsFixed(2)}',
                            style: AppTypography.labelSmall(
                              color: isDark
                                  ? AppColors.neutral_400
                                  : AppColors.neutral_500,
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
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryCard({
    Key? key,
    required this.categoryName,
    required this.icon,
    this.backgroundColor,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isSelected
            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
            : (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer));

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected ? AppShadows.elevationMd : AppShadows.elevationSm,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground),
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall(
              color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingShimmer({
    Key? key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
              ],
              transform: GradientRotation(_controller.value * 3.14159 * 2),
            ),
          ),
        );
      },
    );
  }
}