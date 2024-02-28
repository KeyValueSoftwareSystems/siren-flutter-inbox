import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class VerifyToken {
  factory VerifyToken() {
    return instance;
  }
  VerifyToken._internal();
  static final VerifyToken instance = VerifyToken._internal();

  ApiClient api = ApiClient(apiProvider());

  Future<void> verifyToken(String token, String id) async {
    final apiResponse = await api.get(
      path: 'api/v2/in-app/recipients/id',
      options: Options(
        headers: {
          'authorization': 'Bearer $token',
        },
      ),
    );
  }
}
