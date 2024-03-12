import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class DeleteNotificationById {
  DeleteNotificationById._internal();
  static final DeleteNotificationById instance =
      DeleteNotificationById._internal();

  Status convertJsonToDeletionStatus(dynamic response) {
    return (response['data']?['status']?.toString() ?? '') ==
            Status.SUCCESS.name
        ? Status.SUCCESS
        : Status.PENDING;
  }

  final ApiClient api = ApiClient(apiProvider());

  static final String _apiPath = '${Generics.API_PATH}/notifications';

  Future<ApiResponse> deleteNotificationById({
    required String notificationId,
  }) async {
    final result = ApiResponse()..isLoading = true;

    final apiResponse = await api.delete(
      path: '$_apiPath/$notificationId',
    );
    final deletionStatus = convertJsonToDeletionStatus(apiResponse.data);

    final apiError = ApiResponse.fromJson(apiResponse.data).error;

    result
      ..isLoading = false
      ..isSuccess = apiResponse.statusCode == 200
      ..isError = apiResponse.statusCode != 200
      ..data = deletionStatus
      ..error = apiError;

    return result;
  }
}
