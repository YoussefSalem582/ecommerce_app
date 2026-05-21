import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/product_grid_shimmer.dart';

import '../support/golden_harness.dart';

void main() {
  testWidgets('home catalog grid mobile golden', (WidgetTester tester) async {
    await pumpGolden(
      tester,
      wrapGoldenApp(
        child: Scaffold(
          appBar: AppBar(title: const Text('Shop')),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int cols =
                  ProductGridShimmer.columnsForWidth(constraints.maxWidth);
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    key: index == 0 ? TestKeys.firstProductCard : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Product ${index + 1}'),
                          Text(
                            '\$29.99',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      surfaceSize: const Size(390, 844),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home_mobile.png'),
    );
  });

  testWidgets('home catalog grid tablet golden', (WidgetTester tester) async {
    await pumpGolden(
      tester,
      wrapGoldenApp(
        child: Scaffold(
          appBar: AppBar(title: const Text('Shop')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final int cols =
                      ProductGridShimmer.columnsForWidth(constraints.maxWidth);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Product ${index + 1}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      surfaceSize: Size(AppBreakpoints.tablet + 100, 1280),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home_tablet.png'),
    );
  });
}
