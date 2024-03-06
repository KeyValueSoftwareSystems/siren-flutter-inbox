import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class MarkAllNotificationsAsViewed {
  // TODO need to change the type once API wrapper is merged
  static Future<dynamic> markAllNotificationsAsViewed({
    required String untilDate,
  }) async {
    final api = ApiClient(apiProvider());
    final data = {
      'lastOpenedAt': untilDate,
    };
    final apiResponse = await api.patch(
      path: Generics.API_PATH,
      data: data,
    );
    return apiResponse;
  }
}
