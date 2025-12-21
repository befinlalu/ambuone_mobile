part of 'index.dart';

abstract class UserRepo {
  Future<ApiResponse<UserDetails>> getUserDetails(int id);
}
