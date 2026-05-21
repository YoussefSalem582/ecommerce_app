import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_app_bar_action.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_app_bar_title.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Home app bar with welcome subtitle, list/grid toggle, and wishlist.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the home screen app bar.
  const HomeAppBar({
    required this.authState,
    required this.listState,
    super.key,
  });

  /// Current auth state for welcome subtitle.
  final AuthState authState;

  /// Current product list state for view toggle.
  final ProductListState listState;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ProductListLoaded? loadedState = listState is ProductListLoaded
        ? listState as ProductListLoaded
        : null;

    return AppBar(
      title: HomeAppBarTitle(authState: authState),
      actions: <Widget>[
        if (loadedState != null)
          HomeAppBarAction(
            icon: loadedState.viewMode == ProductListViewMode.grid
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded,
            tooltip: loadedState.viewMode == ProductListViewMode.grid
                ? l10n.catalogListView
                : l10n.catalogGridView,
            onPressed: () => context.read<ProductListBloc>().add(
              const ProductListViewModeToggled(),
            ),
          )
        else
          HomeAppBarAction(
            icon: Icons.view_list_rounded,
            tooltip: l10n.catalogListView,
            muted: true,
          ),
        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (BuildContext context, WishlistState wishlistState) {
            final int count = wishlistState is WishlistReady
                ? wishlistState.sortedIds.length
                : 0;
            return HomeAppBarAction(
              icon: Icons.favorite_outline_rounded,
              tooltip: l10n.wishlistTitle,
              badgeCount: count,
              onPressed: () => context.push(AppRoutes.wishlist),
            );
          },
        ),
      ],
    );
  }
}
