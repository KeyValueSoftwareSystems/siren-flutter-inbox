import 'dart:async';

import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';
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


  Future<int> fetchUnviewedNotificationsCount() async {
    final id = SirenDataProvider.instance.recipientId;
    final apiResponse = await api.get(
      path: 'api/v2/in-app/recipients/$id',
    );

    final data = apiResponse['data'] as Map<String, dynamic>?;
    if (data != null) {
      final model = UnviewedNotificationsCountModel.fromMap(data);
      return model.totalUnviewed;
    }
    return 0;
  }


}
