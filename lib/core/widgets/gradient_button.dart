import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Primary call-to-action rendered on the brand violet→pink gradient.
///
/// Used for the highest-intent actions (add to cart, checkout, sign in). Falls
/// back to a flat disabled surface when [onPressed] is null or [loading] is
/// true, and exposes button semantics for screen readers.
class AppGradientButton extends StatelessWidget {
  /// Creates a gradient CTA with a text [label].
  const AppGradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    super.key,
  });

  /// Button copy.
  final String label;

  /// Tap handler; when null the button renders disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Shows a spinner and blocks taps while true.
  final bool loading;

  /// When true the button stretches to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final bool enabled = onPressed != null && !loading;

    final Widget content = loading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: palette.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 20, color: palette.onPrimary),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: palette.onPrimary),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: enabled
                ? palette.brandGradient
                : LinearGradient(
                    colors: <Color>[
                      palette.muted.withValues(alpha: 0.4),
                      palette.muted.withValues(alpha: 0.4),
                    ],
                  ),
            borderRadius: AppRadius.brMd,
            boxShadow: enabled
                ? <BoxShadow>[
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: AppRadius.brMd,
              onTap: enabled ? onPressed : null,
              child: Container(
                constraints: const BoxConstraints(minHeight: 52),
                width: expand ? double.infinity : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                alignment: Alignment.center,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
