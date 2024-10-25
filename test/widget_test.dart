import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('Conversion app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MeasuresConverter());

    // Verify that the initial value is empty.
    expect(find.text('Value'), findsOneWidget);
    expect(find.text('Invalid Input'), findsNothing);

    // Enter a valid value to convert.
    await tester.enterText(find.byType(TextField), '10');
    await tester.pump();

    // Verify that the value is entered correctly.
    expect(find.text('10'), findsOneWidget);

    // Select 'Meters' as the from unit.
    await tester.tap(find.text('Meters').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feet').last);
    await tester.pumpAndSettle();

    // Select 'Feet' as the to unit.
    await tester.tap(find.text('Feet').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles').last);
    await tester.pumpAndSettle();

    // Tap the convert button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify the converted value.
    expect(find.text('10.0 Feet are 0.002 Miles'), findsOneWidget);

    // Enter an invalid value to convert.
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    // Verify that the invalid input warning is shown.
    expect(find.text('Invalid Input'), findsOneWidget);
  });
}