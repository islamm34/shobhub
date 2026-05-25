import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.lightSecondary,
        onSecondary: Colors.white,
        tertiary: AppColors.lightTertiary,
        onTertiary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainer: AppColors.lightSurfaceContainer,
        error: AppColors.lightError,
        onError: Colors.white,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightOnBackground,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline4(
          color: AppColors.lightOnBackground,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightOnBackground,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(
          color: AppColors.lightOnBackground,
        ),
        headlineLarge: AppTypography.headline1(
          color: AppColors.lightOnBackground,
        ),
        headlineMedium: AppTypography.headline2(
          color: AppColors.lightOnBackground,
        ),
        headlineSmall: AppTypography.headline3(
          color: AppColors.lightOnBackground,
        ),
        titleLarge: AppTypography.headline4(
          color: AppColors.lightOnBackground,
        ),
        bodyLarge: AppTypography.bodyLarge(
          color: AppColors.lightOnBackground,
        ),
        bodyMedium: AppTypography.bodyMedium(
          color: AppColors.neutral_700,
        ),
        bodySmall: AppTypography.bodySmall(
          color: AppColors.neutral_600,
        ),
        labelLarge: AppTypography.labelLarge(
          color: AppColors.lightOnBackground,
        ),
        labelMedium: AppTypography.labelMedium(
          color: AppColors.neutral_600,
        ),
        labelSmall: AppTypography.labelSmall(
          color: AppColors.neutral_500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightError,
          ),
        ),
        hintStyle: AppTypography.bodyMedium(
          color: AppColors.neutral_500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.button(
            color: Colors.white,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(
            color: AppColors.lightPrimary,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.button(
            color: AppColors.lightPrimary,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          textStyle: AppTypography.button(
            color: AppColors.lightPrimary,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightOnBackground,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 16,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.neutral_500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkSecondary,
        onSecondary: Colors.white,
        tertiary: AppColors.darkTertiary,
        onTertiary: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainer: AppColors.darkSurfaceContainer,
        error: AppColors.darkError,
        onError: AppColors.darkBackground,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnBackground,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline4(
          color: AppColors.darkOnBackground,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkOnBackground,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(
          color: AppColors.darkOnBackground,
        ),
        headlineLarge: AppTypography.headline1(
          color: AppColors.darkOnBackground,
        ),
        headlineMedium: AppTypography.headline2(
          color: AppColors.darkOnBackground,
        ),
        headlineSmall: AppTypography.headline3(
          color: AppColors.darkOnBackground,
        ),
        titleLarge: AppTypography.headline4(
          color: AppColors.darkOnBackground,
        ),
        bodyLarge: AppTypography.bodyLarge(
          color: AppColors.darkOnBackground,
        ),
        bodyMedium: AppTypography.bodyMedium(
          color: AppColors.neutral_300,
        ),
        bodySmall: AppTypography.bodySmall(
          color: AppColors.neutral_400,
        ),
        labelLarge: AppTypography.labelLarge(
          color: AppColors.darkOnBackground,
        ),
        labelMedium: AppTypography.labelMedium(
          color: AppColors.neutral_400,
        ),
        labelSmall: AppTypography.labelSmall(
          color: AppColors.neutral_500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.darkBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.darkBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.darkError,
          ),
        ),
        hintStyle: AppTypography.bodyMedium(
          color: AppColors.neutral_500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.button(
            color: AppColors.darkBackground,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(
            color: AppColors.darkPrimary,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.button(
            color: AppColors.darkPrimary,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTypography.button(
            color: AppColors.darkPrimary,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkOnBackground,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 16,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.neutral_500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
    );
  }
}

