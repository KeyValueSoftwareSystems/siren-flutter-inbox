/// Represents the response from an API call.
class ApiResponse {
  ApiResponse({
    this.data,
    this.meta,
    this.error,
  });

  // Factory method to create an instance of ApiResponse from JSON.
  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      error: ApiErrorDetails.fromJson(json['error'] as Map<String, dynamic>?),
      meta: MetaResponse.fromJson(json?['meta'] as Map<String, dynamic>?),
    );
  }

  // Flags to represent the state of the response.
  bool isLoading = true;
  bool isSuccess = false;
  bool isError = false;

  // The payload data, error details, and metadata.
  late dynamic data;
  late ApiErrorDetails? error;
  late MetaResponse? meta;
}

/// Represents metadata information in an API response.
class MetaResponse {
  MetaResponse({
    required this.last,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
    required this.first,
    required this.totalElements,
  });

  // Factory method to create an instance of MetaResponse from JSON.
  factory MetaResponse.fromJson(Map<String, dynamic>? json) {
    return MetaResponse(
      last: json?['last'] as String?,
      totalPages: int.tryParse(json?['totalPages'] as String),
      pageSize: int.tryParse(json?['pageSize'] as String),
      currentPage: int.tryParse(json?['currentPage'] as String),
      first: json?['first'] as String,
      totalElements: int.tryParse(json?['totalElements'] as String),
    );
  }

  // Metadata properties.
  final String? last;
  final int? totalPages;
  final int? pageSize;
  final int? currentPage;
  final String? first;
  final int? totalElements;
}

/// Represents details of an error in an API response.
class ApiErrorDetails {
  ApiErrorDetails({
    required this.errorCode,
    required this.message,
  });

  // Factory method to create an instance of ApiErrorDetails from JSON.
  factory ApiErrorDetails.fromJson(Map<String, dynamic>? json) {
    return ApiErrorDetails(
      errorCode: json?['errorCode'] as String? ?? '',
      message: json?['message'] as String? ?? '',
    );
  }

  // Error details properties.
  final String errorCode;
  final String message;
}
