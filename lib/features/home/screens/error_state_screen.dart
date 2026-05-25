import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';

class ErrorStateScreen extends StatelessWidget {
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorStateScreen({
    Key? key,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.lightSurfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 60,
                  color: AppColors.lightError,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                errorTitle ?? 'Something Went Wrong',
                style: AppTypography.headline3(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage ?? 'An unexpected error occurred. Please try again.',
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Retry',
                onPressed: onRetry ?? () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              PremiumButton(
                label: 'Go Back',
                variant: ButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

