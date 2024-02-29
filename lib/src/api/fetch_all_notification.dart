import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class FetchAllNotifications {
  factory FetchAllNotifications() {
    return instance;
  }

  FetchAllNotifications._internal();
  static final FetchAllNotifications instance =
      FetchAllNotifications._internal();

  final ApiClient api = ApiClient(apiProvider());

  // Constants
  static const String _apiPath =
      'api/v2/in-app/recipients/64a0811d-982b-4f8e-9601-d5adcc1fe7e2/notifications';
  static const String _authorizationToken =
      'Bearer 95d5544c106543e799084e19a988fd31';

  List<NotificationDataType> convertJsonToNotificationList(
    List<dynamic> dataList,
  ) {
    return dataList.map((json) {
      if (json is Map<String, dynamic>) {
        return NotificationDataType.fromJson(json);
      }
      throw const FormatException('Invalid JSON format');
    }).toList();
  }

  Future<ApiResponse> fetchAllNotifications({
    int? page,
    int? size,
    bool? isRead,
  }) async {
    try {
      // Set loading status to true
      final result = ApiResponse()..isLoading = true;

      // Make API call
      final apiResponse = await api.get(
        path: _apiPath,
        options: Options(
          headers: {
            'authorization': _authorizationToken,
          },
        ),
        queryParameters: {
          'page': page,
          'size': size,
          'isRead': isRead,
        },
      ) as Map<String, dynamic>;

      final dataList = ApiResponse.fromJson(apiResponse).data as List<dynamic>;

      print('important debug ${ApiResponse.fromJson(apiResponse).meta}');

      // Set loading status to false and success status to true
      result
        ..isLoading = false
        ..isSuccess = true
        ..data = convertJsonToNotificationList(dataList);

      // Return the result object
      return result;
    } catch (error) {
      // Set loading status to false and error status to true
      final result = ApiResponse()
        ..isLoading = false
        ..isError = true
        ..error = ApiErrorDetails(
          errorCode: '500',
          message: 'Internal Server Error',
        );
      // Return the result object
      return result;
    }
  }
}
