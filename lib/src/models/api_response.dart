import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';

/// Class representing an API response.
class ApiResponse {
  /// Constructs an [ApiResponse] instance.
  ApiResponse({
    this.data,
    this.meta,
    this.error,
  });

  /// Factory method to create ApiResponse from JSON.
  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      error: json['error'] != null
          ? SirenErrorType.fromJson(json['error'] as Map<String, dynamic>?)
          : null,
      meta: json['meta'] != null
          ? MetaResponse.fromJson(json?['meta'] as Map<String, dynamic>?)
          : null,
    );
  }

  /// The data received in the response.
  late dynamic data;

  /// Additional metadata associated with the response.
  late MetaResponse? meta;

  /// Details about any errors that occurred during the request.
  late SirenErrorType? error;

  /// Indicates whether the response is still loading.
  bool isLoading = true;

  /// Indicates whether the response was successful.
  bool isSuccess = false;

  /// Indicates whether an error occurred in the response.
  bool isError = false;

  /// The raw response received from the API.
  dynamic rawResponse;
}

/// Represents metadata associated with an API response.
class MetaResponse {
  /// Constructs a [MetaResponse] instance.
  MetaResponse({
    required this.last,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
    required this.first,
  });

  /// Factory method to create MetaResponse from JSON.
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
    );
  }

  /// The ID of the last element.
  final String? last;

  /// The total number of pages.
  final int? totalPages;

  /// The size of each page.
  final int? pageSize;

  /// The current page number.
  final int? currentPage;

  /// The ID of the first element.
  final String? first;
}

/// Represents details of an API error.
class SirenErrorType {
  /// Constructs an [SirenErrorType] instance.
  SirenErrorType({
    this.type,
    this.message,
    this.code,
  });

  /// Factory method to create SirenErrorType from JSON.
  factory SirenErrorType.fromJson(Map<String, dynamic>? json) {
    return SirenErrorType(
      type: json?['errorCode'] != null ? (json?['errorCode'] as String) : '',
      message: json?['message'] != null ? (json?['message'] as String) : '',
    );
  }

  /// The error code associated with the error.
  String? type;

  /// The message describing the error.
  String? message;

  /// The type of error.
  String? code;
}

/// Represents a response from Dio HTTP client.
class DioResponse {
  /// Constructs a [DioResponse] instance.
  DioResponse({required this.data, this.statusCode});

  /// The data received in the response.
  final dynamic data;

  /// The status code of the response.
  final int? statusCode;
}

/// Class representing a response from a stream.
class StreamResponse {
  /// Constructs a [StreamResponse] instance.
  StreamResponse(this.response, this.api, this.id);

  /// The API response.
  final ApiResponse? response;

  /// The type of update event associated with the response.
  final UpdateEvents? api;

  /// The ID associated with the response.
  final String? id;
}
