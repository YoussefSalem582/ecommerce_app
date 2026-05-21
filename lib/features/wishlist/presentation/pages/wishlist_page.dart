import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/core/widgets/continue_shopping_button.dart';
import 'package:shop_flow/core/widgets/product_grid_shimmer.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_bloc.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_event.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_state.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Full-screen grid of favorited products with pull-to-refresh.
class WishlistPage extends StatefulWidget {
  /// Creates wishlist catalog route.
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<WishlistPageBloc>().add(const WishlistPageStarted());
    });
  }

  void _reloadPage() {
    context.read<WishlistPageBloc>().add(const WishlistPageRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return BlocListener<WishlistCubit, WishlistState>(
      listenWhen: (WishlistState previous, WishlistState current) =>
          previous != current,
      listener: (BuildContext context, WishlistState state) {
        _reloadPage();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.wishlistTitle)),
        body: BlocBuilder<WishlistPageBloc, WishlistPageState>(
          builder: (BuildContext context, WishlistPageState state) {
            if (state is WishlistPageInitial ||
                state is WishlistPageLoading) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ProductGridShimmer(
                    crossAxisCount: ProductGridShimmer.columnsForWidth(
                      constraints.maxWidth,
                    ),
                  );
                },
              );
            }

            if (state is WishlistPageFailure) {
              return AppErrorView(
                message: state.message,
                onRetry: _reloadPage,
              );
            }

            if (state is WishlistPageEmpty) {
              return AppEmptyView(
                icon: Icons.favorite_border_rounded,
                title: l10n.wishlistEmptyTitle,
                body: l10n.wishlistEmptyBody,
                action: const ContinueShoppingButton(),
              );
            }

            if (state is WishlistPageLoaded) {
              final List<ProductEntity> products = state.products;

              return RefreshIndicator(
                color: palette.primary,
                onRefresh: () async {
                  _reloadPage();
                  await context.read<WishlistPageBloc>().stream.firstWhere(
                        (WishlistPageState s) =>
                            s is WishlistPageLoaded ||
                            s is WishlistPageEmpty ||
                            s is WishlistPageFailure,
                      );
                },
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final int cols = ProductGridShimmer.columnsForWidth(
                      constraints.maxWidth,
                    );

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ProductEntity product = products[index];
                        return ProductCard(
                          key: index == 0 ? TestKeys.firstWishlistCard : null,
                          product: product,
                          onTap: () => context.push(
                            AppRoutes.product(product.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
