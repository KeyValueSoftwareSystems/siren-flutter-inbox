import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class MarkAllNotificationsAsViewed {
  // TODO need to change the type once API wrapper is merged
  static Future<dynamic> markAllNotificationsAsViewed(
      {required String untilDate,}) async {
    final api = ApiClient(apiProvider());
    final id = SirenDataProvider.instance.recipientId;
    final data = {
      'lastOpenedAt': untilDate,
    };
    final apiResponse = await api.patch(
      path: 'recipients/$id',
      data: data,
    );
    return apiResponse;
  }
}
