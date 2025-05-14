import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataStorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
