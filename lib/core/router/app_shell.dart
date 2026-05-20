import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/widgets/responsive_app_nav.dart';
import 'package:shop_flow/core/widgets/shake_debug_listener.dart';

/// Authenticated tab shell hosting Home, Cart, Orders, and Profile branches.
class AppShell extends StatelessWidget {
  /// Wraps [navigationShell] with responsive navigation chrome.
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  /// Branch navigator from [StatefulShellRoute].
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final shell = ResponsiveAppNav(navigationShell: navigationShell);

    if (!kDebugMode) {
      return shell;
    }

    return ShakeDebugListener(
      onShake: () => context.push(AppRoutes.debugLogs),
      child: shell,
    );
  }
}
