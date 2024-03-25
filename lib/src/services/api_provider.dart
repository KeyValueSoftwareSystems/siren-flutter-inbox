import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

/// Provides an instance of Dio with configured interceptors.
Dio apiProvider() {
  final dio = Dio();
  // Configuring timeouts
  // dio.options.connectTimeout = 10000;
  // dio.options.receiveTimeout = 3000;

  // Adding interceptors
  dio.interceptors.add(
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
      onError: (DioException dioError, ErrorInterceptorHandler handler) async {
        if (dioError.error is SocketException) {
          // HANDLE ERROR
        }
        return handler.next(dioError);
      },
    ),
  );
   if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }
  return dio;
}
