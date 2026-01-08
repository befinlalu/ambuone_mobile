part of 'index.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;
  UserBloc(this.userRepo) : super(UserInitial()) {
    on<UserEvent>((event, emit) {});
    on<GetUserDetailsEvent>(getUserDetails);
    on<UpdateProfileEvent>(updateProfile);
  }

  FutureOr<void> getUserDetails(
    GetUserDetailsEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(GetUserLoadingState(type: event.type));
    try {
      final res = await userRepo.getUserDetails(event.userId);

      if (res.success) {
        SharedStorages().setUserDetails(res.data);
        emit(GetUserSuccessState(userDetails: res.data));
      } else {
        emit(GetUserErrorState(message: res.message));
      }
    } catch (e) {
      emit(GetUserErrorState(message: e.toString()));
    }
  }

  FutureOr<void> updateProfile(
    UpdateProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UpdateProfileLoadingState());
    try {
      final res = await userRepo.updateUserDetails(event.form);

      if (res.success) {
        SharedStorages().setUserDetails(res.data);
        emit(UpdateProfileSuccessState(userDetails: res.data));
      } else {
        emit(UpdateProfileErrorState(message: res.message));
      }
    } catch (e) {
      emit(UpdateProfileErrorState(message: e.toString()));
    }
  }
}
