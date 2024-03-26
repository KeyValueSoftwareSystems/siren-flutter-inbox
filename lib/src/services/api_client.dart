import 'package:dio/dio.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';

/// A class responsible for making HTTP requests using Dio.
class ApiClient {
  /// Injecting Dio instance.
  ApiClient(this._api);

  /// Dio instance.
  final Dio _api;

  /// Checks if the response indicates a server error.
  bool isServerError(Response<dynamic>? response) {
    return response == null ||
        (response.statusCode != null &&
            response.statusCode! >= 500 &&
            response.statusCode! < 600);
  }

  /// Performs a GET request.
  Future<DioResponse> get({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${SirenDataProvider.instance.apiDomain}$path';
      final response = await _api.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return DioResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (isServerError(e.response)) {
        return DioResponse(data: null, statusCode: 0);
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  /// Performs a POST request.
  Future<DioResponse> post({
    String? path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${SirenDataProvider.instance.apiDomain}$path';
      final response = await _api.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return DioResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (isServerError(e.response)) {
        return DioResponse(data: null, statusCode: 0);
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  /// Performs a PATCH request.
  Future<DioResponse> patch({
    String? path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${SirenDataProvider.instance.apiDomain}$path';
      final response = await _api.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return DioResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (isServerError(e.response)) {
        return DioResponse(data: null, statusCode: 0);
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  /// Performs a DELETE request.
  Future<DioResponse> delete({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${SirenDataProvider.instance.apiDomain}$path';
      final response = await _api.delete(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return DioResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (isServerError(e.response)) {
        return DioResponse(data: null, statusCode: 0);
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }
}
