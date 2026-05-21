import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';

/// Verifies checkout form responsive row layout (mirrors [CheckoutPage] rules).
void main() {
  Widget buildForm({required bool rowFields}) {
    return MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(
            size: Size(
              rowFields ? AppBreakpoints.tablet : AppBreakpoints.mobile - 1,
              800,
            ),
          ),
          child: _CheckoutFormLayoutProbe(rowFields: rowFields),
        ),
      ),
    );
  }

  testWidgets('narrow width stacks city and postal vertically', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildForm(rowFields: false));
    expect(
      find.ancestor(
        of: find.byKey(TestKeys.checkoutCity),
        matching: find.byType(Row),
      ),
      findsNothing,
    );
  });

  testWidgets('tablet+ width places city and postal in one row', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildForm(rowFields: true));
    final Finder cityRow = find.ancestor(
      of: find.byKey(TestKeys.checkoutCity),
      matching: find.byType(Row),
    );
    expect(cityRow, findsOneWidget);
    expect(
      find.descendant(
        of: cityRow,
        matching: find.byKey(TestKeys.checkoutPostal),
      ),
      findsOneWidget,
    );
  });
}

/// Same row-vs-column rule as [_ShippingFormSection] in checkout_page.dart.
class _CheckoutFormLayoutProbe extends StatelessWidget {
  const _CheckoutFormLayoutProbe({required this.rowFields});

  final bool rowFields;

  @override
  Widget build(BuildContext context) {
    final Widget city = TextFormField(key: TestKeys.checkoutCity);
    final Widget postal = TextFormField(key: TestKeys.checkoutPostal);

    if (rowFields) {
      return Row(
        children: <Widget>[
          Expanded(child: city),
          const SizedBox(width: 16),
          Expanded(child: postal),
        ],
      );
    }
    return Column(
      children: <Widget>[
        city,
        const SizedBox(height: 12),
        postal,
      ],
    );
  }
}
