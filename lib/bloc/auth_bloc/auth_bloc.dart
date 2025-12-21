part of 'index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<GetLoginOtpEvent>(getLoginOtp);
    on<GetRegisterOtpEvent>(getRegisterOtp);
    on<VerifyLoginOtpEvent>(verifyLoginOtp);
    on<VerifyRegisterOtpEvent>(veifyRegisterOtp);
    on<VerfiySerialEvent>(verfiySerial);
  }

  FutureOr<void> getLoginOtp(
    GetLoginOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final res = await authRepo.loginOtp(event.phoneNumber);

      if (res.success) {
        emit(GetOtpSuccessState(phone: event.phoneNumber));
      } else {
        emit(GetOtpErrorState(message: res.message));
      }
    } catch (e) {
      emit(GetOtpErrorState(message: e.toString()));
    }
  }

  FutureOr<void> getRegisterOtp(
    GetRegisterOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final res = await authRepo.registerOtp(event.phoneNumber);

      if (res.success) {
        emit(GetOtpSuccessState(phone: event.phoneNumber));
      } else {
        emit(GetOtpErrorState(message: res.message));
      }
    } catch (e) {
      emit(GetOtpErrorState(message: e.toString()));
    }
  }

  FutureOr<void> verifyLoginOtp(
    VerifyLoginOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final res = await authRepo.login(event.phoneNumber, event.otp);

      if (res.success) {
        await SharedStorages().setAccessToken(res.data?.access ?? "");
        await SharedStorages().setRefreshToken(res.data?.refresh ?? "");
        await SharedStorages().setUser(res.data?.user);
        emit(VerifyOtpSuccessState());
      } else {
        emit(VerifyOtpErrorState(message: res.message));
      }
    } catch (e) {
      emit(VerifyOtpErrorState(message: e.toString()));
    }
  }

  FutureOr<void> veifyRegisterOtp(
    VerifyRegisterOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final res = await authRepo.register(event.registerModel);

      if (res.success) {
        emit(VerfiyRegisterOtpSuccessState());
      } else {
        emit(RegisterErrorState(message: res.message));
      }
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    }
  }

  FutureOr<void> verfiySerial(
    VerfiySerialEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final res = await authRepo.verfiySerial(event.serial);

      if (res.success) {
        emit(VerfiySerialSuccessState());
      } else {
        emit(VerfiySerialErrorState(message: res.message));
      }
    } catch (e) {
      emit(VerfiySerialErrorState(message: e.toString()));
    }
  }
}
