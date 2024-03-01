import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/constants/generics.dart';

class ApiClient {
  // injecting dio instance
  ApiClient(this._api);
  // dio instance
  final Dio _api;

  // checking whether response is success or failure
  dynamic validateResponse(Response response) {
    final validErrorCodes = <String>[];
    if (response.data['errors'] == null) {
      return response.data;
    } else if (validErrorCodes.contains(
      response.data['errors']?[0]?['extensions']?['errors'],
    )) {
      return {
        'error': response.data['errors']?[0]?['extensions']?['errors'],
      };
    } else {
      return {};
    }
  }

  // Get API
  Future<dynamic> get({
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
      return validateResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Put API
  Future<dynamic> put({
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _api.put(
        'TODO ADD BASE URL',
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

  // Delete API
  Future<dynamic> delete({
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
      return validateResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
