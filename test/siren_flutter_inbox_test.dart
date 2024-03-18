import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomText Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text(''),
        ),
      ),
    );

    // Verify that the text is displayed.
    expect(find.text('THE DEMO TEXT WIDGET'), findsOneWidget);
  });
}
