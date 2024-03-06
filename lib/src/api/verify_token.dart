import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class VerifyToken {
  factory VerifyToken() {
    return instance;
  }
  VerifyToken._internal();
  static final VerifyToken instance = VerifyToken._internal();

  ApiClient api = ApiClient(apiProvider());

  Future<VerificationStatus> verifyToken() async {
    final apiResponse = await api.get(
      path: '${Generics.API_PATH}/verify-token',
    );

    final status = apiResponse['data']['status']?.toString() ==
            VerificationStatus.SUCCESS.name
        ? VerificationStatus.SUCCESS
        : VerificationStatus.FAILED;
    return status;
  }
}
