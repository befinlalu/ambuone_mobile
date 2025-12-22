part of 'index.dart';

class AlertRepoImpli extends BaseRepository implements AlertRepo {
  final _handler = RepositoryHandler();
  @override
  Future<ApiResponse<AlertResponseModel>> sendAlert(
    AlertRequestModel alert,
  ) async {
    return apiCall<AlertResponseModel>(() {
      return _handler.handlePostRequest(
        endpoint: '/api/qr/emergency-alert/direct/',
        body: alert.toJson(),
        fromJson: (json) => AlertResponseModel.fromJson(json),
      );
    });
  }
}
