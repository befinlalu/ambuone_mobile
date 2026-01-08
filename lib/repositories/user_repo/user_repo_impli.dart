part of 'index.dart';

class UserRepoImpli extends BaseRepository implements UserRepo {
  final _handler = RepositoryHandler();
  @override
  Future<ApiResponse<UserDetails>> getUserDetails(int id) async {
    return apiCall<UserDetails>(() {
      return _handler.handleGetRequest(
        endpoint: '/api/users/$id/',
        fromJson: (json) => UserDetails.fromJson(json),
      );
    });
  }

  @override
  Future<ApiResponse<UserDetails>> updateUserDetails(RegisterModel form) async {
    return apiCall<UserDetails>(() {
      return _handler.handleMultipartPatchRequest(
        endpoint: '/api/users/profile/',
        fields: form.toUpdateFields(),
        files: form.toUpdateFiles(),
        fromJson: (json) => UserDetails.fromJson(json),
      );
    });
  }
}
