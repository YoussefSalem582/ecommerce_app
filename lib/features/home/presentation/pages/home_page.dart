import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/product_grid_shimmer.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_cubit.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_state.dart';
import 'package:shop_flow/features/products/presentation/widgets/catalog_filter_sheet.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Authenticated catalog shell — responsive grid, chips, search, shimmer.
class HomePage extends StatefulWidget {
  /// Creates catalog host route.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProductListBloc>().add(const ProductListStarted());
      context.read<CartBloc>().add(const CartRefreshRequested());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<ProductListBloc>().add(
          ProductListSearchSubmitted(_searchController.text),
        );
  }

  void _showFilterSheet(ProductListLoaded loaded) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => CatalogFilterSheet(loaded: loaded),
    );
  }

  String _sortLabel(AppLocalizations l10n, ProductSortOption option) {
    return switch (option) {
      ProductSortOption.priceAsc => l10n.catalogSortPriceAsc,
      ProductSortOption.priceDesc => l10n.catalogSortPriceDesc,
      ProductSortOption.ratingDesc => l10n.catalogSortRatingDesc,
      ProductSortOption.titleAsc => l10n.catalogSortTitleAsc,
    };
  }

  Widget _recentlyViewedSection(AppLocalizations l10n) {
    return BlocBuilder<RecentlyViewedCubit, RecentlyViewedState>(
      builder: (BuildContext context, RecentlyViewedState rvState) {
        if (rvState is! RecentlyViewedReady || rvState.products.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                l10n.recentlyViewedTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rvState.products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  final ProductEntity product = rvState.products[index];
                  return SizedBox(
                    width: 150,
                    child: ProductCard(
                      product: product,
                      enableHero: false,
                      onTap: () => context.push(AppRoutes.product(product.id)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (BuildContext context, ProductListState listState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState authState) {
            final username =
                authState is AuthAuthenticated ? authState.user.username : '';

            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l10n.homeTitle),
                    if (authState is AuthAuthenticated)
                      Text(
                        l10n.welcomeUser(username),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    key: TestKeys.categoriesBrowseButton,
                    tooltip: l10n.categoriesTitle,
                    onPressed: () => context.push(AppRoutes.categories),
                    icon: const Icon(Icons.category_outlined),
                  ),
                  BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (BuildContext context, WishlistState wishlistState) {
                      final int count = wishlistState is WishlistReady
                          ? wishlistState.sortedIds.length
                          : 0;
                      return IconButton(
                        tooltip: l10n.wishlistTitle,
                        onPressed: () => context.push(AppRoutes.wishlist),
                        icon: Badge(
                          isLabelVisible: count > 0,
                          label: Text('$count'),
                          child: const Icon(Icons.favorite_outline_rounded),
                        ),
                      );
                    },
                  ),
                  if (listState is ProductListLoaded) ...<Widget>[
                    PopupMenuButton<ProductSortOption>(
                      key: TestKeys.catalogSortButton,
                      tooltip: l10n.catalogSortLabel,
                      initialValue: listState.sortOption,
                      onSelected: (ProductSortOption option) {
                        context.read<ProductListBloc>().add(
                              ProductListSortChanged(option),
                            );
                      },
                      itemBuilder: (BuildContext context) {
                        return ProductSortOption.values
                            .map(
                              (ProductSortOption option) =>
                                  PopupMenuItem<ProductSortOption>(
                                value: option,
                                child: Text(_sortLabel(l10n, option)),
                              ),
                            )
                            .toList();
                      },
                      icon: const Icon(Icons.sort_rounded),
                    ),
                    IconButton(
                      key: TestKeys.catalogFilterButton,
                      tooltip: l10n.catalogFilterTitle,
                      onPressed: () => _showFilterSheet(listState),
                      icon: Badge(
                        isLabelVisible: listState.hasActiveFilters,
                        child: const Icon(Icons.tune_rounded),
                      ),
                    ),
                    IconButton(
                      tooltip: listState.viewMode == ProductListViewMode.grid
                          ? l10n.catalogListView
                          : l10n.catalogGridView,
                      onPressed: () => context
                          .read<ProductListBloc>()
                          .add(const ProductListViewModeToggled()),
                      icon: Icon(
                        listState.viewMode == ProductListViewMode.grid
                            ? Icons.view_list_rounded
                            : Icons.grid_view_rounded,
                      ),
                    ),
                  ],
                ],
              ),
              floatingActionButton: kDebugMode
                  ? FloatingActionButton.small(
                      tooltip: l10n.debugLogs,
                      onPressed: () => context.push(AppRoutes.debugLogs),
                      child: const Icon(Icons.bug_report_outlined),
                    )
                  : null,
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool wide =
                      constraints.maxWidth >= AppBreakpoints.tablet;
                  final Widget content = Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Semantics(
                                label: l10n.catalogSearchA11y,
                                child: TextField(
                                  key: TestKeys.catalogSearchField,
                                  controller: _searchController,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintText: l10n.catalogSearchHint,
                                    prefixIcon:
                                        const Icon(Icons.search_rounded),
                                  ),
                                  onSubmitted: (_) => _submitSearch(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              tooltip: l10n.catalogSearchA11y,
                              onPressed: _submitSearch,
                              icon: const Icon(Icons.search_rounded),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _recentlyViewedSection(l10n),
                      if (listState is ProductListLoaded &&
                          listState.hasActiveFilters)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ActionChip(
                              key: TestKeys.catalogClearFiltersChip,
                              avatar: const Icon(Icons.clear, size: 18),
                              label: Text(l10n.catalogClearFilters),
                              onPressed: () => context
                                  .read<ProductListBloc>()
                                  .add(const ProductListFiltersCleared()),
                            ),
                          ),
                        ),
                      if (listState is ProductListLoaded &&
                          listState.categories.isNotEmpty)
                        SizedBox(
                          height: 44,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(l10n.catalogAllCategories),
                                  selected: listState.selectedCategory == null,
                                  onSelected: (_) => context
                                      .read<ProductListBloc>()
                                      .add(const ProductListCategorySelected(
                                          null)),
                                ),
                              ),
                              ...listState.categories.map(
                                (String c) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  child: ChoiceChip(
                                    label: Text(c),
                                    selected: listState.selectedCategory == c,
                                    onSelected: (_) => context
                                        .read<ProductListBloc>()
                                        .add(ProductListCategorySelected(c)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints gridConstraints) {
                            final cols = ProductGridShimmer.columnsForWidth(
                              gridConstraints.maxWidth,
                            );

                            if (listState is ProductListInitial ||
                                listState is ProductListLoading) {
                              return ProductGridShimmer(crossAxisCount: cols);
                            }

                            if (listState is ProductListFailure) {
                              return AppErrorView(
                                message: listState.message,
                                onRetry: () => context
                                    .read<ProductListBloc>()
                                    .add(const ProductListStarted()),
                              );
                            }

                            if (listState is ProductListLoaded) {
                              final products = listState.products;
                              if (products.isEmpty) {
                                return AppEmptyView(
                                  icon: Icons.inventory_2_outlined,
                                  title: l10n.catalogEmpty,
                                  body: l10n.cartEmptyBody,
                                );
                              }

                              return RefreshIndicator(
                                color: palette.primary,
                                onRefresh: () async {
                                  final ProductListBloc bloc =
                                      context.read<ProductListBloc>();
                                  bloc.add(const ProductListRefreshRequested());
                                  await bloc.stream.firstWhere(
                                    (ProductListState s) =>
                                        s is ProductListLoaded ||
                                        s is ProductListFailure,
                                  );
                                },
                                child: listState.viewMode ==
                                        ProductListViewMode.list
                                    ? ListView.builder(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: products.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          final ProductEntity product =
                                              products[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: ProductCard(
                                              key: index == 0
                                                  ? TestKeys.firstProductCard
                                                  : null,
                                              product: product,
                                              onTap: () => context.push(
                                                AppRoutes.product(product.id),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(16),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 0.72,
                                        ),
                                        itemCount: products.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          final ProductEntity product =
                                              products[index];
                                          return ProductCard(
                                            key: index == 0
                                                ? TestKeys.firstProductCard
                                                : null,
                                            product: product,
                                            onTap: () => context.push(
                                              AppRoutes.product(product.id),
                                            ),
                                          );
                                        },
                                      ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  );

                  if (!wide) {
                    return content;
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: content,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
