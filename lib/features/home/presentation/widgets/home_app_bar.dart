import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
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
    final palette = context.appPalette;
    final String username = switch (authState) {
      AuthAuthenticated(:final user) => user.username,
      _ => '',
    };
    final ProductListLoaded? loadedState = listState is ProductListLoaded
        ? listState as ProductListLoaded
        : null;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l10n.homeTitle),
          if (authState is AuthAuthenticated)
            Text(
              l10n.welcomeUser(username),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: palette.muted),
            ),
        ],
      ),
      actions: <Widget>[
        if (loadedState != null)
          _HomeAppBarAction(
            icon: loadedState.viewMode == ProductListViewMode.grid
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded,
            label: loadedState.viewMode == ProductListViewMode.grid
                ? l10n.catalogListView
                : l10n.catalogGridView,
            tooltip: loadedState.viewMode == ProductListViewMode.grid
                ? l10n.catalogListView
                : l10n.catalogGridView,
            onTap: () => context.read<ProductListBloc>().add(
              const ProductListViewModeToggled(),
            ),
          )
        else
          _HomeAppBarAction(
            icon: Icons.view_list_rounded,
            label: l10n.catalogListView,
            tooltip: l10n.catalogListView,
            onTap: null,
            muted: true,
          ),
        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (BuildContext context, WishlistState wishlistState) {
            final int count = wishlistState is WishlistReady
                ? wishlistState.sortedIds.length
                : 0;
            return _HomeAppBarAction(
              icon: Icons.favorite_outline_rounded,
              label: l10n.wishlistTitle,
              tooltip: l10n.wishlistTitle,
              badgeCount: count,
              onTap: () => context.push(AppRoutes.wishlist),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _HomeAppBarAction extends StatelessWidget {
  const _HomeAppBarAction({
    required this.icon,
    required this.label,
    required this.tooltip,
    this.onTap,
    this.badgeCount = 0,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onTap;
  final int badgeCount;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final Color iconColor = muted
        ? palette.muted
        : Theme.of(context).colorScheme.onSurface;

    Widget iconWidget = Icon(icon, color: iconColor, size: 22);

    if (badgeCount > 0) {
      iconWidget = Badge(
        isLabelVisible: true,
        label: Text('$badgeCount'),
        child: iconWidget,
      );
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconWidget,
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: muted ? palette.muted : palette.onSurface,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
