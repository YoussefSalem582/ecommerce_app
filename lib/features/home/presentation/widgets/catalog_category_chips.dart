import 'package:flutter/material.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';

/// Horizontally scrollable category filter chips for the catalog.
class CatalogCategoryChips extends StatelessWidget {
  /// Creates category chips for [categories].
  const CatalogCategoryChips({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  /// Available category labels.
  final List<String> categories;

  /// Currently selected category, or null for all.
  final String? selectedCategory;

  /// Invoked when the user selects a category (null = all).
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final Color selectedColor = palette.primary.withValues(alpha: 0.12);

    return SizedBox(
      height: HomeSpacing.chipRowHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: HomeSpacing.chipRowHorizontal,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HomeSpacing.chipGap,
            ),
            child: FilterChip(
              label: Text(l10n.catalogAllCategories),
              selected: selectedCategory == null,
              showCheckmark: true,
              selectedColor: selectedColor,
              onSelected: (_) => onCategorySelected(null),
            ),
          ),
          ...categories.map(
            (String category) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HomeSpacing.chipGap,
              ),
              child: FilterChip(
                label: Text(category),
                selected: selectedCategory == category,
                showCheckmark: true,
                selectedColor: selectedColor,
                onSelected: (_) => onCategorySelected(category),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
