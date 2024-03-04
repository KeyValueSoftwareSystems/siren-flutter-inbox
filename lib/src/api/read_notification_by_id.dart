import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class ReadNotificationById {
  ReadNotificationById._internal();
  static final ReadNotificationById instance = ReadNotificationById._internal();

  final ApiClient api = ApiClient(apiProvider());

  static const String _apiPath =
      'api/v2/in-app/recipients/4c6bc2b6-b2ca-49cc-8599-39b651d62520/notifications';
  static const String _authorizationToken =
      'Bearer 080f749eb36e4d3fa7535112cbcdc0be';

  Future<ApiResponse> readNotificationById({
    required String notificationId,
  }) async {
    try {
      final result = ApiResponse()..isLoading = true;

      final apiResponse = await api.patch(
        path: '$_apiPath/$notificationId',
        options: Options(
          headers: {
            'authorization': _authorizationToken,
          },
        ),
         data: {
          'isRead': true,
          'isDelivered': false,
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
