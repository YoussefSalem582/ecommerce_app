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
import 'package:shop_flow/core/widgets/brand_badge.dart';
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
    switch (state) {
      case AuthAuthenticated():
        context.go(AppRoutes.home);
      case AuthUnauthenticated():
        final prefs = getIt<SharedPreferences>();
        final onboarded =
            prefs.getBool(StorageKeys.onboardingComplete) ?? false;
        context.go(onboarded ? AppRoutes.login : AppRoutes.onboarding);
      case AuthInitial() || AuthLoading() || AuthCredentialFailure() ||
          AuthRegistrationSucceeded():
        break;
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
      if (current case AuthAuthenticated() || AuthUnauthenticated()) {
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

    const Widget logo = BrandBadge(
      icon: Icons.shopping_bag_rounded,
      size: 104,
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
      listenWhen: (_, AuthState current) =>
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
              const SizedBox(height: 16),
              if (!disableAnimations)
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: palette.primary,
                  ),
                )
              else
                Icon(Icons.hourglass_top_rounded, color: palette.primary),
              const SizedBox(height: 12),
              Text(
                l10n.splashLoading,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
