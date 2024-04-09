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
        statusCode: 500,
        requestOptions: RequestOptions(),
      );
      final result = apiClient.isServerError(response);
      expect(
        result,
        true,
      ); // Expect true because status code is in server error range
    });

    test('GET request', () async {
      // Mock response data
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      // Set up mock SirenDataProvider response
      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      // Set up mock Dio response for GET request
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

      // Perform GET request
      final response = await apiClient.get(path: '/test');

      verify(
        mockDio.get(
          '/test',
        ),
      ).called(1);

      // Verify ApiResponse matches expected result
      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('POST request', () async {
      // Mock response data
      final responseData = {'key': 'value'};
      const responseStatusCode = 201;

      // Set up mock SirenDataProvider response
      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      // Set up mock Dio response for POST request
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

      // Perform POST request
      final response =
          await apiClient.post(path: '/test', data: {'key': 'value'});

      verify(
        mockDio.post(
          '/test',
          data: {'key': 'value'},
        ),
      ).called(1);

      // Verify ApiResponse matches expected result
      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('PATCH request', () async {
      // Mock response data
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      // Set up mock SirenDataProvider response
      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      // Set up mock Dio response for PATCH request
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

      // Perform PATCH request
      final response =
          await apiClient.patch(path: '/test', data: {'key': 'value'});

      verify(
        mockDio.patch(
          '/test',
          data: {'key': 'value'},
        ),
      ).called(1);

      // Verify ApiResponse matches expected result
      expect(response.data, responseData);
      expect(response.statusCode, responseStatusCode);
    });

    test('DELETE request', () async {
      // Mock response data
      final responseData = {'key': 'value'};
      const responseStatusCode = 200;

      // Set up mock SirenDataProvider response
      when(mockSirenDataProvider.apiDomain).thenReturn('http://example.com');

      // Set up mock Dio response for DELETE request
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
      // Simulate DioException when making a GET request
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

      // Perform the GET request using ApiClient
      final result = await apiClient.get(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on POST request', () async {
      // Simulate DioException when making a GET request
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

      // Perform the GET request using ApiClient
      final result = await apiClient.post(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on Patch request', () async {
      // Simulate DioException when making a GET request
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

      // Perform the GET request using ApiClient
      final result = await apiClient.patch(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });

    test('Handles DioException on delete request', () async {
      // Simulate DioException when making a GET request
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

      // Perform the GET request using ApiClient
      final result = await apiClient.delete(path: '/example');

      expect(result.data, 'Error message');
      expect(
        result.statusCode,
        404,
      );
    });
  });
}
