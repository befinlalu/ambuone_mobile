part of 'index.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepo userRepo;
  final AlertRepo alertRepo;
  HomeBloc(this.userRepo, this.alertRepo) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<GetUserDetailsEvent>(getUserDetails);
    on<SendAlertEvent>(sendAlert);
    on<GetLocationEvent>(getLocation);
  }

  FutureOr<void> getUserDetails(
    GetUserDetailsEvent event,
    Emitter<HomeState> emit,
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

  FutureOr<void> sendAlert(
    SendAlertEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(SendAlertLoadingState());
    try {
      final res = await alertRepo.sendAlert(event.alertRequest);
      if (res.success) {
        emit(SendAlertSuccessState());
      } else {
        emit(SendAlertErrorState(message: res.message));
      }
    } catch (e) {
      emit(SendAlertErrorState(message: e.toString()));
    }
  }

  FutureOr<void> getLocation(
    GetLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetLocationLoadingState());
    try {
      final hasPermission = await PermissionService.requestLocationPermission();

      if (!hasPermission) {
        emit(GetLocationErrorState(message: "Location permission not granted"));
        return;
      }

      final position = await LocationService.getCurrentLocation();
      final double lat = double.parse(position.latitude.toStringAsFixed(6));
      final double long = double.parse(position.longitude.toStringAsFixed(6));

      emit(GetLocationSuccessState(latitude: lat, longitude: long));
    } catch (e) {
      emit(GetLocationErrorState(message: e.toString()));
    }
  }
}
