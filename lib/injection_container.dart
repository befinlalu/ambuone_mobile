part of 'index.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthRepo>(AuthRepoImpli());
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
}
