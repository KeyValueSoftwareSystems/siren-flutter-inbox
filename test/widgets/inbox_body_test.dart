import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/error_widget.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/inbox_body.dart';
import 'package:sirenapp_flutter_inbox/src/widgets/loader_widget.dart';

void main() {
  testWidgets('InboxBody displays loader when isLoading is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InboxBody(
          currentTheme: ThemeData(),
          isLoading: true,
          loadingNextPage: false,
          isError: false,
          notifications: [],
          deleteNotification: (id) async {},
          markAsRead: (id) {},
          customNotificationCard: null,
          onNotificationCardClick: null,
          deletingNotificationId: null,
          disableAutoMarkAsRead: false,
          totalElements: 0,
          onRefresh: () async {},
          endReached: false,
          onEndReached: () {},
          scrollController: ScrollController(),
        ),
      ),
    );

    expect(find.byType(LoaderWidget), findsOneWidget);
  });

  testWidgets('InboxBody displays error widget when isError is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InboxBody(
          currentTheme: ThemeData(),
          isLoading: false,
          loadingNextPage: false,
          isError: true,
          notifications: [],
          deleteNotification: (id) async {},
          markAsRead: (id) {},
          customNotificationCard: null,
          onNotificationCardClick: null,
          deletingNotificationId: null,
          disableAutoMarkAsRead: false,
          totalElements: 0,
          onRefresh: () async {},
          endReached: false,
          onEndReached: () {},
          scrollController: ScrollController(),
        ),
      ),
    );

    expect(find.byType(DefaultErrorWidget), findsOneWidget);
  });
}
