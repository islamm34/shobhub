import 'package:flutter/material.dart';

class AppShadows {
  // Subtle shadows for luxury aesthetic
  static const shadow_xs = BoxShadow(
    color: Color(0x0D8B6034),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const shadow_sm = BoxShadow(
    color: Color(0x1A6B4423),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const shadow_md = BoxShadow(
    color: Color(0x1F6B4423),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const shadow_lg = BoxShadow(
    color: Color(0x266B4423),
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  static const shadow_xl = BoxShadow(
    color: Color(0x336B4423),
    blurRadius: 24,
    offset: Offset(0, 12),
  );

  static List<BoxShadow> get elevationXs => [shadow_xs];
  static List<BoxShadow> get elevationSm => [shadow_sm];
  static List<BoxShadow> get elevationMd => [shadow_md];
  static List<BoxShadow> get elevationLg => [shadow_lg];
  static List<BoxShadow> get elevationXl => [shadow_xl];

  // Premium glass effect shadow with brown tone
  static List<BoxShadow> get glassElevation => [
    const BoxShadow(
      color: Color(0x1A6B4423),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x0D92613B),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Premium elevated glass shadow
  static List<BoxShadow> get premiumGlassElevation => [
    const BoxShadow(
      color: Color(0x1F6B4423),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: -1,
    ),
    const BoxShadow(
      color: Color(0x0D92613B),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // Inset shadow for glass effect
  static List<BoxShadow> get glassInset => [
    const BoxShadow(
      color: Color(0x1AFFFFFF),
      blurRadius: 8,
      offset: Offset(0, -1),
      spreadRadius: 0,
    ),
  ];

  // Floating effect shadow
  static List<BoxShadow> get floatingElevation => [
    const BoxShadow(
      color: Color(0x1A4A2C1A),
      blurRadius: 20,
      offset: Offset(0, 10),
      spreadRadius: -2,
    ),
    const BoxShadow(
      color: Color(0x0D92613B),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}

