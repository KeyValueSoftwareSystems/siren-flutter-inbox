import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';

void main() {
  testWidgets('CustomText Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomText(),
      ),
    ));

    // Verify that the text is displayed.
    expect(find.text('THE DEMO TEXT WIDGET'), findsOneWidget);
  });
}
