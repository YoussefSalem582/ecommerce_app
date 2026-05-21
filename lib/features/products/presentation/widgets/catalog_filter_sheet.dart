import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';

/// Bottom sheet for catalog sort, price range, and minimum rating filters.
class CatalogFilterSheet extends StatefulWidget {
  /// Creates filter sheet for the given loaded catalog state.
  const CatalogFilterSheet({required this.loaded, super.key});

  /// Active catalog snapshot with slider bounds.
  final ProductListLoaded loaded;

  @override
  State<CatalogFilterSheet> createState() => _CatalogFilterSheetState();
}

class _CatalogFilterSheetState extends State<CatalogFilterSheet> {
  late RangeValues _priceRange;
  late double _minRating;
  late ProductSortOption _sortOption;

  @override
  void initState() {
    super.initState();
    final ProductListLoaded loaded = widget.loaded;
    _priceRange = RangeValues(
      loaded.minPrice ?? loaded.catalogMinPrice,
      loaded.maxPrice ?? loaded.catalogMaxPrice,
    );
    _minRating = loaded.minRating;
    _sortOption = loaded.sortOption;
  }

  String _sortLabel(AppLocalizations l10n, ProductSortOption option) {
    return switch (option) {
      ProductSortOption.priceAsc => l10n.catalogSortPriceAsc,
      ProductSortOption.priceDesc => l10n.catalogSortPriceDesc,
      ProductSortOption.ratingDesc => l10n.catalogSortRatingDesc,
      ProductSortOption.titleAsc => l10n.catalogSortTitleAsc,
    };
  }

  void _apply() {
    final ProductListLoaded loaded = widget.loaded;
    final bloc = context.read<ProductListBloc>();
    bloc.add(ProductListSortChanged(_sortOption));
    bloc.add(
      ProductListPriceRangeChanged(
        minPrice: _priceRange.start <= loaded.catalogMinPrice
            ? null
            : _priceRange.start,
        maxPrice: _priceRange.end >= loaded.catalogMaxPrice
            ? null
            : _priceRange.end,
      ),
    );
    bloc.add(ProductListMinRatingChanged(_minRating));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final loaded = widget.loaded;
    final minBound = loaded.catalogMinPrice;
    final maxBound = loaded.catalogMaxPrice == loaded.catalogMinPrice
        ? loaded.catalogMaxPrice + 1
        : loaded.catalogMaxPrice;
    final Color selectedChipColor = palette.primary.withValues(alpha: 0.12);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.catalogFilterTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              key: TestKeys.catalogSortButton,
              children: <Widget>[
                Icon(Icons.sort_rounded, color: palette.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.catalogSortLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ProductSortOption.values.map((
                ProductSortOption option,
              ) {
                return FilterChip(
                  label: Text(_sortLabel(l10n, option)),
                  selected: _sortOption == option,
                  showCheckmark: true,
                  selectedColor: selectedChipColor,
                  onSelected: (_) => setState(() => _sortOption = option),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.catalogFilterPriceLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            RangeSlider(
              key: TestKeys.catalogPriceRangeSlider,
              values: _priceRange,
              min: minBound,
              max: maxBound,
              divisions: maxBound - minBound >= 1
                  ? (maxBound - minBound).round()
                  : null,
              labels: RangeLabels(
                PriceFormatter.formatUsd(context, _priceRange.start),
                PriceFormatter.formatUsd(context, _priceRange.end),
              ),
              onChanged: (RangeValues values) {
                setState(() => _priceRange = values);
              },
            ),
            Text(
              l10n.catalogFilterRatingLabel(_minRating.toStringAsFixed(1)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              key: TestKeys.catalogRatingSlider,
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _minRating.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() => _minRating = value);
              },
            ),
            const SizedBox(height: 8),
            FilledButton(
              key: TestKeys.catalogFilterApplyButton,
              onPressed: _apply,
              child: Text(l10n.catalogFilterApply),
            ),
          ],
        ),
      ),
    );
  }
}
