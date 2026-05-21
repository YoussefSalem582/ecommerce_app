import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// ShopFlow-like theme for goldens without Google Fonts network fetches.
ThemeData goldenTheme({required Brightness brightness}) {
  final AppPalette palette =
      brightness == Brightness.dark ? appPaletteDark : appPaletteLight;
  final bool isDark = brightness == Brightness.dark;
  final TextTheme textTheme =
      Typography.material2021(platform: TargetPlatform.android).black.copyWith(
    bodyLarge: TextStyle(color: palette.onSurface),
    bodyMedium: TextStyle(color: palette.onSurface),
    titleLarge: TextStyle(color: palette.onSurface),
    titleMedium: TextStyle(color: palette.onSurface),
  );
  final ColorScheme scheme = isDark
      ? ColorScheme.dark(
          primary: palette.primary,
          onPrimary: palette.onPrimary,
          secondary: palette.secondary,
          surface: palette.surface,
          onSurface: palette.onSurface,
          error: palette.error,
        )
      : ColorScheme.light(
          primary: palette.primary,
          onPrimary: palette.onPrimary,
          secondary: palette.secondary,
          surface: palette.surface,
          onSurface: palette.onSurface,
          error: palette.error,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    extensions: <ThemeExtension<dynamic>>[palette],
    scaffoldBackgroundColor: palette.surface,
    textTheme: textTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accent,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

/// Wraps [child] in MaterialApp with ShopFlow theme and l10n for golden tests.
Widget wrapGoldenApp({
  required Widget child,
  ThemeMode themeMode = ThemeMode.light,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: goldenTheme(brightness: Brightness.light),
    darkTheme: goldenTheme(brightness: Brightness.dark),
    themeMode: themeMode,
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: child,
  );
}

/// Sets a fixed surface size for golden captures.
Future<void> setGoldenSurface(
  WidgetTester tester,
  Size size,
) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

/// Pumps [widget] and settles animations for golden comparison.
Future<void> pumpGolden(
  WidgetTester tester,
  Widget widget, {
  Size surfaceSize = const Size(390, 844),
}) async {
  await setGoldenSurface(tester, surfaceSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

/// Provides a [BlocProvider] shell for golden/widget tests.
Widget withBlocProvider<T extends StateStreamableSource<Object?>>(
  T bloc,
  Widget child,
) {
  return BlocProvider<T>.value(value: bloc, child: child);
}
