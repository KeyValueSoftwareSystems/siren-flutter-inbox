import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class DeleteNotificationById {
  DeleteNotificationById._internal();
  static final DeleteNotificationById instance = DeleteNotificationById._internal();

  final ApiClient api = ApiClient(apiProvider());

  static const String _apiPath =
      'api/v2/in-app/recipients/64a0811d-982b-4f8e-9601-d5adcc1fe7e2/notifications';
  static const String _authorizationToken =
      'Bearer 95d5544c106543e799084e19a988fd31';

  Future<ApiResponse> deleteNotificationById({
    required String notificationId,
  }) async {
    try {
      final result = ApiResponse()..isLoading = true;

      final apiResponse = await api.delete(
        path: '$_apiPath/$notificationId',
        options: Options(
          headers: {
            'authorization': _authorizationToken,
          },
        ),
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
