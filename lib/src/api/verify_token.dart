import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/services/api_client.dart';
import 'package:siren_flutter_inbox/src/services/api_provider.dart';

class VerifyToken {
  factory VerifyToken() {
    return instance;
  }

  VerifyToken._internal();

  static final VerifyToken instance = VerifyToken._internal();

  VerificationStatus convertJsonToVerificationStatus(dynamic response) {
    return (response['data']?['status']?.toString() ?? '') ==
            VerificationStatus.SUCCESS.name
        ? VerificationStatus.SUCCESS
        : VerificationStatus.PENDING;
  }

  ApiClient api = ApiClient(apiProvider());

  Future<ApiResponse> verifyToken() async {
    final result = ApiResponse()..isLoading = true;

    final apiResponse = await api.get(
      path: '${Generics.API_PATH}/verify-token',
    );
    final verificationStatus = convertJsonToVerificationStatus(apiResponse[0]);
    final apiError = ApiResponse.fromJson(apiResponse[0]).error;

    result
      ..isLoading = false
      ..isSuccess = apiResponse[1] == 200
      ..isError = apiResponse[1] != 200
      ..data = verificationStatus
      ..error = apiError;

    return result;
  }
}
