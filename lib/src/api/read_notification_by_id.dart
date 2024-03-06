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

    final apiResponse = await api.patch(
      path: '$_apiPath/$notificationId',
      data: {
        'isRead': true,
        'isDelivered': true,
      },
    );

    final apiError = ApiResponse.fromJson(apiResponse.data).error;

    result
      ..isLoading = false
      ..isSuccess = apiResponse.statusCode == 200
      ..isError = apiResponse.statusCode != 200
      ..error = apiError;

    return result;
  }
}
