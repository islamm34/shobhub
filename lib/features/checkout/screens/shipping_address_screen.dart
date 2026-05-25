import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  List<Address> addresses = DummyDataProvider.addresses;
  int selectedAddressId = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Shipping Address',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedAddressId = int.parse(address.id)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      border: Border.all(
                        color: selectedAddressId == int.parse(address.id)
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
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedAddressId == int.parse(address.id)
                                  ? (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                              width: 2,
                            ),
                          ),
                          child: selectedAddressId == int.parse(address.id)
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    address.label,
                                    style: AppTypography.labelLarge(
                                      color: isDark
                                          ? AppColors.darkOnBackground
                                          : AppColors.lightOnBackground,
                                    ),
                                  ),
                                  if (address.isDefault)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Default',
                                        style: AppTypography.labelSmall(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address.name,
                                style: AppTypography.bodySmall(
                                  color: isDark
                                      ? AppColors.darkOnBackground
                                      : AppColors.lightOnBackground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${address.street}, ${address.city}',
                                style: AppTypography.bodySmall(
                                  color: isDark
                                      ? AppColors.neutral_400
                                      : AppColors.neutral_600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            PremiumButton(
              label: 'Add New Address',
              variant: ButtonVariant.outline,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/add-address'),
            ),
            const SizedBox(height: 20),
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
}

