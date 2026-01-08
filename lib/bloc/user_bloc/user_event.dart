part of 'index.dart';

sealed class UserEvent {}

class GetUserDetailsEvent extends UserEvent {
  final int userId;
  final String type;
  GetUserDetailsEvent({required this.userId, this.type = 'G'});
}

class UpdateProfileEvent extends UserEvent {
  final RegisterModel form;
  UpdateProfileEvent({required this.form});
}
