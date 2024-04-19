import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

/// Provides an instance of Dio with configured interceptors.
Dio apiProvider() {
  final dio = Dio();

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
        return handler.next(response);
      },
      /**
       * onError interceptor - called on error
       */
      onError: (DioException dioError, ErrorInterceptorHandler handler) async {
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
