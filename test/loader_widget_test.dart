import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siren_flutter_inbox/src/widgets/loader_widget.dart';

void main() {
  group('CardLoaderWidget', () {
    testWidgets('Renders properly with default data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CardLoaderWidget(),
        ),
      );

      // Verify that CardLoaderWidget is rendered
      expect(find.byType(CardLoaderWidget), findsOneWidget);

      // Find the circular Container
      final circularContainerFinder = find.descendant(
        of: find.byType(CardLoaderWidget),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).shape == BoxShape.circle &&
              widget.constraints!.maxWidth == 42 &&
              widget.constraints!.maxHeight == 42,
        ),
      );

      // Verify that only one circular Container is found
      expect(circularContainerFinder, findsOneWidget);

      // Find the Padding containing the Row
      final paddingWithRowFinder = find.descendant(
        of: find.byType(CardLoaderWidget),
        matching: find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Row,
        ),
      );

      // Verify that only one Padding containing a Row is found
      expect(paddingWithRowFinder, findsOneWidget);
    });
  });
}
