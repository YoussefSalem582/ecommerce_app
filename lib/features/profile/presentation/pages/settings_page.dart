import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/l10n/language_cubit.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_cubit.dart';

/// Theme, language, and debug preferences screen.
class SettingsPage extends StatelessWidget {
  /// Creates settings route.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final themeSection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.settingsThemeSection,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (BuildContext context, ThemeMode mode) {
                  return Column(
                    children: <Widget>[
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.themeLight),
                        value: ThemeMode.light,
                        groupValue: mode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            context.read<ThemeCubit>().setTheme(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        key: TestKeys.settingsThemeDark,
                        title: Text(l10n.themeDark),
                        value: ThemeMode.dark,
                        groupValue: mode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            context.read<ThemeCubit>().setTheme(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.themeSystem),
                        value: ThemeMode.system,
                        groupValue: mode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            context.read<ThemeCubit>().setTheme(value);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );

          final languageSection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  l10n.settingsLanguageSection,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              BlocBuilder<LanguageCubit, Locale>(
                builder: (BuildContext context, Locale locale) {
                  return Column(
                    children: <Widget>[
                      RadioListTile<Locale>(
                        title: Text(l10n.languageEnglish),
                        value: const Locale('en'),
                        groupValue: locale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            context.read<LanguageCubit>().setLocale(value);
                          }
                        },
                      ),
                      RadioListTile<Locale>(
                        key: TestKeys.settingsLanguageArabic,
                        title: Text(l10n.languageArabic),
                        value: const Locale('ar'),
                        groupValue: locale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            context.read<LanguageCubit>().setLocale(value);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );

          final debugSection = kDebugMode
              ? <Widget>[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      l10n.settingsEnvironmentSection,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_outlined),
                    title: Text(
                      l10n.settingsEnvironmentAppEnv(getIt<AppConfig>().appEnv),
                    ),
                    subtitle: Text(
                      getIt<AppConfig>().stripePublishableKey != null
                          ? l10n.settingsEnvironmentStripeOn
                          : l10n.settingsEnvironmentStripeOff,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: Text(l10n.debugLogs),
                    subtitle: Text(l10n.debugLogsHint),
                    onTap: () => context.push(AppRoutes.debugLogs),
                  ),
                ]
              : <Widget>[];

          if (constraints.maxWidth < AppBreakpoints.tablet) {
            return ListView(
              children: <Widget>[
                themeSection,
                const Divider(),
                languageSection,
                ...debugSection,
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: themeSection),
                      const VerticalDivider(width: 32),
                      Expanded(child: languageSection),
                    ],
                  ),
                ),
              ),
              ...debugSection,
            ],
          );
        },
      ),
    );
  }
}
