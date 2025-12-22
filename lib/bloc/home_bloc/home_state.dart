part of 'index.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

class GetUserLoadingState extends HomeState {
  final String type;
  GetUserLoadingState({required this.type});
}

class GetUserSuccessState extends HomeState {
  final UserDetails? userDetails;
  GetUserSuccessState({required this.userDetails});
}

class GetUserErrorState extends HomeState {
  final String message;
  GetUserErrorState({required this.message});
}

class SendAlertLoadingState extends HomeState {}

class SendAlertSuccessState extends HomeState {}

class SendAlertErrorState extends HomeState {
  final String message;
  SendAlertErrorState({required this.message});
}

class GetLocationLoadingState extends HomeState {}

class GetLocationSuccessState extends HomeState {
  final double latitude;
  final double longitude;
  GetLocationSuccessState({required this.latitude, required this.longitude});
}

class GetLocationErrorState extends HomeState {
  final String message;
  GetLocationErrorState({required this.message});
}
