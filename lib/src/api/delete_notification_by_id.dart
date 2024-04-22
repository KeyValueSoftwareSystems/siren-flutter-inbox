import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

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

  static final String _apiPath =
      '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/notifications';

  Future<ApiResponse> deleteNotificationById({
    required String notificationId,
  }) async {
    final result = ApiResponse()..isLoading = true;
    var apiError = Generics.deleteFailedError;

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

    final apiResponse = await api.delete(
      path: '$_apiPath/$notificationId',
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final deletionStatus = convertJsonToDeletionStatus(apiResponse.data);
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = deletionStatus
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
