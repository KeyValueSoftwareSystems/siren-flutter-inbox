import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class MockApiClient extends ApiClient {
  MockApiClient(super.api);

  @override
  Future<DioResponse> delete({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final result = DioResponse(
      data: {
        'data': {'status': 'SUCCESS'},
        'error': null,
      },
      statusCode: 200,
    );
    return result;
  }
}

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

  // final ApiClient api = ApiClient(apiProvider()); // Use a real or fake ApiClient
  final MockApiClient api = MockApiClient(apiProvider());

  static final String _apiPath =
      '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/notifications';

  Future<ApiResponse> deleteNotificationById({
    required String notificationId,
  }) async {
    final result = ApiResponse()..isLoading = true;
    final apiError = ApiErrorDetails()..code = ErrorCodes.DELETE_FAILED.name;

    final apiResponse = await api.delete(
      path: '$_apiPath/$notificationId',
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final deletionStatus = convertJsonToDeletionStatus(apiResponse.data);

      apiError
        ..type = ApiResponse.fromJson(apiResponse.data).error?.type
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;
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

void main() {
  group('DeleteNotificationById', () {
    const notificationId = 'test-notification-id';

    test('deleteNotificationById - success', () async {
      final deleteNotification = DeleteNotificationById._internal();

      final apiResponse = await deleteNotification.deleteNotificationById(
        notificationId: notificationId,
      );

      expect(apiResponse.isLoading, false);
      expect(apiResponse.isSuccess, true);
      expect(apiResponse.isError, false);
      expect(apiResponse.data, Status.SUCCESS);
    });
  });
}
