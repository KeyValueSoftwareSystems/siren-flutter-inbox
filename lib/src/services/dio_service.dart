import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:siren_flutter_inbox/src/errors/exceptions/network_exceptions.dart';
import 'package:siren_flutter_inbox/src/models/api_request_representable.dart';
import 'package:siren_flutter_inbox/src/models/api_response.dart';
import 'package:siren_flutter_inbox/src/models/rest_error_model.dart';

abstract class NetworkService {
  Duration? requestTimeOut;
  Future<APIResponse> request(APIRequestRepresentable requestReceived);
  Future<APIResponse> post(APIRequestRepresentable apiRequestRepresentable);
  Future<APIResponse> put(APIRequestRepresentable apiRequestRepresentable);
  Future<APIResponse> get(APIRequestRepresentable apiRequestRepresentable);
  Future<APIResponse> patch(APIRequestRepresentable apiRequestRepresentable);
  Future<APIResponse> delete(APIRequestRepresentable apiRequestRepresentable);
}

class DioService extends NetworkService {
  DioService() {
    _dio.options.baseUrl = 'https://api.example.com'; // Your API base URL
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    initializeDio();
  }

  final Dio _dio = Dio();

  bool socketErrorOccurred = false;

  void initializeDio() {
    // _client.interceptors.addAll(
    //     [tokenInterceptor(_tokenRefreshService, _client)]);
  }

  @override
  Future<APIResponse> request(APIRequestRepresentable requestReceived) async {
    try {
      var request = requestReceived;
      final token = <String, String>{};
      request = request.copyWith(
        headers: {...?requestReceived.headers, ...token, ...{}},
      );

      if (socketErrorOccurred) {
        ///if a socket error occurred earlier then reset the dio
        // initializeDio();
        socketErrorOccurred = false;
      }

      // Send the request using Dio
      final response = await _dio.request(
        request.url,
        options: Options(
          method: request.method.string,
          headers: request.headers,
          persistentConnection: true,
          extra: {
            'skipAuthHeaders': request.skipAuthHeaders,
          },
        ),
        data: request.body,
        queryParameters: request.query,
      );
      // Return the response
      return mapToAPIResponse(response);
    } on TimeoutException catch (_) {
      // Catch timeout exceptions
      //and throw a custom TimeOutException
      throw FetchDataException.networkException();
    } on SocketException {
      // Catch SocketException (no internet connection)
      // and throw a custom FetchDataException
      throw FetchDataException.networkException();
    } on DioException catch (e) {
      // Log error details for debugging purposes
      if (e.error is SocketException) {
        throw FetchDataException.networkException();
      }
      // Return the response or throw an error
      handleDioExceptions(mapToAPIResponse(e.response));
    } catch (_) {
      // Catch any other exception and throw a custom FetchDataException
      throw FetchDataException.networkException();
    }
    throw FetchDataException('');
  }

  APIResponse<Object> mapToAPIResponse(Response? response) {
    return APIResponse(
      requestOptions: response?.requestOptions ?? RequestOptions(),
      data: response?.data,
      headers: response?.headers,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
    );
  }

  AppException handleDioExceptions(APIResponse<dynamic>? response) {
    if (response == null) {
      socketErrorOccurred = true;
      throw FetchDataException.networkException();
    }
    RestError? restApiError;
    try {
      restApiError = RestError.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      restApiError = RestError.unknownError();
    }

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(
          response.data.toString(),
          restApiError: restApiError,
        );
      case 401:
      case 403:
        throw UnauthorisedException(
          response.data.toString(),
          restApiError: restApiError,
        );
      case 404:
        throw NotFoundException('Server error please try again later');
      case 409:
        throw ConflictException(
          response.data.toString(),
          restApiError: restApiError,
        );
      case 500:
        throw FetchDataException('Internal Server Error');
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode '
          ': ${response.statusCode}',
        );
    }
  }

  @override
  Future<APIResponse> get(
    APIRequestRepresentable apiRequestRepresentable,
  ) async {
    return request(
      apiRequestRepresentable.copyWith(method: HTTPMethod.get),
    );
  }

  @override
  Future<APIResponse> patch(APIRequestRepresentable apiRequestRepresentable) {
    return request(apiRequestRepresentable.copyWith(method: HTTPMethod.patch));
  }

  @override
  Future<APIResponse> post(APIRequestRepresentable apiRequestRepresentable) {
    return request(apiRequestRepresentable.copyWith(method: HTTPMethod.post));
  }

  @override
  Future<APIResponse> put(APIRequestRepresentable apiRequestRepresentable) {
    return request(apiRequestRepresentable.copyWith(method: HTTPMethod.put));
  }

  @override
  Future<APIResponse> delete(APIRequestRepresentable apiRequestRepresentable) {
    return request(apiRequestRepresentable.copyWith(method: HTTPMethod.delete));
  }
}
