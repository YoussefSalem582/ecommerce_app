import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_bloc.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/pages/wishlist_page.dart';

import '../../support/app_test_bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await bootstrapShopFlowTests();
  });

  tearDownAll(() async {
    await tearDownShopFlowTests();
  });

  Widget buildWishlistApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<WishlistPageBloc>.value(
            value: GetIt.instance<WishlistPageBloc>(),
          ),
          BlocProvider<WishlistCubit>.value(
            value: GetIt.instance<WishlistCubit>(),
          ),
        ],
        child: const WishlistPage(),
      ),
    );
  }

  testWidgets('wishlist page shows empty state when no favorites', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWishlistApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.text('Your wishlist is empty'), findsOneWidget);
  });
}
