part of 'index.dart';

class VersionRepoImpli extends BaseRepository implements VersionRepo {
  final _handler = RepositoryHandler();
  @override
  Future<ApiResponse<VersionModel>> getVersion() {
    return apiCall<VersionModel>(() {
      return _handler.handleGetRequest(
        endpoint: '/api/dashboard/app-config/',
        fromJson: (json) => VersionModel.fromJson(json),
      );
    });
  }
}
