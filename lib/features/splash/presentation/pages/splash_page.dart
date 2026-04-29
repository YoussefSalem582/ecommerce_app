import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';

/// Splash gate — routes users once session restoration resolves.
///
/// Session restore is kicked off from here (not [main]) so [BlocListener]
/// observes `AuthLoading` → terminal states. Dispatching in [main] before
/// [runApp] often completes restore before this widget mounts, and listeners
/// do not replay the current state — leaving the UI stuck on splash.
class SplashPage extends StatefulWidget {
  /// Creates splash route content.
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _sessionRequested = false;

  void _routeForAuth(AuthState state, BuildContext context) {
    if (!mounted) {
      return;
    }
    if (state is AuthAuthenticated) {
      context.go(AppRoutes.home);
    } else if (state is AuthUnauthenticated) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _sessionRequested) {
        return;
      }
      _sessionRequested = true;
      final AuthBloc bloc = context.read<AuthBloc>();
      final AuthState current = bloc.state;
      // Covers rare rebuilds where bloc already resolved before listener ran.
      if (current is AuthAuthenticated || current is AuthUnauthenticated) {
        _routeForAuth(current, context);
        return;
      }
      bloc.add(const AuthSessionRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (BuildContext context, AuthState state) {
        _routeForAuth(state, context);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.shopping_bag_rounded,
                size: 72,
                color: palette.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(l10n.splashLoading),
            ],
          ),
        ),
      ),
    );
  }
}
