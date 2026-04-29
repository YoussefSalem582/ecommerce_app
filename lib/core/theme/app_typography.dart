import 'package:flutter/material.dart';

/// Semantic text styles shared across light and dark themes.
abstract final class AppTypography {
  /// Large headline style for hero titles.
  static TextStyle headlineLarge(Color color) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  /// Section titles on screens.
  static TextStyle titleMedium(Color color) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Dense body copy for descriptions.
  static TextStyle bodyMedium(Color color) => TextStyle(
        fontSize: 14,
        height: 1.4,
        color: color,
      );

  /// Caption / helper style.
  static TextStyle labelSmall(Color color) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
