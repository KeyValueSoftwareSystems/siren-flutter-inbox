import 'dart:convert';

import 'package:dio/dio.dart';

class APIResponse<T> {
  APIResponse({
    required this.requestOptions,
    this.data,
    this.statusCode,
    this.statusMessage,
    this.isRedirect = false,
    this.redirects = const [],
    Map<String, dynamic>? extra,
    Headers? headers,
  })  : headers = headers ?? Headers(),
        extra = extra ?? <String, dynamic>{};

  /// The response payload in specific type.
  ///
  /// The content could have been transformed by the [Transformer]
  /// before it can use eventually.
  T? data;

  /// The [RequestOptions] used for the corresponding request.
  RequestOptions requestOptions;

  /// The HTTP status code for the response.
  ///
  /// This can be null if the response was constructed manually.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  String? statusMessage;

  /// Headers for the response.
  Headers headers;

  /// Whether the response has been redirected.
  ///
  /// The field rely on the implementation of the adapter.
  bool isRedirect;

  /// All redirections happened before the response respond.
  ///
  /// The field rely on the implementation of the adapter.
  List<RedirectRecord> redirects;

  /// Return the final real request URI (may be redirected).
  ///
  /// Note: Whether the field is available depends on whether the adapter
  /// supports or not.
  Uri get realUri =>
      redirects.isNotEmpty ? redirects.last.location : requestOptions.uri;

  /// An extra map that you can save your custom information in.
  ///
  /// The field is designed to be non-identical with
  /// [Options.extra] and [RequestOptions.extra].
  Map<String, dynamic> extra;

  @override
  String toString() {
    if (data is Map) {
      // Log encoded maps for better readability.
      return json.encode(data);
    }
    return data.toString();
  }
}
