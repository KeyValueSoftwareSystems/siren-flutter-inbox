import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class MarkNotificationsAsViewed {
  // TODO need to change the type once API wrapper is merged
  static Future<dynamic> markNotificationsAsViewed(String lastOpenedAt) async {
    final api = ApiClient(apiProvider());
    final id = SirenDataProvider.instance.recipientId;
    final data = {
      'lastOpenedAt': lastOpenedAt,
    };
    final apiResponse = await api.patch(
      path: 'api/v2/in-app/recipients/$id',
      data: data,
    );
    return apiResponse;
  }
}
