import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class FetchAllNotifications {
  FetchAllNotifications._internal();
  static final FetchAllNotifications instance = FetchAllNotifications._internal();
  final ApiClient api = ApiClient(apiProvider());

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
      final result = ApiResponse()..isLoading = true;
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
        },
      ) as Map<String, dynamic>;

      final dataList = ApiResponse.fromJson(apiResponse).data as List<dynamic>;
      final metaData = ApiResponse.fromJson(apiResponse).meta;
      final apiError = ApiResponse.fromJson(apiResponse).error;

      result
        ..isLoading = false
        ..isSuccess = true
        ..data = convertJsonToNotificationList(dataList)
        ..meta = metaData
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
