part of 'index.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthRepo>(AuthRepoImpli());
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));

  sl.registerSingleton<UserRepo>(UserRepoImpli());
  sl.registerSingleton<AlertRepo>(AlertRepoImpli());
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl(), sl()));
}
