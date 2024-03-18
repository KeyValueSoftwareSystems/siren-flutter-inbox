import 'package:siren_flutter_inbox/src/constants/generics.dart';

class ApiResponse {
  ApiResponse({
    this.data,
    this.meta,
    this.error,
  });

  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      error: json['error'] != null
          ? ApiErrorDetails.fromJson(json['error'] as Map<String, dynamic>?)
          : null,
      meta: json['meta'] != null
          ? MetaResponse.fromJson(json?['meta'] as Map<String, dynamic>?)
          : null,
    );
  }

  bool isLoading = true;
  bool isSuccess = false;
  bool isError = false;
  dynamic rawResponse;

  late dynamic data;
  late ApiErrorDetails? error;
  late MetaResponse? meta;
}

class MetaResponse {
  MetaResponse({
    required this.last,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
    required this.first,
    required this.totalElements,
  });

  factory MetaResponse.fromJson(Map<String, dynamic>? json) {
    return MetaResponse(
      last: json?['last'] != null ? (json?['last'] as String) : null,
      totalPages: json?['totalPages'] != null
          ? int.tryParse(json?['totalPages'] as String)
          : null,
      pageSize: json?['pageSize'] != null
          ? int.tryParse(json?['pageSize'] as String)
          : null,
      currentPage: json?['currentPage'] != null
          ? int.tryParse(json?['currentPage'] as String)
          : null,
      first: json?['first'] != null ? (json?['first'] as String) : null,
      totalElements: json?['totalElements'] != null
          ? int.tryParse(json?['totalElements'] as String)
          : null,
    );
  }

  final String? last;
  final int? totalPages;
  final int? pageSize;
  final int? currentPage;
  final String? first;
  final int? totalElements;
}

class ApiErrorDetails {
  ApiErrorDetails({
    this.errorCode,
    this.message,
    this.errorType,
  });

  factory ApiErrorDetails.fromJson(Map<String, dynamic>? json) {
    return ApiErrorDetails(
      errorCode:
          json?['errorCode'] != null ? (json?['errorCode'] as String) : '',
      message: json?['message'] != null ? (json?['message'] as String) : '',
    );
  }

  String? errorCode;
  String? message;
  ErrorTypes? errorType;
}

class DioResponse {
  DioResponse({required this.data, this.statusCode});

  final dynamic data;
  final int? statusCode;
}

class StreamResponse {
  StreamResponse(
    this.response,
    this.api,
    this.id,
  );

  final ApiResponse? response;
  final UpdateEvents? api;
  final String? id;
}
