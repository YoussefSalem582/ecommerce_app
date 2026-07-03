import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic text styles shared across light and dark themes.
///
/// "Bold & Vibrant" pairing: geometric [GoogleFonts.spaceGrotesk] for headings
/// (punchy, characterful) over [GoogleFonts.plusJakartaSans] for body copy
/// (highly legible, friendly).
abstract final class AppTypography {
  /// Builds a complete [TextTheme] for the given foreground [color].
  static TextTheme textTheme(Color color, Color muted) {
    final heading = GoogleFonts.spaceGroteskTextTheme();
    final body = GoogleFonts.plusJakartaSansTextTheme();

    return TextTheme(
      displayLarge: heading.displayLarge?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -1,
        height: 1.05,
      ),
      headlineLarge: heading.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      headlineSmall: heading.headlineSmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.4,
      ),
      titleLarge: heading.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.2,
      ),
      titleMedium: heading.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      titleSmall: heading.titleSmall?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.5,
        color: color,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.45,
        color: color,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.4,
        color: muted,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.2,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
    );
  }
}
