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

  Status convertJsonToVerificationStatus(dynamic response) {
    return (response['data']?['status']?.toString() ?? '') ==
            Status.SUCCESS.name
        ? Status.SUCCESS
        : Status.PENDING;
  }

  ApiClient api = ApiClient(apiProvider());

  Future<ApiResponse> verifyToken() async {
    final result = ApiResponse()..isLoading = true;
    final apiError = ApiErrorDetails()
      ..errorType = ErrorTypes.AUTHENTICATION_ERROR;

    final apiResponse = await api.get(
      path: '${Generics.API_PATH}/verify-token',
    );
    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final verificationStatus =
          convertJsonToVerificationStatus(apiResponse.data);
      apiError
        ..errorCode = ApiResponse.fromJson(apiResponse.data).error?.errorCode
        ..message = ApiResponse.fromJson(apiResponse.data).error?.message;

      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = verificationStatus
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..data = Status.FAILED
        ..error = Generics.defaultError;
    }

    return result;
  }
}
