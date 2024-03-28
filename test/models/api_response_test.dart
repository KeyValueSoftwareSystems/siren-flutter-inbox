import 'package:flutter_test/flutter_test.dart';
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';
import 'package:sirenapp_flutter_inbox/src/models/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {
        'data': 'testData',
        'error': {'errorCode': '123', 'message': 'Error message'},
        'meta': {
          'last': 'last',
          'totalPages': '5',
          'pageSize': '10',
          'currentPage': '1',
          'first': 'first',
          'totalElements': '50',
        }
      };
      final response = ApiResponse.fromJson(json);

      expect(response.data, 'testData');
      expect(response.error?.errorCode, '123');
      expect(response.meta?.last, 'last');
      expect(response.meta?.totalPages, 5);
    });

    test('Initial values are set correctly', () {
      final response = ApiResponse();

      expect(response.isLoading, true);
      expect(response.isSuccess, false);
      expect(response.isError, false);
    });
  });

  group('MetaResponse', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {
        'last': 'last',
        'totalPages': '5',
        'pageSize': '10',
        'currentPage': '1',
        'first': 'first',
        'totalElements': '50',
      };
      final meta = MetaResponse.fromJson(json);

      expect(meta.last, 'last');
      expect(meta.totalPages, 5);
      expect(meta.pageSize, 10);
      expect(meta.currentPage, 1);
      expect(meta.first, 'first');
      expect(meta.totalElements, 50);
    });
  });

  group('ApiErrorDetails', () {
    test('fromJson() should parse JSON correctly', () {
      final json = {
        'errorCode': '123',
        'message': 'Error message',
      };
      final errorDetails = ApiErrorDetails.fromJson(json);

      expect(errorDetails.errorCode, '123');
      expect(errorDetails.message, 'Error message');
    });
  });

  // Similar tests can be written for DioResponse and StreamResponse classes
}
