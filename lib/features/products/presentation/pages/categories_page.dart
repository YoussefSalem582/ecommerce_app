import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';

/// Grid browse screen for catalog taxonomy labels.
class CategoriesPage extends StatefulWidget {
  /// Creates categories route host.
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String>? _categories;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCategories());
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await getIt<GetCategoriesUseCase>().call();
    if (!mounted) {
      return;
    }
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (List<String> list) => setState(() {
        _loading = false;
        _categories = list;
      }),
    );
  }

  void _selectCategory(String category) {
    context.read<ProductListBloc>().add(ProductListCategorySelected(category));
    context.go(AppRoutes.home);
  }

  IconData _iconForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('electronic')) {
      return Icons.devices_outlined;
    }
    if (lower.contains('jewel')) {
      return Icons.diamond_outlined;
    }
    if (lower.contains('men')) {
      return Icons.man_outlined;
    }
    if (lower.contains('women')) {
      return Icons.woman_outlined;
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (_loading) {
            return const AppLoadingView();
          }
          if (_error != null) {
            return AppErrorView(message: _error!, onRetry: _loadCategories);
          }
          final categories = _categories ?? <String>[];
          if (categories.isEmpty) {
            return Center(child: Text(l10n.catalogEmpty));
          }

          final int crossAxisCount = constraints.maxWidth >= AppBreakpoints.tablet
              ? 4
              : constraints.maxWidth >= AppBreakpoints.mobile
                  ? 3
                  : 2;

          final grid = GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final String category = categories[index];
              return Card(
                key: index == 0 ? TestKeys.firstCategoryCard : null,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _selectCategory(category),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          _iconForCategory(category),
                          size: 36,
                          color: palette.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          if (constraints.maxWidth < AppBreakpoints.tablet) {
            return grid;
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: grid,
            ),
          );
        },
      ),
    );
  }
}
