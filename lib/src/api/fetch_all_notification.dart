import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class FetchAllNotifications {
  FetchAllNotifications._internal();
  static final FetchAllNotifications instance =
      FetchAllNotifications._internal();
  final ApiClient api = ApiClient(apiProvider());

  static final String _apiPath =
      '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/notifications';

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
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.NOTIFICATION_FETCH_ERROR;

    final apiResponse = await api.get(
      path: _apiPath,
      queryParameters: {
        'page': page,
        'size': size,
        'sort': 'createdAt',
      },
    );

    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final dataList =
          ApiResponse.fromJson(apiResponse.data).data as List<dynamic>?;
      final metaData = ApiResponse.fromJson(apiResponse.data).meta;
      apiError
        ..errorCode = ApiResponse.fromJson(apiResponse.data).error?.errorCode
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = convertJsonToNotificationList(dataList ?? [])
        ..meta = metaData
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
