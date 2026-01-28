part of 'index.dart';

abstract class UserRepo {
  Future<ApiResponse<UserDetails>> getUserDetails(int id);
  Future<ApiResponse<UserDetails>> updateUserDetails(RegisterModel form);

  Future<ApiResponse<void>> deleteUserDetails();
}
