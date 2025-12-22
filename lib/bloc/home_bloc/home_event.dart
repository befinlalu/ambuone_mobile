part of 'index.dart';

sealed class HomeEvent {}

class GetUserDetailsEvent extends HomeEvent {
  final int userId;
  final String type;
  GetUserDetailsEvent({required this.userId, this.type = 'G'});
}

class SendAlertEvent extends HomeEvent {
  final AlertRequestModel alertRequest;

  SendAlertEvent({required this.alertRequest});
}

class GetLocationEvent extends HomeEvent {}
