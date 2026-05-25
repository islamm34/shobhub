import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'About App',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    isDark
                        ? AppColors.darkSecondary
                        : AppColors.lightSecondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ShopHub',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'v${AppConstants.appVersion}',
              style: AppTypography.labelLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 24),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Us',
                    style: AppTypography.headline4(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ShopHub is your premium destination for online shopping. We bring together the best products from trusted brands at unbeatable prices.\n\nOur mission is to provide an exceptional shopping experience with world-class customer service.',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: AppTypography.headline4(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(isDark, '✓ Fast & Secure Checkout'),
                  _buildFeatureItem(isDark, '✓ Real-time Order Tracking'),
                  _buildFeatureItem(isDark, '✓ 24/7 Customer Support'),
                  _buildFeatureItem(isDark, '✓ Easy Returns & Refunds'),
                  _buildFeatureItem(isDark, '✓ Multiple Payment Options'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: AppTypography.headline4(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    isDark,
                    Icons.mail_outline,
                    'Email: info@shophub.com',
                  ),
                  _buildContactItem(
                    isDark,
                    Icons.phone_outlined,
                    'Phone: +1 (800) 123-4567',
                  ),
                  _buildContactItem(
                    isDark,
                    Icons.language,
                    'Website: www.shophub.com',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(bool isDark, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        feature,
        style: AppTypography.bodyMedium(
          color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
        ),
      ),
    );
  }

  Widget _buildContactItem(bool isDark, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark
                ? AppColors.darkPrimary
                : AppColors.lightPrimary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTypography.bodyMedium(
              color: isDark
                  ? AppColors.neutral_400
                  : AppColors.neutral_600,
            ),
          ),
        ],
      ),
    );
  }
}

