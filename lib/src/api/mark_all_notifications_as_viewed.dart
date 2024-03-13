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
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.UPDATE_VIEWED_ERROR;

    final data = {
      'lastOpenedAt': untilDate,
    };

    final apiResponse = await api.patch(
      path: Generics.API_PATH,
      data: data,
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      apiError
        ..errorCode = ApiResponse.fromJson(apiResponse.data).error?.errorCode
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..error = Generics.DEFAULT_ERROR;
    }

    return result;
  }
}
