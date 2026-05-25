import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  String selectedLabel = 'Home';
  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Add Address',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Selection
            Text(
              'Address Label',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Home', 'Work', 'Other']
                  .map((label) => PremiumChip(
                        label: label,
                        isSelected: selectedLabel == label,
                        onTap: () =>
                            setState(() => selectedLabel = label),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            // Form Fields
            CustomTextField(
              label: 'Full Name',
              hint: 'Enter recipient name',
              controller: nameController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Phone Number',
              hint: 'Enter phone number',
              keyboardType: TextInputType.phone,
              controller: phoneController,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Street Address',
              hint: 'Enter street address',
              controller: streetController,
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'City',
                    hint: 'City',
                    controller: cityController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'State',
                    hint: 'State',
                    controller: stateController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    label: 'Zip Code',
                    hint: 'Zip Code',
                    controller: zipCodeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => isDefault = !isDefault),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDefault
                            ? (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: isDefault
                          ? (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          : Colors.transparent,
                    ),
                    child: isDefault
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Set as default address',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'Save Address',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Address added successfully'),
                    backgroundColor: isDark
                        ? AppColors.darkSuccess
                        : AppColors.lightSuccess,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}

