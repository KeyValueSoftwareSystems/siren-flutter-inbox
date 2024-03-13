import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class ReadNotificationById {
  ReadNotificationById._internal();
  static final ReadNotificationById instance = ReadNotificationById._internal();

  final ApiClient api = ApiClient(apiProvider());

  static final String _apiPath = '${Generics.API_PATH}/notifications';

  Future<ApiResponse> readNotificationById({
    required String notificationId,
  }) async {
    final result = ApiResponse()..isLoading = true;
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.NOTIFICATION_READ_ERROR;

    final apiResponse = await api.patch(
      path: '$_apiPath/$notificationId',
      data: {
        'isRead': true,
        'isDelivered': true,
      },
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
