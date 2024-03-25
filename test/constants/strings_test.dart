import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/strings.dart';

void main() {
  group('Strings', () {
    test('Constants are correct', () {
      expect(Strings.empty_title, 'No new notifications');
      expect(Strings.empty_desc, 'Check back later for updates and alerts.');
      expect(Strings.error_title, 'Oops! Something went wrong.');
      expect(
        Strings.error_desc,
        'Could not load the notifications. Please refresh the page.',
      );
    });
  });
}
