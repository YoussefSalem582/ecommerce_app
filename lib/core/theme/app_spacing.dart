/// Semantic spacing scale — use instead of scattered magic numbers.
///
/// Base unit is 4px. Prefer these constants for padding, gaps, and insets so
/// spacing stays consistent across the "Bold & Vibrant" layout.
abstract final class AppSpacing {
  /// 4px — hairline gaps.
  static const double xxs = 4;

  /// 8px — tight gaps.
  static const double xs = 8;

  /// 12px — compact padding.
  static const double sm = 12;

  /// 16px — default padding / gap.
  static const double md = 16;

  /// 20px — roomy padding.
  static const double lg = 20;

  /// 24px — section padding.
  static const double xl = 24;

  /// 32px — large section spacing.
  static const double xxl = 32;

  /// 48px — hero / empty-state spacing.
  static const double xxxl = 48;
}
