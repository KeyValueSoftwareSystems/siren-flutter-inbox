import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio apiProvider() {
  final _dio = Dio();
  // ignore: cascade_invocations
  _dio
    //..options.baseUrl = Config.baseUrl
    ..options.connectTimeout = const Duration(seconds: 5)
    ..options.receiveTimeout = const Duration(seconds: 3)
    ..interceptors.add(
      InterceptorsWrapper(
        /**
         * onRequest interceptor - Called before firing the request
         */
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // const token = 'TODO GET AUTH TOKEN';
          // if (options.contentType != ''
          //   ) {
          //   options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
          // }
          return handler.next(options);
        },
        /**
         * onResponse interceptor - called on response- check access token and refresh
         */
        onResponse:
            (Response response, ResponseInterceptorHandler handler) async {
          if (response.data != '') {
            if (response.data['errors']?[0]['extensions']['statusCode'] ==
                401) {
              // TODO
            } else {
              if (response.data['errors']?[0]['extensions']['error'] ==
                  'E1014') {
                // LOGOUT
              } else {
                return handler.next(response);
              }
            }
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
