import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class NotificationsBulkUpdate {
  static Future<ApiResponse> notificationsBulkUpdate({
    required Map<String, dynamic> data,
  }) async {
    final api = ApiClient(apiProvider());
    final apiPath = '${Generics.API_PATH}/notifications/bulk-update';
    final result = ApiResponse()..isLoading;
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.NOTIFICATION_DELETE_ERROR;

    final apiResponse = await api.post(
      path: apiPath,
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
        ..rawResponse = apiResponse
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..rawResponse = apiResponse
        ..error = Generics.defaultError;
    }

    return result;
  }
}
