import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class NotificationsBulkUpdate {
  factory NotificationsBulkUpdate() {
    return instance;
  }

  NotificationsBulkUpdate._internal();
  static final NotificationsBulkUpdate instance =
      NotificationsBulkUpdate._internal();

  Future<ApiResponse> notificationsBulkUpdate({
    required Map<String, dynamic> data,
    required String operation,
  }) async {
    final api = ApiClient(apiProvider());
    final apiPath =
        '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/notifications/bulk-update';
    final result = ApiResponse()..isLoading;
    var apiError = Generics.markAllAsViewedError;

    if (operation == BulkUpdateType.MARK_AS_DELETED.name) {
      apiError = Generics.deleteAllFailedError;
    }

    if (SirenDataProvider.instance.tokenVerificationStatus != Status.SUCCESS) {
      apiError = Generics.authenticationFailed;
      result
        ..isLoading = false
        ..isError = true
        ..data = null
        ..rawResponse = Generics.rawResponseError
        ..error = apiError;
      return result;
    }

    final apiResponse = await api.post(
      path: apiPath,
      data: data,
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      apiError
        ..type = ApiResponse.fromJson(apiResponse.data).error?.type
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;

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
        ..error = Generics.defaultError;
    }

    return result;
  }
}
