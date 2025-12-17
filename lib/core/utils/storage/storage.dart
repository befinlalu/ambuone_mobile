part of 'index.dart';

abstract class Storage {
  Future<void> init();

  Future<void> remove(String key);

  Future<void> clear();

  String? getAccessToken();

  Future<void> setAccessToken(String value);

  String? getRefreshToken();

  Future<void> setRefreshToken(String value);

  User? getUser();

  Future<void> setUser(User? user);
}
