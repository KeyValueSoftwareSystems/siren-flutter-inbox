import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/notification_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

/// Singleton class responsible for fetching notifications from the API.
class FetchAllNotifications {
  /// Private constructor for the singleton pattern.
  FetchAllNotifications._internal();

  /// The instance of [FetchAllNotifications].
  static final FetchAllNotifications instance = FetchAllNotifications._internal();

  /// API client for making HTTP requests.
  final ApiClient api = ApiClient(apiProvider());

  // Constants
  static const String _apiPath =
      'api/v2/in-app/recipients/64a0811d-982b-4f8e-9601-d5adcc1fe7e2/notifications';
  static const String _authorizationToken =
      'Bearer 95d5544c106543e799084e19a988fd31';

  /// Converts a list of JSON objects to a list of notification data types.
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

  /// Fetches all notifications from the API.
  ///
  /// Parameters:
  /// - [page]: The page number for pagination.
  /// - [size]: The number of items per page.
  /// - [isRead]: Whether to fetch read or unread notifications.
  Future<ApiResponse> fetchAllNotifications({
    int? page,
    int? size,
    bool? isRead,
  }) async {
    try {
      // Set loading status to true
      final result = ApiResponse()..isLoading = true;

      // Make API call
      final apiResponse = await api.get(
        path: _apiPath,
        options: Options(
          headers: {
            'authorization': _authorizationToken,
          },
        ),
        queryParameters: {
          'page': page,
          'size': size,
          'isRead': isRead,
        },
      ) as Map<String, dynamic>;

      // Extract data, meta, and error details from the API response
      final dataList = ApiResponse.fromJson(apiResponse).data as List<dynamic>;
      final metaData = ApiResponse.fromJson(apiResponse).meta;
      final apiError = ApiResponse.fromJson(apiResponse).error;

      // Populate the result object
      result
        ..isLoading = false
        ..isSuccess = true
        ..data = convertJsonToNotificationList(dataList)
        ..meta = metaData
        ..error = apiError;

      // Return the result object
      return result;
    } catch (error) {
      // Handle errors and return an ApiResponse with error details
      final result = ApiResponse()
        ..isLoading = false
        ..isError = true
        ..error = ApiErrorDetails(
          errorCode: '500',
          message: 'Internal Server Error',
        );
      return result;
    }
  }
}
