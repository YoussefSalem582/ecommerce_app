import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
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
      onSecondary: Colors.white,
      tertiary: palette.accent,
      onTertiary: palette.onAccent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceElevated,
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
      onTertiary: palette.onAccent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceElevated,
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
        ? palette.muted.withValues(alpha: 0.28)
        : palette.muted.withValues(alpha: 0.18);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      scaffoldBackgroundColor: palette.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: palette.surface,
        foregroundColor: palette.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: palette.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: borderColor),
        ),
        color: palette.surfaceElevated,
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: textTheme.labelLarge,
          animationDuration: const Duration(milliseconds: 180),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary, width: 1.6),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: textTheme.labelLarge,
          animationDuration: const Duration(milliseconds: 180),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: palette.error, width: 1.6),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: palette.muted),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
        side: BorderSide(color: borderColor),
        backgroundColor: palette.surfaceElevated,
        selectedColor: palette.primary.withValues(alpha: 0.16),
        checkmarkColor: palette.primary,
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surfaceElevated,
        elevation: 0,
        height: 68,
        indicatorColor: palette.primary.withValues(alpha: 0.16),
        indicatorShape:
            const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: AppSpacing.xl,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: palette.surface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceElevated,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brXl),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: palette.onSurface,
          borderRadius: AppRadius.brXs,
        ),
        textStyle: textTheme.labelSmall?.copyWith(color: palette.surface),
      ),
    );
  }
}
