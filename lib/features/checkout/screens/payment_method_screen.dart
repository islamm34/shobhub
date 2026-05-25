import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPayment = 'card';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Payment Method',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 16),
            // Credit Card
            GestureDetector(
              onTap: () => setState(() => selectedPayment = 'card'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border.all(
                    color: selectedPayment == 'card'
                        ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.credit_card),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit Card',
                            style: AppTypography.labelLarge(
                              color: isDark
                                  ? AppColors.darkOnBackground
                                  : AppColors.lightOnBackground,
                            ),
                          ),
                          Text(
                            'Visa, Mastercard, etc.',
                            style: AppTypography.bodySmall(
                              color: isDark
                                  ? AppColors.neutral_400
                                  : AppColors.neutral_600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedPayment == 'card'
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                          width: 2,
                        ),
                      ),
                      child: selectedPayment == 'card'
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Digital Wallet
            GestureDetector(
              onTap: () => setState(() => selectedPayment = 'wallet'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border.all(
                    color: selectedPayment == 'wallet'
                        ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance_wallet),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Digital Wallet',
                            style: AppTypography.labelLarge(
                              color: isDark
                                  ? AppColors.darkOnBackground
                                  : AppColors.lightOnBackground,
                            ),
                          ),
                          Text(
                            'Apple Pay, Google Pay',
                            style: AppTypography.bodySmall(
                              color: isDark
                                  ? AppColors.neutral_400
                                  : AppColors.neutral_600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedPayment == 'wallet'
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                          width: 2,
                        ),
                      ),
                      child: selectedPayment == 'wallet'
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Bank Transfer
            GestureDetector(
              onTap: () => setState(() => selectedPayment = 'bank'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border.all(
                    color: selectedPayment == 'bank'
                        ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Transfer',
                            style: AppTypography.labelLarge(
                              color: isDark
                                  ? AppColors.darkOnBackground
                                  : AppColors.lightOnBackground,
                            ),
                          ),
                          Text(
                            'Direct bank transfer',
                            style: AppTypography.bodySmall(
                              color: isDark
                                  ? AppColors.neutral_400
                                  : AppColors.neutral_600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedPayment == 'bank'
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                          width: 2,
                        ),
                      ),
                      child: selectedPayment == 'bank'
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Review Order',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/checkout-summary'),
            ),
          ],
        ),
      ),
    );
  }
}

