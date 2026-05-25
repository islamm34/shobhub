import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

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
                child: Center(
                  child: Text(
                    '404',
                    style: AppTypography.displayLarge(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: AppTypography.headline3(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'The page you\'re looking for doesn\'t exist or has been moved',
                style: AppTypography.bodyMedium(
                  color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: 'Go to Home',
                onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

