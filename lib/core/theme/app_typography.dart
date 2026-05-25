import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static const String fontFamily = 'SF Pro Display';
  
  // Headline styles
  static TextStyle headline1({
    required Color color,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: weight,
        color: color,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle headline2({
    required Color color,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: weight,
        color: color,
        height: 1.3,
        letterSpacing: -0.3,
      );

  static TextStyle headline3({
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: weight,
        color: color,
        height: 1.3,
        letterSpacing: -0.2,
      );

  static TextStyle headline4({
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  // Display styles
  static TextStyle displayLarge({
    required Color color,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.inter(
        fontSize: 36,
        fontWeight: weight,
        color: color,
        height: 1.2,
        letterSpacing: -0.8,
      );

  // Body styles
  static TextStyle bodyLarge({
    required Color color,
    FontWeight weight = FontWeight.w500,
  }) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({
    required Color color,
    FontWeight weight = FontWeight.w500,
  }) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({
    required Color color,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  // Label styles
  static TextStyle labelLarge({
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight,
        color: color,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight,
        color: color,
        height: 1.5,
        letterSpacing: 0.15,
      );

  static TextStyle labelSmall({
    required Color color,
    FontWeight weight = FontWeight.w500,
  }) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: weight,
        color: color,
        height: 1.5,
        letterSpacing: 0.2,
      );

  // Caption styles
  static TextStyle caption({
    required Color color,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  // Button styles
  static TextStyle button({
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: weight,
        color: color,
        height: 1.3,
        letterSpacing: 0.3,
      );
}

