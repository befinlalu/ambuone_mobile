part of 'index.dart';

abstract class AlertRepo {
  Future<ApiResponse<AlertResponseModel>> sendAlert(AlertRequestModel alert);
}
