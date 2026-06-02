import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to ShopHub',
      description: 'Discover amazing products from top brands with incredible deals',
      icon: Icons.shopping_bag_rounded,
      color1: 0xFF6366F1,
      color2: 0xFF8B5CF6,
    ),
    OnboardingPage(
      title: 'Fast & Secure Checkout',
      description: 'Experience seamless shopping with multiple payment options',
      icon: Icons.security_rounded,
      color1: 0xFF8B5CF6,
      color2: 0xFFEC4899,
    ),
    OnboardingPage(
      title: 'Track Your Orders',
      description: 'Get real-time updates on your purchases and deliveries',
      icon: Icons.local_shipping_rounded,
      color1: 0xFFEC4899,
      color2: 0xFFF97316,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: pages[index]);
            },
          ),
          // Dots Indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  dotColor: isDark ? AppColors.neutral_600 : AppColors.neutral_300,
                  activeDotColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),
            ),
          ),
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: PremiumButton(
                          label: 'Back',
                          variant: ButtonVariant.outline,
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 12),
                    Expanded(
                      child: PremiumButton(
                        label: _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                        onPressed: () {
                          if (_currentPage == pages.length - 1) {
                            // ✅ استخدام GoRouter للتنقل
                            context.go('/welcome');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final int color1;
  final int color2;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color1,
    required this.color2,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(page.color1),
                    Color(page.color2),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                page.icon,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: AppTypography.headline2(
                color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}