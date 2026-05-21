import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';

import '../support/golden_harness.dart';

void main() {
  testWidgets('checkout form mobile golden', (WidgetTester tester) async {
    await pumpGolden(
      tester,
      wrapGoldenApp(
        child: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: _CheckoutFormGoldenProbe(
              rowFields: false,
            ),
          ),
        ),
      ),
      surfaceSize: const Size(390, 844),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/checkout_mobile.png'),
    );
  });

  testWidgets('checkout form tablet golden', (WidgetTester tester) async {
    await pumpGolden(
      tester,
      wrapGoldenApp(
        child: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(size: Size(AppBreakpoints.tablet, 1280)),
            child: const _CheckoutFormGoldenProbe(rowFields: true),
          ),
        ),
      ),
      surfaceSize: const Size(800, 1280),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/checkout_tablet.png'),
    );
  });
}

class _CheckoutFormGoldenProbe extends StatelessWidget {
  const _CheckoutFormGoldenProbe({required this.rowFields});

  final bool rowFields;

  @override
  Widget build(BuildContext context) {
    final Widget city = TextFormField(
      key: TestKeys.checkoutCity,
      decoration: const InputDecoration(labelText: 'City'),
    );
    final Widget postal = TextFormField(
      key: TestKeys.checkoutPostal,
      decoration: const InputDecoration(labelText: 'Postal code'),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            key: TestKeys.checkoutFullName,
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: TestKeys.checkoutStreet,
            decoration: const InputDecoration(labelText: 'Street'),
          ),
          const SizedBox(height: 12),
          if (rowFields)
            Row(
              children: <Widget>[
                Expanded(child: city),
                const SizedBox(width: 16),
                Expanded(child: postal),
              ],
            )
          else ...<Widget>[
            city,
            const SizedBox(height: 12),
            postal,
          ],
          const SizedBox(height: 12),
          TextFormField(
            key: TestKeys.checkoutCountry,
            decoration: const InputDecoration(labelText: 'Country'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: TestKeys.checkoutPayButton,
            onPressed: () {},
            child: const Text('Pay now'),
          ),
        ],
      ),
    );
  }
}
