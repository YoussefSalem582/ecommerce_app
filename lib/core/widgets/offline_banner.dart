import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/network/connectivity_cubit.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Amber banner shown when [ConnectivityCubit] reports offline.
class OfflineBanner extends StatelessWidget {
  /// Wraps [child] and optionally inserts the connectivity strip.
  const OfflineBanner({required this.child, super.key});

  /// Primary page body below the optional banner.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.of(context).disableAnimations;

    final palette = context.appPalette;

    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (BuildContext context, ConnectivityStatus status) {
        final show = status == ConnectivityStatus.offline;
        if (!show) {
          return child;
        }

        final banner = Material(
          color: palette.accent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                Icon(Icons.wifi_off, color: palette.onPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).offlineBannerTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: palette.onPrimary),
                      ),
                      Text(
                        AppLocalizations.of(context).offlineBannerBody,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: palette.onPrimary.withValues(alpha: 0.85),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        if (disableAnimations) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              banner,
              Expanded(child: child),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: banner,
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
