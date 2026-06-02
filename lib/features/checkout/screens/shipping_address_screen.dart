import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';
import '../../../models/address_model.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  List<AddressModel> addresses = [];
  int? selectedAddressId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => isLoading = true);
    // TODO: Load addresses from Firestore
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      addresses = [
        AddressModel(
          id: '1',
          label: 'Home',
          name: 'Islam Mohamed',
          phone: '+1 (555) 123-4567',
          street: '123 Oak Street, Apt 4B',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          isDefault: true,
        ),
      ];
      selectedAddressId = 1;
      isLoading = false;
    });
  }

  // ✅ دالة للتنقل إلى الدفع
  void _continueToPayment() {
    if (selectedAddressId != null) {
      final selectedAddress = addresses.firstWhere(
            (a) => int.parse(a.id!) == selectedAddressId,
      );
      context.push('/payment-method', extra: selectedAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(title: 'Shipping Address', showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (addresses.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 64,
                      color: isDark ? AppColors.neutral_500 : AppColors.neutral_400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Addresses Found',
                      style: AppTypography.headline3(
                        color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first shipping address',
                      style: AppTypography.bodyMedium(
                        color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final isSelected = selectedAddressId == int.parse(address.id!);
                  return GestureDetector(
                    onTap: () => setState(
                          () => selectedAddressId = int.parse(address.id!),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        border: Border.all(
                          color: isSelected
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
                                color: isSelected
                                    ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                    : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                                width: 2,
                              ),
                            ),
                            child: isSelected
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
                                      address.label ?? 'Home',
                                      style: AppTypography.labelLarge(
                                        color: isDark
                                            ? AppColors.darkOnBackground
                                            : AppColors.lightOnBackground,
                                      ),
                                    ),
                                    if (address.isDefault == true)
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
                                  address.name ?? '',
                                  style: AppTypography.bodySmall(
                                    color: isDark
                                        ? AppColors.darkOnBackground
                                        : AppColors.lightOnBackground,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  address.fullAddress,
                                  style: AppTypography.bodySmall(
                                    color: isDark
                                        ? AppColors.neutral_400
                                        : AppColors.neutral_600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                            ),
                            onPressed: () {
                              // TODO: Edit address
                            },
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
              onPressed: () async {
                final result = await context.push('/add-address');
                if (result == true) {
                  _loadAddresses();
                }
              },
            ),
            const SizedBox(height: 20),
            PremiumButton(
              label: 'Continue to Payment',
              onPressed: _continueToPayment, // ✅ استخدام دالة عادية بدلاً من conditional
            ),
          ],
        ),
      ),
    );
  }
}