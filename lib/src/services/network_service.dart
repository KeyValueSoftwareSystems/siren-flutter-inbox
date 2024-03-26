import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class NetworkService {
  factory NetworkService() {
    return instance;
  }

  NetworkService._internal();
  static final NetworkService instance = NetworkService._internal();

  ApiClient api = ApiClient(apiProvider());
}
