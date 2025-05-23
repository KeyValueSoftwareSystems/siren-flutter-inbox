import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class ReadNotificationById {
  ReadNotificationById._internal();
  static final ReadNotificationById instance = ReadNotificationById._internal();

  final ApiClient api = ApiClient(apiProvider());

  Future<ApiResponse> readNotificationById({
    required String notificationId,
  }) async {
    final result = ApiResponse()..isLoading = true;
    var apiError = Errors.markAsReadFailedError;
    final apiPath =
        '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/notifications';
    if (SirenDataProvider.instance.tokenVerificationStatus != Status.SUCCESS) {
      apiError = SirenDataProvider.instance.getVerificationErrorType();
      result
        ..isLoading = false
        ..isError = true
        ..data = null
        ..rawResponse = Errors.rawResponseError
        ..error = apiError;
      return result;
    }

    final apiResponse = await api.patch(
      path: '$apiPath/$notificationId',
      data: {
        'isRead': true,
        'isDelivered': true,
      },
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..rawResponse = apiResponse
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..rawResponse = apiResponse
        ..error = Errors.defaultError;
    }
    return result;
  }
}
