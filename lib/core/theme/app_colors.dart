import 'package:flutter/material.dart';

/// Brand palette constants — referenced by [ThemeExtension]s, not scattered hex values.
abstract final class AppColors {
  /// Primary brand emerald (light surfaces).
  static const primary = Color(0xFF059669);

  /// Secondary green for highlights.
  static const secondary = Color(0xFF10B981);

  /// CTA orange for urgency actions.
  static const accent = Color(0xFFF97316);

  /// Page background (light).
  static const surfaceLight = Color(0xFFECFDF5);

  /// Primary text on light surfaces.
  static const onSurfaceLight = Color(0xFF064E3B);

  /// Muted text on light surfaces.
  static const mutedLight = Color(0xFF047857);

  /// Primary brand (dark surfaces).
  static const primaryDark = Color(0xFF34D399);

  /// Secondary on dark backgrounds.
  static const secondaryDark = Color(0xFF6EE7B7);

  /// CTA orange on dark backgrounds.
  static const accentDark = Color(0xFFFB923C);

  /// Page scaffold background (dark).
  static const surfaceDark = Color(0xFF022C22);

  /// Primary text on dark surfaces.
  static const onSurfaceDark = Color(0xFFECFDF5);

  /// Muted text on dark surfaces.
  static const mutedDark = Color(0xFFA7F3D0);
}
