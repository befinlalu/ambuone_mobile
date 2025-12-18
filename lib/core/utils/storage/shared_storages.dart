part of 'index.dart';

class _StorageKeys {
  static const String accessToken = 'access-token';
  static const String refreshToken = 'refresh-token';
  static const String user = 'user';
}

class SharedStorages implements Storage {
  SharedStorages._privateConstructor();

  static final SharedStorages _instance = SharedStorages._privateConstructor();

  late final SharedPreferences _preferences;

  factory SharedStorages() {
    return _instance;
  }

  T? _getJsonObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final jsonString = _preferences.getString(key);
    if (jsonString != null) {
      try {
        return fromJson(jsonDecode(jsonString));
      } catch (e) {
        remove(key);
      }
    }
    return null;
  }

  Future<void> _setJsonObject(String key, dynamic object) async {
    if (object == null) {
      await remove(key);
    } else {
      final jsonString = jsonEncode(object.toJson());
      await _preferences.setString(key, jsonString);
    }
  }

  @override
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  @override
  String? getAccessToken() {
    return _preferences.getString(_StorageKeys.accessToken);
  }

  @override
  Future<void> setAccessToken(String? value) async {
    if (value != null) {
      await _preferences.setString(_StorageKeys.accessToken, value);
    }
  }

  @override
  String? getRefreshToken() {
    return _preferences.getString(_StorageKeys.refreshToken);
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    if (value != null) {
      await _preferences.setString(_StorageKeys.refreshToken, value);
    }
  }

  @override
  User? getUser() {
    return _getJsonObject(_StorageKeys.user, User.fromJson);
  }

  @override
  Future<void> setUser(User? user) {
    return _setJsonObject(_StorageKeys.user, user);
  }
}
