part of 'index.dart';

class AlertRequestModel {
  final String? serialNumber;
  final double? latitude;
  final double? longitude;

  AlertRequestModel({this.serialNumber, this.latitude, this.longitude});

  factory AlertRequestModel.fromJson(Map<String, dynamic> json) {
    return AlertRequestModel(
      serialNumber: json['serial_number'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
