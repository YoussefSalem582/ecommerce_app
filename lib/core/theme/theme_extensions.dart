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
    required this.onAccent,
    required this.surface,
    required this.surfaceElevated,
    required this.onSurface,
    required this.muted,
    required this.error,
    required this.success,
    required this.warning,
    required this.onPrimary,
    required this.brandGradient,
  });

  /// Primary interactive color.
  final Color primary;

  /// Secondary highlight color.
  final Color secondary;

  /// Lime "pop" accent color.
  final Color accent;

  /// Text/icons on [accent] backgrounds.
  final Color onAccent;

  /// Scaffold background.
  final Color surface;

  /// Elevated surface (cards, inputs, sheets).
  final Color surfaceElevated;

  /// Primary text/icon color on [surface].
  final Color onSurface;

  /// Secondary / caption text color.
  final Color muted;

  /// Semantic error color.
  final Color error;

  /// Semantic success color.
  final Color success;

  /// Semantic warning color.
  final Color warning;

  /// Text/icons on [primary] backgrounds.
  final Color onPrimary;

  /// Signature violet → pink brand gradient (CTAs, active nav, hero banner).
  final Gradient brandGradient;

  @override
  AppPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? onAccent,
    Color? surface,
    Color? surfaceElevated,
    Color? onSurface,
    Color? muted,
    Color? error,
    Color? success,
    Color? warning,
    Color? onPrimary,
    Gradient? brandGradient,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurface: onSurface ?? this.onSurface,
      muted: muted ?? this.muted,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      onPrimary: onPrimary ?? this.onPrimary,
      brandGradient: brandGradient ?? this.brandGradient,
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
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      brandGradient:
          Gradient.lerp(brandGradient, other.brandGradient, t) ?? brandGradient,
    );
  }
}

/// Violet → pink brand gradient for light surfaces.
const Gradient _brandGradientLight = LinearGradient(
  colors: <Color>[AppColors.primary, AppColors.secondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Violet → pink brand gradient for dark surfaces.
const Gradient _brandGradientDark = LinearGradient(
  colors: <Color>[AppColors.primaryDark, AppColors.secondaryDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Light palette aligned with [AppColors].
const AppPalette appPaletteLight = AppPalette(
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  accent: AppColors.accent,
  onAccent: AppColors.onAccentLight,
  surface: AppColors.surfaceLight,
  surfaceElevated: AppColors.surfaceElevatedLight,
  onSurface: AppColors.onSurfaceLight,
  muted: AppColors.mutedLight,
  error: AppColors.errorLight,
  success: AppColors.successLight,
  warning: AppColors.warningLight,
  onPrimary: Colors.white,
  brandGradient: _brandGradientLight,
);

/// Dark palette aligned with [AppColors].
const AppPalette appPaletteDark = AppPalette(
  primary: AppColors.primaryDark,
  secondary: AppColors.secondaryDark,
  accent: AppColors.accentDark,
  onAccent: AppColors.onAccentDark,
  surface: AppColors.surfaceDark,
  surfaceElevated: AppColors.surfaceElevatedDark,
  onSurface: AppColors.onSurfaceDark,
  muted: AppColors.mutedDark,
  error: AppColors.errorDark,
  success: AppColors.successDark,
  warning: AppColors.warningDark,
  onPrimary: AppColors.onSurfaceLight,
  brandGradient: _brandGradientDark,
);

/// Theme helpers for `context.appPalette`.
extension AppPaletteBuildContext on BuildContext {
  /// Semantic colors from the active theme.
  AppPalette get appPalette =>
      Theme.of(this).extension<AppPalette>() ?? appPaletteLight;
}
