import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class NotificationsBulkUpdate {
  // TODO need to change the type once API wrapper is merged
  static Future<dynamic> notificationsBulkUpdate({
    required Map<String, dynamic> data,
  }) async {
    final api = ApiClient(apiProvider());
    final apiPath = '${Generics.API_PATH}/notifications/bulk-update';

    final apiResponse = await api.post(
      path: apiPath,
      data: data,
    );
    return apiResponse;
  }
}
