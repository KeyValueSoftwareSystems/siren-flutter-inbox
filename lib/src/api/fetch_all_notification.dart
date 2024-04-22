import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/models/notification_model.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

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
    String? start,
    String? end,
  }) async {
    final result = ApiResponse()..isLoading = true;
    var apiError = Generics.notificationFetchFailedError;

    // Manually construct query parameters
    final queryParams = {
      'size': size.toString(),
      'sort': 'createdAt',
    };

    if (end != null) {
      queryParams['end'] = end;
    }

    if (start != null) {
      queryParams['start'] = start;
    }

    final queryString =
        queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

    if (SirenDataProvider.instance.tokenVerificationStatus != Status.SUCCESS) {
      apiError = SirenDataProvider.instance.getVerificationErrorType();
      result
        ..isLoading = false
        ..isError = true
        ..data = null
        ..rawResponse = Generics.rawResponseError
        ..error = apiError;
      return result;
    }

    final apiResponse = await api.get(
      path: '$_apiPath?$queryString',
    );

    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final dataList =
          ApiResponse.fromJson(apiResponse.data).data as List<dynamic>?;
      final metaData = ApiResponse.fromJson(apiResponse.data).meta;
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
