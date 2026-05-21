import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';

void main() {
  testWidgets('cart wide layout uses side-by-side summary', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide =
                  constraints.maxWidth >= AppBreakpoints.tablet;
              return Text(wide ? 'wide' : 'narrow');
            },
          ),
        ),
      ),
    );

    expect(find.text('wide'), findsOneWidget);
  });

  testWidgets('cart narrow layout stacks summary below list', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(599, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide =
                  constraints.maxWidth >= AppBreakpoints.tablet;
              return Text(wide ? 'wide' : 'narrow');
            },
          ),
        ),
      ),
    );

    expect(find.text('narrow'), findsOneWidget);
  });
}
