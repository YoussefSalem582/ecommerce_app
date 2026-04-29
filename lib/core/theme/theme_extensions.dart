import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_colors.dart';

/// Semantic colors exposed through [ThemeExtension] for feature widgets.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Creates an [AppPalette] bundle.
  const AppPalette({
    required this.primary,
    required this.accent,
    required this.surface,
    required this.onSurface,
    required this.error,
  });

  /// Primary interactive color.
  final Color primary;

  /// Secondary accent (buttons, highlights).
  final Color accent;

  /// Scaffold / card background.
  final Color surface;

  /// Primary text/icon color on [surface].
  final Color onSurface;

  /// Semantic error color.
  final Color error;

  @override
  AppPalette copyWith({
    Color? primary,
    Color? accent,
    Color? surface,
    Color? onSurface,
    Color? error,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      error: error ?? this.error,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

/// Light palette aligned with [AppColors].
const AppPalette appPaletteLight = AppPalette(
  primary: AppColors.primary,
  accent: AppColors.accent,
  surface: AppColors.surfaceLight,
  onSurface: Color(0xFF1C1C1E),
  error: Color(0xFFB00020),
);

/// Dark palette aligned with [AppColors].
const AppPalette appPaletteDark = AppPalette(
  primary: AppColors.primaryDark,
  accent: AppColors.accentDark,
  surface: AppColors.surfaceDark,
  onSurface: Color(0xFFE8E8E8),
  error: Color(0xFFCF6679),
);

/// Theme helpers for `context.appPalette`.
extension AppPaletteBuildContext on BuildContext {
  /// Semantic colors from the active theme.
  AppPalette get appPalette =>
      Theme.of(this).extension<AppPalette>() ?? appPaletteLight;
}
