import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/empty_widget.dart';

void main() {
  group('EmptyWidget', () {
    testWidgets('Renders correctly with empty data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return const EmptyWidget();
            },
          ),
        ),
      );

      expect(find.byType(EmptyWidget), findsOneWidget);

      expect(find.text(Strings.empty_title), findsOneWidget);
      expect(find.text(Strings.empty_desc), findsOneWidget);

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Renders with proper colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return MaterialApp(
                theme: theme.copyWith(),
                home: const EmptyWidget(),
              );
            },
          ),
        ),
      );
    });
  });
}
