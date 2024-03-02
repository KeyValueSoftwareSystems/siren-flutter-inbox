import 'dart:async';

import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
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
    try {
      final result = ApiResponse()..isLoading = true;
      final id = SirenDataProvider.instance.recipientId;
      final apiResponse = await api.get(
        path: 'recipients/$id',
      );

      var count = 0;
      final data =
          ApiResponse.fromJson(apiResponse).data as Map<String, dynamic>;
      final notificationCount = UnviewedNotificationsCountModel.fromJson(data);
      count = notificationCount.totalUnviewed;
      result
        ..isLoading = false
        ..isSuccess = true
        ..data = count
        ..meta = null
        ..error = null;
      return result;
    } catch (error) {
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
