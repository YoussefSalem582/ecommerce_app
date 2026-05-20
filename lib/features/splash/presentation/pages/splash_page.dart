import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';

/// Splash gate — routes users once session restoration resolves.
class SplashPage extends StatefulWidget {
  /// Creates splash route content.
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _sessionRequested = false;

  Future<void> _routeForAuth(AuthState state, BuildContext context) async {
    if (!mounted) {
      return;
    }
    if (state is AuthAuthenticated) {
      context.go(AppRoutes.home);
      return;
    }
    if (state is AuthUnauthenticated) {
      final prefs = getIt<SharedPreferences>();
      final onboarded =
          prefs.getBool(StorageKeys.onboardingComplete) ?? false;
      context.go(onboarded ? AppRoutes.login : AppRoutes.onboarding);
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
      if (current is AuthAuthenticated || current is AuthUnauthenticated) {
        unawaited(_routeForAuth(current, context));
        return;
      }
      bloc.add(const AuthSessionRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final logo = Icon(
      Icons.shopping_bag_rounded,
      size: 72,
      color: palette.primary,
    );

    final animatedLogo = disableAnimations || kIsWeb
        ? logo
        : logo
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.85, 0.85),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.easeOutBack,
            );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (BuildContext context, AuthState state) {
        unawaited(_routeForAuth(state, context));
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              animatedLogo,
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
