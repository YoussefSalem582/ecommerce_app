import 'package:flutter/widgets.dart';

/// Semantic corner-radius scale for the chunky "Bold & Vibrant" language.
abstract final class AppRadius {
  /// 8px — small chips / badges.
  static const double xs = 8;

  /// 12px — inputs, small cards.
  static const double sm = 12;

  /// 16px — buttons.
  static const double md = 16;

  /// 20px — cards.
  static const double lg = 20;

  /// 24px — sheets, hero surfaces.
  static const double xl = 24;

  /// 999px — pills.
  static const double pill = 999;

  /// [BorderRadius] for small chips / badges.
  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));

  /// [BorderRadius] for inputs / small cards.
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));

  /// [BorderRadius] for buttons.
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));

  /// [BorderRadius] for cards.
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));

  /// [BorderRadius] for sheets / hero surfaces.
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));

  /// [BorderRadius] for pills.
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}
