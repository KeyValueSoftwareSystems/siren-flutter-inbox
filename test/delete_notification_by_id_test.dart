import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

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
    // Simulate different API responses here
    // (e.g., return ApiResponse with different status codes, data, and errors)
    final result = DioResponse(
      data: {
        'data': {'status': 'SUCCESS'},
        'error': null,
      },
      statusCode: 200,
    );
    return result; // Default to success for now
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
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.NOTIFICATION_DELETE_ERROR;

    final apiResponse = await api.delete(
      path: '$_apiPath/$notificationId',
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final deletionStatus = convertJsonToDeletionStatus(apiResponse.data);

      apiError
        ..errorCode = ApiResponse.fromJson(apiResponse.data).error?.errorCode
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
      // Arrange
      // final fakeApi = MockApiClient(apiProvider());
      final deleteNotification = DeleteNotificationById._internal();

      // Act
      final apiResponse = await deleteNotification.deleteNotificationById(
        notificationId: notificationId,
      );

      // Assert
      expect(apiResponse.isLoading, false);
      expect(apiResponse.isSuccess, true);
      expect(apiResponse.isError, false);
      expect(apiResponse.data, Status.SUCCESS); // No data expected for success
      // expect(apiResponse.error, ApiErrorDetails( ));
    });

    // Add additional test cases for different API responses (error, network failure, etc.)
  });
}
