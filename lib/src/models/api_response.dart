class ApiResponse {
  ApiResponse({
    this.data,
    this.meta,
    this.error,
  });

  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      error: ApiErrorDetails.fromJson(json['error'] as Map<String, dynamic>?),
      meta: MetaResponse.fromJson(json?['meta'] as Map<String, dynamic>?),
    );
  }

  bool isLoading = true;
  bool isSuccess = false;
  bool isError = false;

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
      last: json?['last'] as String?,
      totalPages: int.tryParse(json?['totalPages'] as String),
      pageSize: int.tryParse(json?['pageSize'] as String),
      currentPage: int.tryParse(json?['currentPage'] as String),
      first: json?['first'] as String,
      totalElements: int.tryParse(json?['totalElements'] as String),
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
