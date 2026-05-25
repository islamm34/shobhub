import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(title: 'Reset Password', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Password',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your new password below',
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: 'New Password',
              hint: 'Enter new password',
              obscureText: true,
              controller: newPasswordController,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Confirm Password',
              hint: 'Confirm password',
              obscureText: true,
              controller: confirmPasswordController,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 12),
            Text(
              'Password must be at least 8 characters long',
              style: AppTypography.labelSmall(
                color: isDark ? AppColors.neutral_500 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'Reset Password',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password reset successfully'),
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
