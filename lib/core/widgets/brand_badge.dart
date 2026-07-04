import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/theme_extensions.dart';

/// A circular medallion filled with the brand gradient, wrapping an [icon].
///
/// Used as the visual anchor on auth, onboarding, splash, and success screens.
class BrandBadge extends StatelessWidget {
  /// Creates a gradient icon medallion.
  const BrandBadge({
    required this.icon,
    this.size = 96,
    super.key,
  });

  /// Glyph shown in the centre of the medallion.
  final IconData icon;

  /// Outer diameter of the circle.
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: palette.brandGradient,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.30),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.46, color: palette.onAccent),
    );
  }
}
