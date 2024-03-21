import 'package:flutter_test/flutter_test.dart';
import 'package:siren_flutter_inbox/src/models/unviewed_notification_count_model.dart';

void main() {
  group('UnViewedNotificationsCountModel', () {
    test('Constructor should initialize totalUnViewed', () {
      // Arrange
      final model = UnViewedNotificationsCountModel(totalUnViewed: 10);

      // Assert
      expect(model.totalUnViewed, 10);
    });

    test('fromJson should correctly parse JSON', () {
      // Arrange
      final json = {'totalUnviewed': 5};

      // Act
      final model = UnViewedNotificationsCountModel.fromJson(json);

      // Assert
      expect(model.totalUnViewed, 5);
    });

    test('fromJson should default totalUnViewed to 0 if not present in JSON',
        () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final model = UnViewedNotificationsCountModel.fromJson(json);

      // Assert
      expect(model.totalUnViewed, 0);
    });

    test('fromJson should default totalUnViewed to 0 if JSON value is null',
        () {
      // Arrange
      final json = {'totalUnviewed': null};

      // Act
      final model = UnViewedNotificationsCountModel.fromJson(json);

      // Assert
      expect(model.totalUnViewed, 0);
    });
  });
}
