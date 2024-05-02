import 'dart:async';

import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/models/unviewed_notification_count_model.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/network_service.dart';

class FetchUnViewedNotificationsCount {
  factory FetchUnViewedNotificationsCount() {
    return instance;
  }
  FetchUnViewedNotificationsCount._internal();
  static final FetchUnViewedNotificationsCount instance =
      FetchUnViewedNotificationsCount._internal();

  ApiClient api = NetworkService.instance.api;

  Future<ApiResponse> fetchUnViewedNotificationsCount() async {
    final result = ApiResponse()..isLoading = true;
    var apiError = Errors.fetchUnViewedCountFailedError;

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

    final apiResponse = await api.get(
      path:
          '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}',
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      var count = 0;
      final data =
          ApiResponse.fromJson(apiResponse.data).data as Map<String, dynamic>?;
      final notificationCount =
          UnViewedNotificationsCountModel.fromJson(data ?? {});
      count = notificationCount.totalUnViewed;
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
        ..error = Errors.defaultError;
    }
    return result;
  }
}
