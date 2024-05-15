import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/models/unviewed_notification_count_model.dart';

void main() {
  group('UnViewedNotificationsCountModel', () {
    test('Constructor should initialize totalUnViewed', () {
      final model = UnViewedNotificationsCountModel(totalUnViewed: 10);

      expect(model.totalUnViewed, 10);
    });

    test('fromJson should correctly parse JSON', () {
      final json = {'totalUnviewed': 5};

      final model = UnViewedNotificationsCountModel.fromJson(json);

      expect(model.totalUnViewed, 5);
    });

    test('fromJson should default totalUnViewed to 0 if not present in JSON',
        () {
      final json = <String, dynamic>{};
      final model = UnViewedNotificationsCountModel.fromJson(json);

      expect(model.totalUnViewed, 0);
    });

    test('fromJson should default totalUnViewed to 0 if JSON value is null',
        () {
      final json = {'totalUnviewed': null};

      final model = UnViewedNotificationsCountModel.fromJson(json);

      expect(model.totalUnViewed, 0);
    });
  });
}
