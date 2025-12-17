part of 'index.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class GetOtpSuccessState extends AuthState {}

class GetOtpErrorState extends AuthState {
  final String message;
  GetOtpErrorState({required this.message});
}

class VerifyOtpSuccessState extends AuthState {}

class VerifyOtpErrorState extends AuthState {
  final String message;
  VerifyOtpErrorState({required this.message});
}
