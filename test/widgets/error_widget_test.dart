import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';

void main() {
  group('CustomErrorWidget', () {
    testWidgets('Renders properly with default data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultErrorWidget(),
        ),
      );

      expect(find.byType(DefaultErrorWidget), findsOneWidget);

      expect(find.text(Strings.error_title), findsOneWidget);
      expect(find.text(Strings.error_desc), findsOneWidget);

      final circleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints!.maxWidth == 160 &&
            widget.constraints!.maxHeight == 160,
      );
      expect(circleFinder, findsOneWidget);
      final circleContainer = tester.widget<Container>(circleFinder);
      final iconWidget = circleContainer.child! as Icon;
      expect(iconWidget.icon, Icons.warning_rounded);
      expect(iconWidget.size, 84.0);

      final titleText = find.text(Strings.error_title);
      final descText = find.text(Strings.error_desc);
      expect(titleText, findsOneWidget);
      expect(descText, findsOneWidget);
    });
  });
}
