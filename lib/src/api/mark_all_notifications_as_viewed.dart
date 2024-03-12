import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class MarkAllNotificationsAsViewed {
  static Future<ApiResponse> markAllNotificationsAsViewed({
    required String untilDate,
  }) async {
    final api = ApiClient(apiProvider());
    final result = ApiResponse()..isLoading;

    final data = {
      'lastOpenedAt': untilDate,
    };

    final apiResponse = await api.patch(
      path: Generics.API_PATH,
      data: data,
    );

    final apiError = ApiResponse.fromJson(apiResponse.data).error;

    result
      ..isLoading = false
      ..isSuccess = apiResponse.statusCode == 200
      ..isError = apiResponse.statusCode != 200
      ..error = apiError;

    return result;
  }
}
