part of 'index.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

class GetUserLoadingState extends UserState {
  final String type;
  GetUserLoadingState({required this.type});
}

class GetUserSuccessState extends UserState {
  final UserDetails? userDetails;
  GetUserSuccessState({required this.userDetails});
}

class GetUserErrorState extends UserState {
  final String message;
  GetUserErrorState({required this.message});
}

class UpdateProfileLoadingState extends UserState {}

class UpdateProfileSuccessState extends UserState {
  final UserDetails? userDetails;
  UpdateProfileSuccessState({required this.userDetails});
}

class UpdateProfileErrorState extends UserState {
  final String message;
  UpdateProfileErrorState({required this.message});
}
