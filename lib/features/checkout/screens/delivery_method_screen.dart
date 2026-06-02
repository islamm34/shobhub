import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class DeliveryMethodScreen extends StatefulWidget {
  const DeliveryMethodScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  String selectedMethod = 'standard';
  final List<Map<String, dynamic>> methods = [
    {'id': 'standard', 'name': 'Standard Delivery', 'days': '5-7 business days', 'price': 5.00},
    {'id': 'express', 'name': 'Express Delivery', 'days': '2-3 business days', 'price': 12.00},
    {'id': 'overnight', 'name': 'Overnight Delivery', 'days': '1 business day', 'price': 25.00},
  ];

  double get selectedPrice {
    final method = methods.firstWhere((m) => m['id'] == selectedMethod);
    return method['price'] as double;
  }

  String get selectedMethodName {
    final method = methods.firstWhere((m) => m['id'] == selectedMethod);
    return method['name'] as String;
  }

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
              'Choose Delivery Method',
              style: AppTypography.headline3(
                color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your preferred shipping option',
              style: AppTypography.bodyMedium(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 20),
            ...methods.map((method) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedMethod == method['id']
                      ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: selectedMethod == method['id'] ? 2 : 1,
                ),
              ),
              child: RadioListTile<String>(
                title: Text(
                  method['name'],
                  style: AppTypography.labelLarge(
                    color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                  ),
                ),
                subtitle: Text(
                  method['days'],
                  style: AppTypography.bodySmall(
                    color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                  ),
                ),
                secondary: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${method['price'].toStringAsFixed(2)}',
                      style: AppTypography.labelLarge(
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                value: method['id'],
                groupValue: selectedMethod,
                onChanged: (value) => setState(() => selectedMethod = value!),
                activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            )),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Fee',
                    style: AppTypography.bodyLarge(
                      color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                    ),
                  ),
                  Text(
                    '\$${selectedPrice.toStringAsFixed(2)}',
                    style: AppTypography.headline4(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'Continue to Checkout',
              onPressed: () {
                final deliveryData = {
                  'method': selectedMethod,
                  'methodName': selectedMethodName,
                  'price': selectedPrice,
                  'days': methods.firstWhere((m) => m['id'] == selectedMethod)['days'],
                };
                context.push('/checkout-summary', extra: deliveryData);
              },
            ),
          ],
        ),
      ),
    );
  }
}