import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class FetchAllNotifications {
  FetchAllNotifications._internal();
  static final FetchAllNotifications instance =
      FetchAllNotifications._internal();
  final ApiClient api = ApiClient(apiProvider());

  static final String _apiPath = '${Generics.API_PATH}/notifications';

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
