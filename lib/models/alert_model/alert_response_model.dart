part of 'index.dart';

class AlertResponseModel {
  final String? status;
  final String? message;
  final int? alertId;

  AlertResponseModel({this.status, this.message, this.alertId});

  factory AlertResponseModel.fromJson(Map<String, dynamic> json) {
    return AlertResponseModel(
      status: json['status'],
      message: json['message'],
      alertId: json['alert_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'alert_id': alertId};
  }
}
