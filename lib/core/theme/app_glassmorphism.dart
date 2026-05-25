import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class GlassmorphismEffects {
  /// Premium glass effect backdrop filter
  static BackdropFilter createGlassEffect({
    double blur = 12.0,
  }) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(),
    );
  }

  /// Glass container with blur background
  static BoxDecoration glassContainerDecoration({
    bool isDark = false,
    double opacity = 0.15,
    double blurOpacity = 0.1,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? AppColors.darkGlassBg.withOpacity(opacity)
              : AppColors.lightGlassBg.withOpacity(opacity),
          isDark
              ? Color.lerp(
            AppColors.darkGlassBg,
            Colors.white,
            0.05,
          )!
              .withOpacity(opacity * 0.8)
              : Color.lerp(
            AppColors.lightGlassBg,
            AppColors.lightPrimary,
            0.02,
          )!
              .withOpacity(opacity * 0.8),
        ],
      ),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.08),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Premium floating card decoration with glass effect
  static BoxDecoration premiumGlassCard({
    bool isDark = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? AppColors.darkSurface.withOpacity(0.95)
              : AppColors.lightSurface.withOpacity(0.98),
          isDark
              ? AppColors.darkSurfaceContainer.withOpacity(0.85)
              : AppColors.lightSurfaceContainer.withOpacity(0.9),
        ],
      ),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.12)
            : AppColors.lightPrimary.withOpacity(0.08),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }

  /// Luxury brown gradient for buttons & banners
  static LinearGradient luxuryGradient({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
        const Color(0xFFD4A574),
        const Color(0xFFC4A57B),
        const Color(0xFF92613B),
      ]
          : [
        const Color(0xFF92613B),
        const Color(0xFFB8860B),
        const Color(0xFFC4A57B),
      ],
    );
  }

  /// Warm coffee gradient
  static LinearGradient coffeeGradient({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
        const Color(0xFFD4A574),
        const Color(0xFFC4A57B),
      ]
          : [
        const Color(0xFF92613B),
        const Color(0xFFB8860B),
      ],
    );
  }

  /// Soft beige accent gradient
  static LinearGradient accentGradient({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
        const Color(0xFFF4D9C5),
        const Color(0xFFD4A574),
      ]
          : [
        const Color(0xFFD4A574),
        const Color(0xFFC4A57B),
      ],
    );
  }

  /// Frosted glass button decoration
  static BoxDecoration frostedGlassButton({
    bool isDark = false,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? AppColors.darkPrimary.withOpacity(isPressed ? 0.8 : 0.9)
              : AppColors.lightPrimary.withOpacity(isPressed ? 0.85 : 0.95),
          isDark
              ? AppColors.darkSecondary.withOpacity(isPressed ? 0.7 : 0.8)
              : AppColors.lightSecondary.withOpacity(isPressed ? 0.75 : 0.85),
        ],
      ),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.darkPrimary.withOpacity(0.3)
              : AppColors.lightPrimary.withOpacity(0.2),
          blurRadius: isPressed ? 8 : 12,
          offset: Offset(0, isPressed ? 2 : 4),
          spreadRadius: isPressed ? -2 : -1,
        ),
      ],
    );
  }

  /// Elevated glass card with premium shadow
  static BoxDecoration elevatedGlassCard({
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : AppColors.lightBorder.withOpacity(0.5),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : AppColors.lightPrimary.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.1)
              : AppColors.lightPrimary.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Floating action button style
  static BoxDecoration floatingButtonDecoration({
    bool isDark = false,
  }) {
    return BoxDecoration(
      gradient: luxuryGradient(isDark: isDark),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.darkPrimary.withOpacity(0.4)
              : AppColors.lightPrimary.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: isDark
              ? AppColors.darkSecondary.withOpacity(0.2)
              : AppColors.lightSecondary.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Smooth rounded corner radius for luxury feel
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;

  /// Blur effect for modal background
  static const double backdropBlur = 10.0;

  /// Semi-transparent overlay for modals
  static Color getBackdropOverlayColor({bool isDark = false}) {
    return isDark
        ? Colors.black.withOpacity(0.6)
        : Colors.black.withOpacity(0.4);
  }
}

