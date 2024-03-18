import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

class ApiClient {
  // injecting dio instance
  ApiClient(this._api);
  // dio instance
  final Dio _api;

  bool isServerError(Response<dynamic>? response) {
    return response == null ||
        (response.statusCode != null &&
            response.statusCode! >= 500 &&
            response.statusCode! < 600);
  }

  // Get API
  Future<DioResponse> get({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${Generics.API_DOMAIN}$path';
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
        return DioResponse(
          data: null,
          statusCode: 0,
        );
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  // Post API
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
      final url = '${Generics.API_DOMAIN}$path';
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
        return DioResponse(
          data: null,
          statusCode: 0,
        );
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  // Patch API
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
      final url = '${Generics.API_DOMAIN}$path';
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
        return DioResponse(
          data: null,
          statusCode: 0,
        );
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  // Delete API
  Future<DioResponse> delete({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${Generics.API_DOMAIN}$path';
      final response = await _api.delete(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return DioResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (isServerError(e.response)) {
        return DioResponse(
          data: null,
          statusCode: 0,
        );
      }
      return DioResponse(
        data: e.response?.data ?? '',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }
}
