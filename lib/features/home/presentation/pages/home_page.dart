import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
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
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';

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
                  if (listState is ProductListLoaded)
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
              ),
              floatingActionButton: kDebugMode
                  ? FloatingActionButton.small(
                      tooltip: l10n.debugLogs,
                      onPressed: () => context.push(AppRoutes.debugLogs),
                      child: const Icon(Icons.bug_report_outlined),
                    )
                  : null,
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Semantics(
                            label: l10n.catalogSearchA11y,
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: l10n.catalogSearchHint,
                                prefixIcon: const Icon(Icons.search_rounded),
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
                  if (listState is ProductListLoaded &&
                      listState.categories.isNotEmpty)
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(l10n.catalogAllCategories),
                              selected: listState.selectedCategory == null,
                              onSelected: (_) => context
                                  .read<ProductListBloc>()
                                  .add(const ProductListCategorySelected(null)),
                            ),
                          ),
                          ...listState.categories.map(
                            (String c) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final cols = ProductGridShimmer.columnsForWidth(
                          constraints.maxWidth,
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
              ),
            );
          },
        );
      },
    );
  }
}
