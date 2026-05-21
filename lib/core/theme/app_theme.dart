import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_typography.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Builds complete `ThemeData` values for ShopFlow.
abstract final class AppTheme {
  /// Material light theme.
  static ThemeData light() {
    final palette = appPaletteLight;
    final scheme = ColorScheme.light(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.onPrimary,
      tertiary: palette.accent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      error: palette.error,
      onError: Colors.white,
    );
    return _buildTheme(scheme, palette);
  }

  /// Material dark theme.
  static ThemeData dark() {
    final palette = appPaletteDark;
    final scheme = ColorScheme.dark(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.onPrimary,
      tertiary: palette.accent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      error: palette.error,
      onError: Colors.black,
    );
    return _buildTheme(scheme, palette, isDark: true);
  }

  static ThemeData _buildTheme(
    ColorScheme scheme,
    AppPalette palette, {
    bool isDark = false,
  }) {
    final textTheme =
        AppTypography.textTheme(palette.onSurface, palette.muted);
    final borderColor = isDark
        ? palette.muted.withValues(alpha: 0.35)
        : palette.muted.withValues(alpha: 0.25);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      scaffoldBackgroundColor: palette.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: palette.surface,
        foregroundColor: palette.onSurface,
        titleTextStyle: textTheme.titleMedium,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: palette.onSurface.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
        color: isDark
            ? palette.onSurface.withValues(alpha: 0.06)
            : Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: textTheme.labelLarge,
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: textTheme.labelLarge,
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? palette.onSurface.withValues(alpha: 0.06)
            : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: palette.muted),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: borderColor),
        selectedColor: palette.primary.withValues(alpha: 0.15),
        checkmarkColor: palette.primary,
        labelStyle: textTheme.labelLarge,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: palette.onSurface,
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: textTheme.labelSmall?.copyWith(color: palette.surface),
      ),
    );
  }
}
