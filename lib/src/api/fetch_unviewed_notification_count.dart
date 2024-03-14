import 'dart:async';

import 'package:siren_flutter_inbox/src/constants/generics.dart';

import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/unviewed_notification_count_model.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/network_service.dart';

class FetchUnviewedNotificationsCount {
  factory FetchUnviewedNotificationsCount() {
    return instance;
  }
  FetchUnviewedNotificationsCount._internal();
  static final FetchUnviewedNotificationsCount instance =
      FetchUnviewedNotificationsCount._internal();

  ApiClient api = NetworkService.instance.api;

  Future<ApiResponse> fetchUnviewedNotificationsCount() async {
    final result = ApiResponse()..isLoading = true;
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.FETCH_COUNT_ERROR;

    final apiResponse = await api.get(
      path: Generics.API_PATH,
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      var count = 0;
      final data =
          ApiResponse.fromJson(apiResponse.data).data as Map<String, dynamic>?;
      final notificationCount =
          UnviewedNotificationsCountModel.fromJson(data ?? {});
      apiError
        ..errorCode = ApiResponse.fromJson(apiResponse.data).error?.errorCode
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;
      count = notificationCount.totalUnviewed;
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = count
        ..meta = null
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..error = Generics.DEFAULT_ERROR;
    }
    return result;
  }
}
