# How to Change Theme Colors

1. Brand constants: `lib/core/theme/app_colors.dart`
2. Theme wiring: `lib/core/theme/app_theme.dart`
3. Semantic access in widgets: `Theme.of(context).extension<AppPalette>()!`
4. Typography: `lib/core/theme/app_typography.dart`

Also see [`../design-system/shopflow/MASTER.md`](../design-system/shopflow/MASTER.md) for design tokens.

Never scatter `Color(0xFF...)` in feature widgets.
