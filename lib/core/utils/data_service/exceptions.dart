part of 'index.dart';

abstract class ApiException implements Exception {
  final dynamic error;
  final int? statusCode;

  ApiException(this.error, [this.statusCode]);
}

class NetworkException extends ApiException {
  NetworkException(super.error);
}

class RepositoryException extends ApiException {
  RepositoryException(super.error);
}

class TimeoutException extends ApiException {
  TimeoutException(super.error);
}

class CustomException extends ApiException {
  CustomException(super.error, [super.statusCode]);
}

class UnAuthenticateException extends ApiException {
  UnAuthenticateException(super.error, [super.statusCode]);
}
