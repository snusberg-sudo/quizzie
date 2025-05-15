import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataStorageService {

  UserDataStorageService._internal();

  static final UserDataStorageService _instance = UserDataStorageService._internal();

  factory UserDataStorageService() => _instance;

  final _storage = FlutterSecureStorage();

  Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAuth() async {
    await _storage.delete(key:'user_id');
    await _storage.delete(key:'email');
    await _storage.delete(key:'name');
    await _storage.delete(key:'token');
  }
}
