import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

Dio apiProvider() {
  final _dio = Dio();
  // ignore: cascade_invocations
  _dio
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 10)
    ..interceptors.add(
      InterceptorsWrapper(
        /**
         * onRequest interceptor - Called before firing the request
         */
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final token = SirenDataProvider.instance.userToken;
          if (options.contentType != '') {
            options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
          }
          return handler.next(options);
        },
        /**
         * onResponse interceptor - called on response- check
         */
        onResponse:
            (Response response, ResponseInterceptorHandler handler) async {
          if (response.data != '') {
            // handle error
          }
          return handler.next(response);
        },
        /**
         * onError interceptor - called on error
         */
        onError: (DioError dioError, ErrorInterceptorHandler handler) async {
          if (dioError.error is SocketException) {
            // HANDLE ERROR
          }
          return handler.next(dioError);
        },
      ),
    );
  if (kDebugMode) {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }
  return _dio;
}
