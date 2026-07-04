import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/l10n/language_cubit.dart';
import 'package:shop_flow/core/preferences/app_currency.dart';
import 'package:shop_flow/core/preferences/currency_cubit.dart';
import 'package:shop_flow/core/preferences/notification_prefs_cubit.dart';
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
          Widget sectionCard(Widget child) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: child,
                  ),
                ),
              );

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

          final currencySection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  l10n.settingsCurrencySection,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              BlocBuilder<CurrencyCubit, AppCurrency>(
                builder: (BuildContext context, AppCurrency currency) {
                  return Column(
                    children: AppCurrency.values.map((AppCurrency option) {
                      return RadioListTile<AppCurrency>(
                        key: option == AppCurrency.eur
                            ? TestKeys.settingsCurrencyEur
                            : null,
                        title: Text(_currencyLabel(l10n, option)),
                        value: option,
                        groupValue: currency,
                        onChanged: (AppCurrency? value) {
                          if (value != null) {
                            context.read<CurrencyCubit>().setCurrency(value);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );

          final notificationsSection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  l10n.settingsNotificationsSection,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              BlocBuilder<NotificationPrefsCubit, bool>(
                builder: (BuildContext context, bool enabled) {
                  return SwitchListTile(
                    key: TestKeys.settingsOrderNotifications,
                    title: Text(l10n.settingsOrderUpdatesLabel),
                    subtitle: Text(l10n.settingsOrderUpdatesHint),
                    value: enabled,
                    onChanged: (bool value) => context
                        .read<NotificationPrefsCubit>()
                        .setOrderUpdatesEnabled(value),
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
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                sectionCard(themeSection),
                sectionCard(languageSection),
                sectionCard(currencySection),
                sectionCard(notificationsSection),
                ...debugSection,
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: sectionCard(themeSection)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            sectionCard(languageSection),
                            sectionCard(currencySection),
                            sectionCard(notificationsSection),
                          ],
                        ),
                      ),
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

  String _currencyLabel(AppLocalizations l10n, AppCurrency currency) {
    return switch (currency) {
      AppCurrency.usd => l10n.currencyUsd,
      AppCurrency.eur => l10n.currencyEur,
      AppCurrency.sar => l10n.currencySar,
    };
  }
}
