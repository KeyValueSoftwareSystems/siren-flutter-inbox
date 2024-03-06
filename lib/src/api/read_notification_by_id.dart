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
    try {
      final result = ApiResponse()..isLoading = true;

      final apiResponse = await api.patch(
        path: '$_apiPath/$notificationId',
        data: {
          'isRead': true,
          'isDelivered': true,
        },
      ) as Map<String, dynamic>;
      final apiError = ApiResponse.fromJson(apiResponse).error;

      result
        ..isLoading = false
        ..isSuccess = apiError?.errorCode.isEmpty ?? true
        ..isError = apiError?.errorCode.isNotEmpty ?? false
        ..error = apiError;

      return result;
    } catch (error) {
      final result = ApiResponse()
        ..isLoading = false
        ..isError = true
        ..error = ApiErrorDetails(
          errorCode: '500',
          message: 'Internal Server Error',
        );
      return result;
    }
  }
}
