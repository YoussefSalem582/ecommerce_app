import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/l10n/language_cubit.dart';
import 'package:shop_flow/core/preferences/currency_cubit.dart';
import 'package:shop_flow/core/preferences/notification_prefs_cubit.dart';
import 'package:shop_flow/core/theme/theme_cubit.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';
import 'package:shop_flow/features/profile/presentation/pages/settings_page.dart';

import '../../support/app_test_bootstrap.dart';

void main() {
  setUp(() async {
    await bootstrapShopFlowTests();
  });

  tearDown(() async {
    await tearDownShopFlowTests();
  });

  testWidgets('settings shows currency and notification toggles', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final prefs = GetIt.instance<SharedPreferences>();
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
          BlocProvider<LanguageCubit>.value(value: getIt<LanguageCubit>()),
          BlocProvider<CurrencyCubit>.value(value: CurrencyCubit(prefs)),
          BlocProvider<NotificationPrefsCubit>.value(
            value: NotificationPrefsCubit(prefs),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(TestKeys.settingsCurrencyEur), findsOneWidget);
    expect(find.byKey(TestKeys.settingsOrderNotifications), findsOneWidget);
  });

  test('product list bloc applies client-side sort', () async {
    final bloc = getIt<ProductListBloc>();
    bloc.add(const ProductListStarted());
    await bloc.stream.firstWhere((ProductListState s) => s is ProductListLoaded);

    bloc.add(const ProductListSortChanged(ProductSortOption.priceAsc));
    final ProductListState state = await bloc.stream
        .firstWhere((ProductListState s) => s is ProductListLoaded);
    final ProductListLoaded sorted = state as ProductListLoaded;

    if (sorted.products.length >= 2) {
      expect(
        sorted.products.first.price <= sorted.products.last.price,
        isTrue,
      );
    }
  });
}
