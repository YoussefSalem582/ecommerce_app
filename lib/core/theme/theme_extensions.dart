import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_colors.dart';

/// Semantic colors exposed through [ThemeExtension] for feature widgets.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Creates an [AppPalette] bundle.
  const AppPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.error,
    required this.onPrimary,
  });

  /// Primary interactive color.
  final Color primary;

  /// Secondary highlight color.
  final Color secondary;

  /// CTA / urgency accent color.
  final Color accent;

  /// Scaffold / card background.
  final Color surface;

  /// Primary text/icon color on [surface].
  final Color onSurface;

  /// Secondary / caption text color.
  final Color muted;

  /// Semantic error color.
  final Color error;

  /// Text/icons on [primary] backgrounds.
  final Color onPrimary;

  @override
  AppPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? surface,
    Color? onSurface,
    Color? muted,
    Color? error,
    Color? onPrimary,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      muted: muted ?? this.muted,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      error: Color.lerp(error, other.error, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }
}

/// Light palette aligned with [AppColors].
const AppPalette appPaletteLight = AppPalette(
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  accent: AppColors.accent,
  surface: AppColors.surfaceLight,
  onSurface: AppColors.onSurfaceLight,
  muted: AppColors.mutedLight,
  error: Color(0xFFB00020),
  onPrimary: Colors.white,
);

/// Dark palette aligned with [AppColors].
const AppPalette appPaletteDark = AppPalette(
  primary: AppColors.primaryDark,
  secondary: AppColors.secondaryDark,
  accent: AppColors.accentDark,
  surface: AppColors.surfaceDark,
  onSurface: AppColors.onSurfaceDark,
  muted: AppColors.mutedDark,
  error: Color(0xFFCF6679),
  onPrimary: AppColors.onSurfaceLight,
);

/// Theme helpers for `context.appPalette`.
extension AppPaletteBuildContext on BuildContext {
  /// Semantic colors from the active theme.
  AppPalette get appPalette =>
      Theme.of(this).extension<AppPalette>() ?? appPaletteLight;
}
