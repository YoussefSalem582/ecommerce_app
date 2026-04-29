import 'package:flutter/material.dart';

/// Brand palette constants — referenced by [ThemeExtension]s, not scattered hex values.
abstract final class AppColors {
  /// Primary brand blue (light surfaces).
  static const primary = Color(0xFF1565C0);

  /// Accent orange for CTAs.
  static const accent = Color(0xFFFF6D00);

  /// Page background (light).
  static const surfaceLight = Color(0xFFF8F9FA);

  /// Primary brand blue (dark surfaces).
  static const primaryDark = Color(0xFF90CAF9);

  /// Accent orange on dark backgrounds.
  static const accentDark = Color(0xFFFFB74D);

  /// Page scaffold background (dark).
  static const surfaceDark = Color(0xFF121212);
}
