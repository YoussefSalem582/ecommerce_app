import 'package:flutter/material.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';

/// Search field with a filter button that opens the combined sort/filter sheet.
class CatalogSearchBar extends StatefulWidget {
  /// Creates a search bar bound to [controller].
  const CatalogSearchBar({
    required this.controller,
    required this.onSubmitted,
    required this.listState,
    required this.onShowFilterSheet,
    super.key,
  });

  /// Text input controller for the query.
  final TextEditingController controller;

  /// Invoked when the user submits the search.
  final VoidCallback onSubmitted;

  /// Current product list state for enabling the filter action.
  final ProductListState listState;

  /// Opens the filter bottom sheet (includes sort) when catalog is loaded.
  final void Function(ProductListLoaded loaded) onShowFilterSheet;

  @override
  State<CatalogSearchBar> createState() => _CatalogSearchBarState();
}

class _CatalogSearchBarState extends State<CatalogSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clear() {
    widget.controller.clear();
    widget.onSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool hasText = widget.controller.text.isNotEmpty;
    final ProductListLoaded? loadedState = widget.listState is ProductListLoaded
        ? widget.listState as ProductListLoaded
        : null;
    final bool hasSortOrFilters =
        loadedState != null &&
        (loadedState.hasActiveFilters ||
            loadedState.sortOption != ProductSortOption.ratingDesc);

    return Padding(
      padding: HomeSpacing.searchPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Semantics(
              label: l10n.catalogSearchA11y,
              child: TextField(
                key: TestKeys.catalogSearchField,
                controller: widget.controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.catalogSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (hasText)
                        IconButton(
                          tooltip: l10n.cancelButton,
                          onPressed: _clear,
                          icon: const Icon(Icons.clear_rounded),
                        ),
                      IconButton(
                        tooltip: l10n.catalogSearchA11y,
                        onPressed: widget.onSubmitted,
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) => widget.onSubmitted(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            key: TestKeys.catalogFilterButton,
            tooltip: l10n.catalogFilterTitle,
            onPressed: loadedState == null
                ? null
                : () => widget.onShowFilterSheet(loadedState),
            icon: Badge(
              isLabelVisible: hasSortOrFilters,
              child: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
