import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class NotificationsBulkUpdate {
  // TODO need to change the type once API wrapper is merged
  static Future<dynamic> notificationsBulkUpdate({required Map<String, dynamic> data}) async {
    final api = ApiClient(apiProvider());
    final id = SirenDataProvider.instance.recipientId;

    final apiResponse = await api.post(
      path: 'api/v2/in-app/recipients/$id/notifications/bulk-update',
      data: data,
    );
    return apiResponse;
  }
}
