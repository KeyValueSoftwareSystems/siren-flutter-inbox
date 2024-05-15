// ignore_for_file: avoid_redundant_argument_values

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';
import 'package:sirenapp_flutter_inbox/src/services/api_client.dart';

import 'api_client_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<SirenDataProvider>(),
])
void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    late MockDio mockDio;
    late MockSirenDataProvider mockSirenDataProvider;

    setUp(() {
      mockDio = MockDio();
      mockSirenDataProvider = MockSirenDataProvider();
      apiClient = ApiClient(mockDio);
    });

    test('Test server error ', () {
      final apiClient = ApiClient(Dio());
      final response = Response(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(),
      );
      final result = apiClient.isServerError(response);
      expect(
        result,
        true,
      );
    });

    test('GET request', () async {
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: responseStatusCode,
          requestOptions: RequestOptions(),
        ),
      );

      final response = await apiClient.get(path: '/test');

      verify(
        mockDio.get(
          '/test',
        ),
      ).called(1);

      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('POST request', () async {
      final responseData = {'key': 'value'};
      const responseStatusCode = 201;

      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: responseStatusCode,
          requestOptions: RequestOptions(),
        ),
      );

      final response =
          await apiClient.post(path: '/test', data: {'key': 'value'});

      verify(
        mockDio.post(
          '/test',
          data: {'key': 'value'},
        ),
      ).called(1);

      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('PATCH request', () async {
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      when(
        mockDio.patch(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: responseStatusCode,
          requestOptions: RequestOptions(),
        ),
      );

      final response =
          await apiClient.patch(path: '/test', data: {'key': 'value'});

      verify(
        mockDio.patch(
          '/test',
          data: {'key': 'value'},
        ),
      ).called(1);

      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('DELETE request', () async {
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      when(
        mockDio.delete(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: responseStatusCode,
          requestOptions: RequestOptions(),
        ),
      );

      final response = await apiClient.delete(path: '/test');

      verify(
        mockDio.delete(
          '/test',
        ),
      ).called(1);
      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('Handles DioException on GET request', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: 'Error message',
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      final result = await apiClient.get(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on POST request', () async {
      when(mockDio.post(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: 'Error message',
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      final result = await apiClient.post(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on Patch request', () async {
      when(mockDio.patch(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: 'Error message',
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      final result = await apiClient.patch(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on delete request', () async {
      when(mockDio.delete(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: 'Error message',
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      final result = await apiClient.delete(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });
  });
}
