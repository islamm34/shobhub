import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedMethod = 'credit_card';
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final cardNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: AppTypography.headline3(
                  color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 20),
              // Payment Options
              _buildPaymentOption(
                isDark: isDark,
                title: 'Credit / Debit Card',
                icon: Icons.credit_card,
                value: 'credit_card',
                selectedValue: selectedMethod,
                onChanged: (value) => setState(() => selectedMethod = value!),
              ),
              if (selectedMethod == 'credit_card') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Card Number',
                  hint: '1234 5678 9012 3456',
                  controller: cardNumberController,
                  prefixIcon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    if (value.replaceAll(' ', '').length < 16) {
                      return 'Invalid card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Expiry Date',
                        hint: 'MM/YY',
                        controller: expiryController,
                        prefixIcon: Icons.calendar_today,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'CVV',
                        hint: '123',
                        controller: cvvController,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 3) {
                            return 'Invalid CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Cardholder Name',
                  hint: 'Name on card',
                  controller: cardNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cardholder name';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              _buildPaymentOption(
                isDark: isDark,
                title: 'PayPal',
                icon: Icons.payment,
                value: 'paypal',
                selectedValue: selectedMethod,
                onChanged: (value) => setState(() => selectedMethod = value!),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                isDark: isDark,
                title: 'Cash on Delivery',
                icon: Icons.money,
                value: 'cod',
                selectedValue: selectedMethod,
                onChanged: (value) => setState(() => selectedMethod = value!),
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Review Order',
                onPressed: () {
                  if (selectedMethod == 'credit_card') {
                    if (_formKey.currentState!.validate()) {
                      final paymentData = {
                        'method': selectedMethod,
                        'cardLast4': cardNumberController.text.replaceAll(' ', '').substring(
                          cardNumberController.text.replaceAll(' ', '').length - 4,
                        ),
                      };
                      context.push('/checkout-summary', extra: paymentData);
                    }
                  } else {
                    final paymentData = {
                      'method': selectedMethod,
                      'methodName': selectedMethod == 'paypal' ? 'PayPal' : 'Cash on Delivery',
                    };
                    context.push('/checkout-summary', extra: paymentData);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required bool isDark,
    required String title,
    required IconData icon,
    required String value,
    required String selectedValue,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedValue == value
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: selectedValue == value ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(title),
        secondary: Icon(icon, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
        value: value,
        groupValue: selectedValue,
        onChanged: onChanged,
        activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      ),
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardNameController.dispose();
    super.dispose();
  }
}