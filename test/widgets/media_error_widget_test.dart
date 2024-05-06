import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/media_error_widget.dart';

void main() {
  testWidgets('MediaErrorWidget should render correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MediaErrorWidget(
            isDarkMode: false,
          ),
        ),
      ),
    );

    expect(find.byType(Align), findsOneWidget);
    expect(find.byType(Stack), findsWidgets);
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
