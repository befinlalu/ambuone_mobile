part of 'index.dart';

class LoginResponseModel {
  final String? refresh;
  final String? access;
  final User? user;

  LoginResponseModel({this.refresh, this.access, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        refresh: json["refresh"],
        access: json["access"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? phoneNumber;
  final String? role;

  User({this.id, this.phoneNumber, this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    phoneNumber: json["phone_number"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone_number": phoneNumber,
    "role": role,
  };
}
