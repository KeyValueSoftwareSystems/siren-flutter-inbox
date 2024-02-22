// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first

class RestError {
  List<String> errors;
  String status;
  int statusCode;
  String? title;
  String? details;

  factory RestError.unknownError() {
    return RestError(errors: [], status: '999', statusCode: 0);
  }

  String getBackendErrorMessage() {
    return errors.join('\n');
  }

//<editor-fold desc="Data Methods">
  RestError({
    required this.errors,
    required this.status,
    required this.statusCode,
    this.title,
    this.details,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestError &&
          runtimeType == other.runtimeType &&
          errors == other.errors &&
          status == other.status &&
          statusCode == other.statusCode &&
          title == other.title &&
          details == other.details);

  @override
  int get hashCode =>
      errors.hashCode ^
      status.hashCode ^
      statusCode.hashCode ^
      title.hashCode ^
      details.hashCode;

  @override
  String toString() {
    return 'RestError{ errors: $errors, status: $status, statusCode: $statusCode, title: $title, details: $details,}';
  }

  RestError copyWith({
    List<String>? errors,
    String? status,
    int? statusCode,
    String? title,
    String? details,
  }) {
    return RestError(
      errors: errors ?? this.errors,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      title: title ?? this.title,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'errors': errors,
      'status': status,
      'statusCode': statusCode,
      'title': title,
      'details': details,
    };
  }

  factory RestError.fromMap(Map<String, dynamic> map) {
    return RestError(
      errors: List<String>.from(map['errors'] as List<dynamic>),
      status: map['status'] as String,
      statusCode: map['statusCode'] as int,
    );
  }

//</editor-fold>
}
