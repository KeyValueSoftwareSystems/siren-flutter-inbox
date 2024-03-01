import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';

class ApiClient {
  // injecting dio instance
  ApiClient(this._api);
  // dio instance
  final Dio _api;

  // Get API
  Future<dynamic> get({
    String? path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${Generics.BASE_URL}${Generics.API_PATH}$path';
      final response = await _api.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
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
      final url = '${Generics.BASE_URL}${Generics.API_PATH}$path';
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
    } catch (e) {
      rethrow;
    }
  }

  // Patch API
  Future<dynamic> patch({
    String? path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final url = '${Generics.BASE_URL}${Generics.API_PATH}$path';
      final response = await _api.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
