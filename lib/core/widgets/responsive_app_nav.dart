import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';

/// Breakpoint-aware shell navigation: bottom bar, rail, or drawer.
class ResponsiveAppNav extends StatelessWidget {
  /// Creates responsive navigation chrome for [navigationShell].
  const ResponsiveAppNav({
    required this.navigationShell,
    super.key,
  });

  /// GoRouter branch host managed by [StatefulShellRoute].
  final StatefulNavigationShell navigationShell;

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      selectedIcon: Icon(Icons.shopping_cart_rounded),
      label: 'Cart',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long_rounded),
      label: 'Orders',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final labels = <String>[
      l10n.homeTitle,
      l10n.cartTitle,
      l10n.ordersTitle,
      l10n.profileTitle,
    ];

    if (width >= AppBreakpoints.desktop) {
      return _DesktopShell(
        currentIndex: navigationShell.currentIndex,
        labels: labels,
        onTap: _onTap,
        child: navigationShell,
      );
    }

    if (width >= AppBreakpoints.mobile) {
      return _TabletShell(
        currentIndex: navigationShell.currentIndex,
        labels: labels,
        onTap: _onTap,
        child: navigationShell,
      );
    }

    return _MobileShell(
      currentIndex: navigationShell.currentIndex,
      labels: labels,
      onTap: _onTap,
      child: navigationShell,
    );
  }
}

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.currentIndex,
    required this.labels,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final List<String> labels;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: List<NavigationDestination>.generate(
          ResponsiveAppNav._destinations.length,
          (int i) => NavigationDestination(
            icon: _CartBadgeIcon(
              index: i,
              icon: ResponsiveAppNav._destinations[i].icon ?? const Icon(Icons.circle),
            ),
            selectedIcon: _CartBadgeIcon(
              index: i,
              icon: ResponsiveAppNav._destinations[i].selectedIcon ??
                  ResponsiveAppNav._destinations[i].icon ??
                  const Icon(Icons.circle),
            ),
            label: labels[i],
          ),
        ),
      ),
    );
  }
}

class _TabletShell extends StatelessWidget {
  const _TabletShell({
    required this.currentIndex,
    required this.labels,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final List<String> labels;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.all,
            destinations: List<NavigationDestination>.generate(
              ResponsiveAppNav._destinations.length,
              (int i) => NavigationDestination(
                icon: _CartBadgeIcon(
                  index: i,
                  icon: ResponsiveAppNav._destinations[i].icon ??
                      const Icon(Icons.circle),
                ),
                selectedIcon: _CartBadgeIcon(
                  index: i,
                  icon: ResponsiveAppNav._destinations[i].selectedIcon ??
                      ResponsiveAppNav._destinations[i].icon ??
                      const Icon(Icons.circle),
                ),
                label: labels[i],
              ),
            ).map((NavigationDestination d) {
              return NavigationRailDestination(
                icon: d.icon,
                selectedIcon: d.selectedIcon,
                label: Text(d.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.currentIndex,
    required this.labels,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final List<String> labels;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationDrawer(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 8),
                child: Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...List<Widget>.generate(labels.length, (int i) {
                return NavigationDrawerDestination(
                  icon: _CartBadgeIcon(
                    index: i,
                    icon: ResponsiveAppNav._destinations[i].icon ??
                        const Icon(Icons.circle),
                  ),
                  selectedIcon: _CartBadgeIcon(
                    index: i,
                    icon: ResponsiveAppNav._destinations[i].selectedIcon ??
                        ResponsiveAppNav._destinations[i].icon ??
                        const Icon(Icons.circle),
                  ),
                  label: Text(labels[i]),
                );
              }),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CartBadgeIcon extends StatelessWidget {
  const _CartBadgeIcon({
    required this.index,
    required this.icon,
  });

  final int index;
  final Widget icon;

  static const _cartTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    if (index != _cartTabIndex) {
      return icon;
    }

    return BlocSelector<CartBloc, CartState, int>(
      selector: (CartState s) => s is CartLoaded ? s.totalQuantity : 0,
      builder: (BuildContext context, int count) {
        return Badge(
          isLabelVisible: count > 0,
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$count',
              key: ValueKey<int>(count),
            ),
          ),
          child: icon,
        );
      },
    );
  }
}
