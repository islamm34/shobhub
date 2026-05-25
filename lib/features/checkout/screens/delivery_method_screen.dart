import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class DeliveryMethodScreen extends StatefulWidget {
  const DeliveryMethodScreen({super.key});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  String selectedDelivery = 'standard';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Delivery Method',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Delivery Method',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 16),
            // Standard Delivery
            _buildDeliveryOption(
              isDark: isDark,
              title: 'Standard Delivery',
              subtitle: 'Delivery in 5-7 business days',
              price: 'FREE',
              isSelected: selectedDelivery == 'standard',
              onTap: () => setState(() => selectedDelivery = 'standard'),
            ),
            const SizedBox(height: 12),
            // Express Delivery
            _buildDeliveryOption(
              isDark: isDark,
              title: 'Express Delivery',
              subtitle: 'Delivery in 2-3 business days',
              price: '\$9.99',
              isSelected: selectedDelivery == 'express',
              onTap: () => setState(() => selectedDelivery = 'express'),
            ),
            const SizedBox(height: 12),
            // Overnight Delivery
            _buildDeliveryOption(
              isDark: isDark,
              title: 'Overnight Delivery',
              subtitle: 'Delivery by next business day',
              price: '\$19.99',
              isSelected: selectedDelivery == 'overnight',
              onTap: () => setState(() => selectedDelivery = 'overnight'),
            ),
            const SizedBox(height: 12),
            // Scheduled Delivery
            _buildDeliveryOption(
              isDark: isDark,
              title: 'Scheduled Delivery',
              subtitle: 'Choose delivery date & time',
              price: '\$4.99',
              isSelected: selectedDelivery == 'scheduled',
              onTap: () => setState(() => selectedDelivery = 'scheduled'),
            ),
            const SizedBox(height: 32),
            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Delivery charges will be calculated at checkout based on your location.',
                      style: AppTypography.bodySmall(
                        color: isDark
                            ? AppColors.darkOnBackground
                            : AppColors.lightOnBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'Continue to Payment',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/payment-method'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption({
    required bool isDark,
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: AppTypography.labelLarge(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

