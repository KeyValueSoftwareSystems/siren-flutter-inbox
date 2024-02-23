///this clas represents the current request form
class APIRequestRepresentable {
  /// constructor
  APIRequestRepresentable({
    required this.url,
    this.method = HTTPMethod.get,
    this.query,
    this.fileName,
    this.body,
    this.headers,
    this.noOfRetry = 1,
    this.currentRequestNumber = 0,
    this.skipAuthHeaders = false,
    this.isMultipart = false,
  });

  ///for the endpoint
  String url;

  ///for the no of retries
  int noOfRetry;

  ///represents the current request number
  int currentRequestNumber;

  HTTPMethod method;

  String? fileName;

  /// represents the current query
  Map<String, dynamic>? query;

  ///reporesents the header
  Map<String, String>? headers;

  bool skipAuthHeaders;

  bool isMultipart;

  @override
  String toString() {
    return 'APIRequestRepresentable{url: $url, noOfRetry: $noOfRetry, currentRequestNumber: $currentRequestNumber, method: $method, fileName: $fileName, query: $query, headers: $headers, body: $body}';
  }

  ///represents the body
  dynamic body;

  ///copy with to copy obbjects
  APIRequestRepresentable copyWith({
    String? url,
    int? noOfRetry,
    int? currentRequestNumber,
    HTTPMethod? method,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    dynamic body,
    bool? skipAuthHeaders,
  }) {
    return APIRequestRepresentable(
      url: url ?? this.url,
      noOfRetry: noOfRetry ?? this.noOfRetry,
      currentRequestNumber: currentRequestNumber ?? this.currentRequestNumber,
      method: method ?? this.method,
      query: query ?? this.query,
      skipAuthHeaders: skipAuthHeaders ?? this.skipAuthHeaders,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }
}

enum HTTPMethod { get, post, delete, put, patch, download }

///for request methods
extension HTTPMethodString on HTTPMethod {
  String get string {
    switch (this) {
      case HTTPMethod.get:
        return 'get';
      case HTTPMethod.post:
        return 'post';
      case HTTPMethod.delete:
        return 'delete';
      case HTTPMethod.patch:
        return 'patch';
      case HTTPMethod.put:
        return 'put';
      case HTTPMethod.download:
        return 'download';
    }
  }
}
