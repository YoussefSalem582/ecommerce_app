import 'package:flutter/material.dart';

/// Brand palette constants — referenced by [ThemeExtension]s, not scattered hex values.
///
/// ShopFlow "Bold & Vibrant" identity: an electric violet → pink brand gradient
/// with a lime pop accent, on clean lavender-white (light) and deep plum (dark)
/// canvases.
abstract final class AppColors {
  // ── Brand (light surfaces) ───────────────────────────────────────────────

  /// Primary brand violet.
  static const primary = Color(0xFF7C3AED);

  /// Secondary brand pink/magenta.
  static const secondary = Color(0xFFEC4899);

  /// Lime "pop" accent for highlights and urgency.
  static const accent = Color(0xFFA3E635);

  /// Text/icons on the lime [accent].
  static const onAccentLight = Color(0xFF1A1235);

  /// Scaffold background (light) — soft lavender white.
  static const surfaceLight = Color(0xFFF6F5FF);

  /// Elevated surface (cards, inputs) on light.
  static const surfaceElevatedLight = Color(0xFFFFFFFF);

  /// Primary text on light surfaces — deep plum ink.
  static const onSurfaceLight = Color(0xFF1A1235);

  /// Muted / caption text on light surfaces.
  static const mutedLight = Color(0xFF6E6A86);

  // ── Brand (dark surfaces) ────────────────────────────────────────────────

  /// Primary brand violet (dark) — lightened for contrast.
  static const primaryDark = Color(0xFFA78BFA);

  /// Secondary brand pink (dark).
  static const secondaryDark = Color(0xFFF472B6);

  /// Lime "pop" accent (dark).
  static const accentDark = Color(0xFFBEF264);

  /// Text/icons on the lime [accentDark].
  static const onAccentDark = Color(0xFF1A1235);

  /// Scaffold background (dark) — deep plum.
  static const surfaceDark = Color(0xFF12091F);

  /// Elevated surface (cards, inputs) on dark — raised plum.
  static const surfaceElevatedDark = Color(0xFF1E1233);

  /// Primary text on dark surfaces.
  static const onSurfaceDark = Color(0xFFF6F3FF);

  /// Muted / caption text on dark surfaces.
  static const mutedDark = Color(0xFFA79FC4);

  // ── Semantic ─────────────────────────────────────────────────────────────

  /// Success (light).
  static const successLight = Color(0xFF16A34A);

  /// Success (dark).
  static const successDark = Color(0xFF4ADE80);

  /// Warning (light).
  static const warningLight = Color(0xFFF59E0B);

  /// Warning (dark).
  static const warningDark = Color(0xFFFBBF24);

  /// Error (light).
  static const errorLight = Color(0xFFE11D48);

  /// Error (dark).
  static const errorDark = Color(0xFFFB7185);
}
