import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class MarkAllNotificationsAsViewed {
  factory MarkAllNotificationsAsViewed() {
    return instance;
  }

  MarkAllNotificationsAsViewed._internal();
  static final MarkAllNotificationsAsViewed instance =
      MarkAllNotificationsAsViewed._internal();

  Future<ApiResponse> markAllNotificationsAsViewed({
    required String untilDate,
  }) async {
    final api = ApiClient(apiProvider());
    final result = ApiResponse()..isLoading;
    final apiError = ApiErrorDetails()
      ..code = ErrorTypes.MARK_ALL_AS_VIEWED_FAILED;

    final data = {
      'lastOpenedAt': untilDate,
    };

    if (SirenDataProvider.instance.tokenVerificationStatus != Status.SUCCESS) {
      apiError.code = ErrorTypes.AUTHENTICATION_FAILED;
      result
        ..isLoading = false
        ..isError = true
        ..data = null
        ..rawResponse = Generics.rawResponseError
        ..error = apiError;
      return result;
    }

    final apiResponse = await api.patch(
      path:
          '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}',
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
