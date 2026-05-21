import 'package:flutter/material.dart';

/// Shared layout constants for the home catalog shell.
abstract final class HomeSpacing {
  /// Horizontal inset for search, sections, and chips.
  static const double horizontal = 16;

  /// Horizontal padding for chip rows (slightly tighter).
  static const double chipRowHorizontal = 12;

  /// Gap between chip items.
  static const double chipGap = 4;

  /// Vertical gap between major body sections.
  static const double sectionGap = 8;

  /// Height of the horizontal category chip row.
  static const double chipRowHeight = 44;

  /// Height of the recently viewed carousel.
  static const double recentlyViewedHeight = 200;

  /// Width of each recently viewed product tile.
  static const double recentlyViewedTileWidth = 150;

  /// Max content width on tablet/desktop.
  static const double maxContentWidth = 1200;

  /// Standard horizontal page padding.
  static EdgeInsets get pageHorizontal =>
      const EdgeInsets.symmetric(horizontal: horizontal);

  /// Search bar top padding.
  static EdgeInsets get searchPadding =>
      const EdgeInsets.fromLTRB(horizontal, 12, horizontal, 0);

  /// Section header padding.
  static EdgeInsets get sectionHeaderPadding =>
      const EdgeInsets.fromLTRB(horizontal, sectionGap, horizontal, 4);

  /// Clear-filters chip padding.
  static EdgeInsets get clearFiltersPadding =>
      const EdgeInsets.fromLTRB(horizontal, 0, horizontal, 4);
}
