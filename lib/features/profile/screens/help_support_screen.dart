import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Help & Support',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help?',
              style: AppTypography.headline3(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              isDark: isDark,
              icon: Icons.question_answer_outlined,
              title: 'FAQs',
              subtitle: 'Find answers to common questions',
            ),
            _buildHelpCard(
              isDark: isDark,
              icon: Icons.mail_outline,
              title: 'Contact Support',
              subtitle: 'Email: support@shophub.com',
            ),
            _buildHelpCard(
              isDark: isDark,
              icon: Icons.phone_outlined,
              title: 'Call Us',
              subtitle: 'Phone: +1 (800) 123-4567',
            ),
            _buildHelpCard(
              isDark: isDark,
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
            ),
            _buildHelpCard(
              isDark: isDark,
              icon: Icons.note_outlined,
              title: 'Return Policy',
              subtitle: 'Learn about returns and refunds',
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Send Feedback',
              variant: ButtonVariant.outline,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
              child: Icon(
                icon,
                color: isDark
                    ? AppColors.darkPrimary
                    : AppColors.lightPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(
                      color: isDark
                          ? AppColors.neutral_400
                          : AppColors.neutral_600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppColors.neutral_500 : AppColors.neutral_600,
            ),
          ],
        ),
      ),
    );
  }
}

