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

  @override
  Future<ApiResponse<LoginResponseModel>> login(
    String phoneNumber,
    String otp,
  ) async {
    return apiCall<LoginResponseModel>(() {
      return _handler.handlePostRequest(
        endpoint: '/api/users/login/otp-verify/',
        body: {'phone_number': phoneNumber, 'otp': otp},
        fromJson: (json) => LoginResponseModel.fromJson(json),
      );
    });
  }

  @override
  Future<ApiResponse<void>> registerOtp(String phoneNumber) {
    return apiCall<void>(() {
      return _handler.handlePostRequest<Map<String, dynamic>>(
        endpoint: '/api/users/register/request-otp/',
        body: {'phone_number': phoneNumber},
        fromJson: (json) => json,
      );
    });
  }

  @override
  Future<ApiResponse<void>> register(RegisterModel registerForm) {
    return apiCall<void>(() {
      return _handler.handleMultipartPostRequest<Map<String, dynamic>>(
        endpoint: '/api/users/register/subscriber/',
        fields: registerForm.toFields(),
        files: registerForm.toFiles(),
        fromJson: (json) => json,
      );
    });
  }
}
