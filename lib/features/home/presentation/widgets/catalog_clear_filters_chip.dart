import 'package:flutter/material.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';

/// Chip that clears active catalog filters.
class CatalogClearFiltersChip extends StatelessWidget {
  /// Creates a clear-filters chip invoking [onPressed].
  const CatalogClearFiltersChip({required this.onPressed, super.key});

  /// Invoked when the user clears filters.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: HomeSpacing.clearFiltersPadding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ActionChip(
          key: TestKeys.catalogClearFiltersChip,
          avatar: const Icon(Icons.clear, size: 18),
          label: Text(l10n.catalogClearFilters),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
