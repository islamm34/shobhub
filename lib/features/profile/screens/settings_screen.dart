import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailUpdates = false;
  bool biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            Text(
              'Account',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              isDark: isDark,
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () =>
                  Navigator.of(context).pushNamed('/edit-profile'),
            ),
            _buildSettingsItem(
              isDark: isDark,
              icon: Icons.location_city_outlined,
              title: 'Addresses',
              subtitle: 'Manage your delivery addresses',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            // App Settings
            Text(
              'App Settings',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsToggle(
              isDark: isDark,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Get order updates and offers',
              value: notificationsEnabled,
              onChanged: (value) =>
                  setState(() => notificationsEnabled = value),
            ),
            _buildSettingsToggle(
              isDark: isDark,
              icon: Icons.mail_outline,
              title: 'Email Updates',
              subtitle: 'Receive promotional emails',
              value: emailUpdates,
              onChanged: (value) => setState(() => emailUpdates = value),
            ),
            _buildSettingsToggle(
              isDark: isDark,
              icon: Icons.fingerprint_outlined,
              title: 'Biometric Auth',
              subtitle: 'Use fingerprint to login',
              value: biometricAuth,
              onChanged: (value) => setState(() => biometricAuth = value),
            ),
            const SizedBox(height: 24),
            // About
            Text(
              'About',
              style: AppTypography.headline4(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              isDark: isDark,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Contact support team',
              onTap: () =>
                  Navigator.of(context).pushNamed('/help-support'),
            ),
            _buildSettingsItem(
              isDark: isDark,
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Version 1.0.0',
              onTap: () =>
                  Navigator.of(context).pushNamed('/about-app'),
            ),
            _buildSettingsItem(
              isDark: isDark,
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Read our policies',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Sign Out',
              variant: ButtonVariant.outline,
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/welcome'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall(
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

  Widget _buildSettingsToggle({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon,
              color: isDark
                  ? AppColors.darkOnBackground
                  : AppColors.lightOnBackground),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge(
                    color: isDark
                        ? AppColors.darkOnBackground
                        : AppColors.lightOnBackground,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall(
                    color: isDark
                        ? AppColors.neutral_400
                        : AppColors.neutral_600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDark
                ? AppColors.darkPrimary
                : AppColors.lightPrimary,
          ),
        ],
      ),
    );
  }
}

