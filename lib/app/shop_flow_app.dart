import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/l10n/language_cubit.dart';
import 'package:shop_flow/core/network/connectivity_cubit.dart';
import 'package:shop_flow/core/router/app_router.dart';
import 'package:shop_flow/core/theme/app_theme.dart';
import 'package:shop_flow/core/theme/theme_cubit.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';

/// Root widget wiring localization, theme, routing, and cross-cutting cubits.
class ShopFlowApp extends StatelessWidget {
  /// Creates the ShopFlow application widget.
  const ShopFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().config;

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        BlocProvider<ProductListBloc>.value(value: getIt<ProductListBloc>()),
        BlocProvider<ProductDetailBloc>.value(
          value: getIt<ProductDetailBloc>(),
        ),
        BlocProvider<CartBloc>.value(value: getIt<CartBloc>()),
        BlocProvider<CheckoutBloc>.value(value: getIt<CheckoutBloc>()),
        BlocProvider<OrdersBloc>.value(value: getIt<OrdersBloc>()),
        BlocProvider<WishlistCubit>.value(value: getIt<WishlistCubit>()),
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<LanguageCubit>.value(value: getIt<LanguageCubit>()),
        BlocProvider<ConnectivityCubit>.value(
          value: getIt<ConnectivityCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (BuildContext context, Locale locale) {
              final rtl = locale.languageCode == 'ar';

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: router,
                builder: (BuildContext context, Widget? child) {
                  return Directionality(
                    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
