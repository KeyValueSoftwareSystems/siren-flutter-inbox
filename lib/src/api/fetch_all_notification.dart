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
    final result = ApiResponse()..isLoading = true;
    final apiResponse = await api.get(
      path: _apiPath,
      queryParameters: {
        'page': page,
        'size': size,
      },
    );

    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final dataList =
          ApiResponse.fromJson(apiResponse.data).data as List<dynamic>?;
      final metaData = ApiResponse.fromJson(apiResponse.data).meta;
      final apiError = ApiResponse.fromJson(apiResponse.data).error;

      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = convertJsonToNotificationList(dataList ?? [])
        ..meta = metaData
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
