import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';

class ApiClient {
  // injecting dio instance
  ApiClient(this._api);
  // dio instance
  final Dio _api;

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
      return DioResponse(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Post API
  Future<dynamic> post({
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
      return response;
    } on DioException catch (e) {
      return e.response?.data;
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
      return DioResponse(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
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
      return DioResponse(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
