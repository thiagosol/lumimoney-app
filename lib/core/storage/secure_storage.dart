import 'package:hive/hive.dart';

class SecureStorage {
  static const String _userBoxName = 'userBox';
  static const String _tokenKey = 'token';

  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_userBoxName);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final box = await Hive.openBox(_userBoxName);
    return box.get(_tokenKey) as String?;
  }

  static Future<void> clearToken() async {
    final box = await Hive.openBox(_userBoxName);
    await box.delete(_tokenKey);
  }

  static Future<void> clearAll() async {
    final box = await Hive.openBox(_userBoxName);
    await box.clear();
  }
}
