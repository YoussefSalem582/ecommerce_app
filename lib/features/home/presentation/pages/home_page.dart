import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_app_bar.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_body.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/widgets/catalog_filter_sheet.dart';

/// Authenticated catalog shell — responsive grid, chips, search, shimmer.
class HomePage extends StatefulWidget {
  /// Creates catalog host route.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProductListBloc>().add(const ProductListStarted());
      context.read<CartBloc>().add(const CartRefreshRequested());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<ProductListBloc>().add(
      ProductListSearchSubmitted(_searchController.text),
    );
  }

  void _showFilterSheet(ProductListLoaded loaded) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => CatalogFilterSheet(loaded: loaded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (BuildContext context, ProductListState listState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState authState) {
            return Scaffold(
              appBar: HomeAppBar(authState: authState, listState: listState),
              floatingActionButton: kDebugMode
                  ? FloatingActionButton.small(
                      tooltip: l10n.debugLogs,
                      onPressed: () => context.push(AppRoutes.debugLogs),
                      child: const Icon(Icons.bug_report_outlined),
                    )
                  : null,
              body: HomeBody(
                listState: listState,
                searchController: _searchController,
                onSearchSubmitted: _submitSearch,
                onProductTap: (int id) => context.push(AppRoutes.product(id)),
                onShowFilterSheet: _showFilterSheet,
              ),
            );
          },
        );
      },
    );
  }
}
