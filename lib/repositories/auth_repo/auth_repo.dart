part of 'index.dart';

abstract class AuthRepo {
  Future<ApiResponse<void>> loginOtp(String phoneNumber);
}
