import 'package:siren_flutter_inbox/src/errors/error_codes.dart';
import 'package:siren_flutter_inbox/src/models/rest_error_model.dart';

class AppException implements Exception {
  AppException({this.code, this.message = 'error', this.details});

  final dynamic code;
  final String message;
  final dynamic details;
}

class FetchDataException extends AppException {
  ///constructor
  FetchDataException(String? message, {String? super.details})
      : super(
          code: ErrorCode.ERR_NETWORK_ERROR,
          message: message ?? 'Error During Communication',
        );

  factory FetchDataException.networkException() {
    return FetchDataException(
      'No Internet connection please check your network',
    );
  }
}

///bad request exception
class BadRequestException extends AppException {
  ///constructor
  BadRequestException(String? details, {RestError? restApiError})
      : super(
          code: restApiError?.status ?? 'Invalid Request',
          message: restApiError?.getBackendErrorMessage() ?? details ?? '',
          details: restApiError?.details ?? details,
        );
}

///bad request exception
class NotFoundException extends AppException {
  NotFoundException(String? details, {RestError? restApiError})
      : super(
          code: restApiError?.status ?? 'Invalid Request',
          message: restApiError?.getBackendErrorMessage() ?? details ?? '',
          details: restApiError?.details ?? details,
        );
}

///class for unauthorised exception
class UnauthorisedException extends AppException {
  ///constructor
  UnauthorisedException(String? details, {RestError? restApiError})
      : super(
          code: restApiError?.status ?? 'UnAuthorized',
          message: restApiError?.title ?? details ?? '',
          details: restApiError?.details ?? details,
        );
}

class ConflictException extends AppException {
  ///constructor
  ConflictException(String? details, {RestError? restApiError})
      : super(
          code: restApiError?.status ?? 'Conflict',
          message: restApiError?.getBackendErrorMessage() ?? details ?? '',
          details: restApiError?.details ?? details,
        );
}

///Invalid input exception
class InvalidInputException extends AppException {
  ///constructor
  InvalidInputException(String? details)
      : super(
          code: 'invalid-input',
          message: 'Invalid Input',
          details: details,
        );
}

///Authentication exception
class AuthenticationException extends AppException {
  ///constructor
  AuthenticationException(String? details)
      : super(
          code: 'authentication-failed',
          message: 'Authentication Failed',
          details: details,
        );
}

///Timeout exception
class TimeOutException extends AppException {
  ///constructor
  TimeOutException(String? details)
      : super(
          code: 'request-timeout',
          message: 'Request TimeOut',
          details: details,
        );
}
