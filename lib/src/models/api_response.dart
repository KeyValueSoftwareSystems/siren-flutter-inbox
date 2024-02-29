class ApiResponse {
  ApiResponse({
    this.data,
    this.meta,
    this.error,
    this.errors,
  });

  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      error: json['error'],
      errors: json['errors'],
      meta: json['meta'],
    );
  }

  bool isLoading = true;
  bool isSuccess = false;
  bool isError = false;
  late dynamic data;
  late dynamic error;
  late dynamic errors;
  late dynamic meta;
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
      last: json?['last'] as bool?,
      totalPages: json?['totalPages'] as int,
      pageSize: json?['pageSize'] as int,
      currentPage: json?['currentPage'] as int,
      first: json?['first'] as bool,
      totalElements: json?['totalElements'] as int,
    );
  }

  final bool? last;
  final int? totalPages;
  final int? pageSize;
  final int? currentPage;
  final bool? first;
  final int? totalElements;
}

class ApiErrorDetails {
  ApiErrorDetails({
    required this.errorCode,
    required this.message,
  });

  factory ApiErrorDetails.fromJson(Map<String, dynamic>? json) {
    return ApiErrorDetails(
      errorCode: json?['errorCode'] as String? ?? '',
      message: json?['message'] as String? ?? '',
    );
  }
  final String errorCode;
  final String message;
}
