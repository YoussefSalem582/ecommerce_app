import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shop_flow/features/profile/presentation/bloc/profile_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/profile_state.dart';
import 'package:shop_flow/features/profile/presentation/widgets/profile_avatar_widget.dart';

/// Profile tab — avatar, account info, settings, and logout.
class ProfilePage extends StatefulWidget {
  /// Creates profile shell tab.
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProfileBloc>().add(const ProfileStarted());
    });
  }

  String _displayName(ProfileLoaded state) {
    final first = state.user.firstName?.trim();
    final last = state.user.lastName?.trim();
    if (first != null && first.isNotEmpty) {
      if (last != null && last.isNotEmpty) {
        return '$first $last';
      }
      return first;
    }
    return state.user.username;
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.logoutConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const AppLoadingView();
          }

          if (state is ProfileFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context
                  .read<ProfileBloc>()
                  .add(const ProfileRefreshRequested()),
            );
          }

          if (state is! ProfileLoaded) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Center(
                child: ProfileAvatarWidget(
                  user: state.user,
                  avatarPath: state.avatarPath,
                  radius: 56,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _displayName(state),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (state.user.email != null && state.user.email!.isNotEmpty)
                Center(
                  child: Text(
                    state.user.email!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  l10n.welcomeUser(state.user.username),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await context.push(AppRoutes.editProfile);
                  if (!context.mounted) {
                    return;
                  }
                  context
                      .read<ProfileBloc>()
                      .add(const ProfileRefreshRequested());
                  context.read<AuthBloc>().add(const AuthSessionRequested());
                },
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.editProfileTitle),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.logoutButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
