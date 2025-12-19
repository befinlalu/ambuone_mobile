part of 'index.dart';

abstract class AuthRepo {
  Future<ApiResponse<void>> loginOtp(String phoneNumber);
  Future<ApiResponse<LoginResponseModel>> login(String phoneNumber, String otp);
  Future<ApiResponse<void>> registerOtp(String phoneNumber);
  Future<ApiResponse<void>> register(RegisterModel registerForm);
}
