part of 'index.dart';

abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class RepositoryException extends ApiException {
  RepositoryException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class CustomException extends ApiException {
  CustomException(super.message, [super.statusCode]);
}

class UnAuthenticateException extends ApiException {
  UnAuthenticateException(super.message, [super.statusCode]);
}
