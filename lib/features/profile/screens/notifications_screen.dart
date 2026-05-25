import 'package:flutter/material.dart' hide Notification;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notification> notifications = DummyDataProvider.notifications;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Notifications',
        showBackButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                child: Text(
                  'Mark All as Read',
                  style: AppTypography.labelSmall(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            child: PremiumCard(
              backgroundColor: !notification.isRead
                  ? (isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface)
                      .withOpacity(0.8)
                  : null,
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
                    child: Icon(notification.icon as IconData?, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: AppTypography.labelLarge(
                                  color: isDark
                                      ? AppColors.darkOnBackground
                                      : AppColors.lightOnBackground,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall(
                            color: isDark
                                ? AppColors.neutral_400
                                : AppColors.neutral_600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.date.toString().split(' ')[0],
                          style: AppTypography.labelSmall(
                            color: isDark
                                ? AppColors.neutral_500
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
    );
  }
}

