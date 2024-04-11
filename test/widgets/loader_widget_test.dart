import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';

void main() {
  group('CardLoaderWidget', () {
    testWidgets('Renders properly with default data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CardLoaderWidget(
            hideAvatar: false,
          ),
        ),
      );

      expect(find.byType(CardLoaderWidget), findsOneWidget);

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

      expect(circularContainerFinder, findsOneWidget);

      final paddingWithRowFinder = find.descendant(
        of: find.byType(CardLoaderWidget),
        matching: find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Row,
        ),
      );

      expect(paddingWithRowFinder, findsOneWidget);
    });
  });
}
