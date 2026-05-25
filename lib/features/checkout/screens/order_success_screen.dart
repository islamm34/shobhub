import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightSuccess,
                        isDark
                            ? AppColors.darkSuccess
                            : AppColors.lightSuccess,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: AppTypography.headline2(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your order has been confirmed and will be shipped soon.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
              ),
              const SizedBox(height: 32),
              // Order Details
              PremiumCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Number',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_600,
                          ),
                        ),
                        Text(
                          '#ORD-2024-001',
                          style: AppTypography.labelLarge(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                            weight: FontWeight.bold,
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
                          'Estimated Delivery',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_600,
                          ),
                        ),
                        Text(
                          'Dec 28, 2024',
                          style: AppTypography.labelLarge(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                            weight: FontWeight.bold,
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
                          'Total Amount',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_600,
                          ),
                        ),
                        Text(
                          '\$689.98',
                          style: AppTypography.headline4(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Track Order',
                onPressed: () =>
                    Navigator.of(context).pushNamed('/order-tracking'),
              ),
              const SizedBox(height: 12),
              PremiumButton(
                label: 'Continue Shopping',
                variant: ButtonVariant.outline,
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

