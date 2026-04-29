import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_typography.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Builds complete `ThemeData` values for ShopFlow.
abstract final class AppTheme {
  /// Material light theme.
  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: appPaletteLight.primary,
      secondary: appPaletteLight.accent,
      surface: appPaletteLight.surface,
      error: appPaletteLight.error,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: const <ThemeExtension<dynamic>>[
        appPaletteLight,
      ],
      scaffoldBackgroundColor: appPaletteLight.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: appPaletteLight.surface,
        foregroundColor: appPaletteLight.onSurface,
        titleTextStyle:
            AppTypography.titleMedium(appPaletteLight.onSurface),
      ),
      textTheme: TextTheme(
        headlineLarge:
            AppTypography.headlineLarge(appPaletteLight.onSurface),
        titleMedium: AppTypography.titleMedium(appPaletteLight.onSurface),
        bodyMedium: AppTypography.bodyMedium(appPaletteLight.onSurface),
        labelSmall: AppTypography.labelSmall(
          appPaletteLight.onSurface.withValues(alpha: 0.65),
        ),
      ),
    );
  }

  /// Material dark theme.
  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: appPaletteDark.primary,
      secondary: appPaletteDark.accent,
      surface: appPaletteDark.surface,
      error: appPaletteDark.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      extensions: const <ThemeExtension<dynamic>>[
        appPaletteDark,
      ],
      scaffoldBackgroundColor: appPaletteDark.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: appPaletteDark.surface,
        foregroundColor: appPaletteDark.onSurface,
        titleTextStyle:
            AppTypography.titleMedium(appPaletteDark.onSurface),
      ),
      textTheme: TextTheme(
        headlineLarge:
            AppTypography.headlineLarge(appPaletteDark.onSurface),
        titleMedium: AppTypography.titleMedium(appPaletteDark.onSurface),
        bodyMedium: AppTypography.bodyMedium(appPaletteDark.onSurface),
        labelSmall: AppTypography.labelSmall(
          appPaletteDark.onSurface.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}
