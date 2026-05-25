import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Forgot Password',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Your Password',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email to receive instructions',
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 32),
            if (currentStep == 0) ...[
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Send Reset Link',
                onPressed: () {
                  setState(() => currentStep = 1);
                },
              ),
            ] else if (currentStep == 1) ...[
              // OTP Screen placeholder
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                      ),
                      child: Icon(
                        Icons.mark_email_read_outlined,
                        size: 40,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Check Your Email',
                      style: AppTypography.headline3(
                        color: isDark
                            ? AppColors.darkOnBackground
                            : AppColors.lightOnBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ve sent a password reset link to ${emailController.text}',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(
                        color:
                            isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    PremiumButton(
                      label: 'Open Email App',
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/reset-password'),
                    ),
                    const SizedBox(height: 12),
                    PremiumButton(
                      label: 'Back to Login',
                      variant: ButtonVariant.outline,
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/login'),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Didn't receive email? ",
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.neutral_400
                              : AppColors.neutral_600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Resend',
                            style: AppTypography.bodyMedium(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

