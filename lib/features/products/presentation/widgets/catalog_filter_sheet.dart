import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';

/// Bottom sheet for catalog price range and minimum rating filters.
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

  @override
  void initState() {
    super.initState();
    final ProductListLoaded loaded = widget.loaded;
    _priceRange = RangeValues(
      loaded.minPrice ?? loaded.catalogMinPrice,
      loaded.maxPrice ?? loaded.catalogMaxPrice,
    );
    _minRating = loaded.minRating;
  }

  void _apply() {
    final ProductListLoaded loaded = widget.loaded;
    final bloc = context.read<ProductListBloc>();
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
    final loaded = widget.loaded;
    final minBound = loaded.catalogMinPrice;
    final maxBound = loaded.catalogMaxPrice == loaded.catalogMinPrice
        ? loaded.catalogMaxPrice + 1
        : loaded.catalogMaxPrice;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.catalogFilterTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.catalogFilterPriceLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          RangeSlider(
            key: TestKeys.catalogPriceRangeSlider,
            values: _priceRange,
            min: minBound,
            max: maxBound,
            divisions: maxBound - minBound >= 1 ? (maxBound - minBound).round() : null,
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
    );
  }
}
