part of 'index.dart';

class AuthRepoImpli extends BaseRepository implements AuthRepo {
  final _handler = RepositoryHandler();

  @override
  Future<ApiResponse<void>> loginOtp(String phoneNumber) async {
    return apiCall<void>(() {
      return _handler.handlePostRequest<Map<String, dynamic>>(
        endpoint: '/api/users/login/otp-request/',
        body: {'phone_number': phoneNumber},
        fromJson: (json) => json,
      );
    });
  }
}
