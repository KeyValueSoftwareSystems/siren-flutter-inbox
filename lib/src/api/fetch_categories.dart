import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/errors/errors.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_provider.dart';

class FetchCategories {
  FetchCategories._internal();
  static final FetchCategories instance = FetchCategories._internal();
  final ApiClient api = ApiClient(apiProvider());

  List<String> convertJsonToCategoryList(List<dynamic> dataList) {
    return dataList.map((dynamic json) {
      if (json is String) {
        return json;
      }
      throw const FormatException('Invalid JSON format');
    }).toList();
  }

  Future<ApiResponse> fetchCategories() async {
    final apiPath =
        '${Generics.V2}${Generics.BASE_URL}${SirenDataProvider.instance.recipientId}/categories';
    final result = ApiResponse()..isLoading = true;
    var apiError = Errors.notificationFetchFailedError;

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
      path: apiPath,
    );

    if (apiResponse.statusCode != 0 && apiResponse.data != null) {
      final dataList =
          ApiResponse.fromJson(apiResponse.data).data as List<dynamic>?;
      result
        ..isLoading = false
        ..isSuccess = apiResponse.statusCode == 200
        ..isError = apiResponse.statusCode != 200
        ..data = convertJsonToCategoryList(dataList ?? [])
        ..rawResponse = apiResponse
        ..error = apiError;
    } else {
      result
        ..isLoading = false
        ..isSuccess = false
        ..isError = true
        ..rawResponse = apiResponse
        ..error = Errors.defaultError;
    }

    return result;
  }
}
