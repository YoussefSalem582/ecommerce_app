import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_filters_section.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_pinned_header.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_product_slivers.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_promo_banner.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_recently_viewed_section.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';

/// Scrollable catalog body with pinned search and sliver product grid.
class HomeScrollBody extends StatelessWidget {
  /// Creates the home catalog scroll surface.
  const HomeScrollBody({
    required this.listState,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onProductTap,
    required this.onShowFilterSheet,
    super.key,
  });

  /// Current product list BLoC state.
  final ProductListState listState;

  /// Search field controller owned by the parent page.
  final TextEditingController searchController;

  /// Invoked when the user submits a search query.
  final VoidCallback onSearchSubmitted;

  /// Invoked when a product tile is tapped.
  final ValueChanged<int> onProductTap;

  /// Opens the filter bottom sheet (includes sort).
  final void Function(ProductListLoaded loaded) onShowFilterSheet;

  static ProductListLoaded? _loadedOf(ProductListState state) {
    return state is ProductListLoaded ? state : null;
  }

  void _clearFilters(BuildContext context) {
    context.read<ProductListBloc>().add(const ProductListFiltersCleared());
  }

  Future<void> _refresh(BuildContext context) async {
    final ProductListBloc bloc = context.read<ProductListBloc>();
    bloc.add(const ProductListRefreshRequested());
    await bloc.stream.firstWhere(
      (ProductListState s) => s is ProductListLoaded || s is ProductListFailure,
    );
  }

  Widget _buildScrollView(BuildContext context, double contentWidth) {
    final palette = context.appPalette;
    final ProductListLoaded? loaded = _loadedOf(listState);
    final double bottomInset =
        MediaQuery.paddingOf(context).bottom + HomeSpacing.shellBottomClearance;

    return RefreshIndicator(
      color: palette.primary,
      onRefresh: () => _refresh(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          CatalogPinnedHeader(
            searchController: searchController,
            onSearchSubmitted: onSearchSubmitted,
            listState: listState,
            onShowFilterSheet: onShowFilterSheet,
          ),
          const SliverToBoxAdapter(child: HomePromoBanner()),
          const SliverToBoxAdapter(child: HomeRecentlyViewedSection()),
          ...CatalogFiltersSection.buildSlivers(
            loaded: loaded,
            onClearFilters: () => _clearFilters(context),
            onCategorySelected: (String? category) {
              context.read<ProductListBloc>().add(
                ProductListCategorySelected(category),
              );
            },
          ),
          ...CatalogProductSlivers.build(
            context: context,
            listState: listState,
            contentWidth: contentWidth,
            onRetry: () => context.read<ProductListBloc>().add(
              const ProductListStarted(),
            ),
            onProductTap: onProductTap,
            onClearFilters: (loaded?.hasActiveFilters ?? false)
                ? () => _clearFilters(context)
                : null,
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: bottomInset)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= AppBreakpoints.tablet;
        final double contentWidth = wide
            ? constraints.maxWidth.clamp(0, HomeSpacing.maxContentWidth)
            : constraints.maxWidth;

        final Widget scrollView = _buildScrollView(context, contentWidth);

        if (!wide) {
          return scrollView;
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: HomeSpacing.maxContentWidth,
            ),
            child: scrollView,
          ),
        );
      },
    );
  }
}
