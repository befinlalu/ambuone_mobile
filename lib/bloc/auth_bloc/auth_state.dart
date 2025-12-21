part of 'index.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class GetOtpSuccessState extends AuthState {
  final String phone;
  GetOtpSuccessState({required this.phone});
}

class GetOtpErrorState extends AuthState {
  final String message;
  GetOtpErrorState({required this.message});
}

class VerifyOtpSuccessState extends AuthState {}

class VerifyOtpErrorState extends AuthState {
  final String message;
  VerifyOtpErrorState({required this.message});
}

class GetRegisterOtpSuccessState extends AuthState {}

class VerfiyRegisterOtpSuccessState extends AuthState {}

class RegisterErrorState extends AuthState {
  final String message;
  RegisterErrorState({required this.message});
}

class VerfiySerialSuccessState extends AuthState {}

class VerfiySerialErrorState extends AuthState {
  final String message;
  VerfiySerialErrorState({required this.message});
}
