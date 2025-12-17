part of 'index.dart';

sealed class AuthEvent {}

class GetLoginOtpEvent extends AuthEvent {
  final String phoneNumber;
  GetLoginOtpEvent({required this.phoneNumber});
}

class GetRegisterOtpEvent extends AuthEvent {
  final String phoneNumber;
  GetRegisterOtpEvent({required this.phoneNumber});
}

class VerifyLoginOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  VerifyLoginOtpEvent({required this.phoneNumber, required this.otp});
}
