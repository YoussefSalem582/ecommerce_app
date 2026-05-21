import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Icon button with optional badge for the home app bar.
class HomeAppBarAction extends StatelessWidget {
  /// Creates a toolbar action with [tooltip] and [icon].
  const HomeAppBarAction({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.badgeCount = 0,
    this.muted = false,
    super.key,
  });

  /// Action glyph.
  final IconData icon;

  /// Accessibility and long-press hint.
  final String tooltip;

  /// Invoked on tap; null disables the button.
  final VoidCallback? onPressed;

  /// Optional count badge (hidden when zero).
  final int badgeCount;

  /// When true, uses muted palette color.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final Color iconColor = muted
        ? palette.muted
        : Theme.of(context).colorScheme.onSurface;

    Widget iconWidget = Icon(icon, color: iconColor);

    if (badgeCount > 0) {
      iconWidget = Badge(
        isLabelVisible: true,
        label: Text('$badgeCount'),
        child: iconWidget,
      );
    }

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: iconWidget,
    );
  }
}
