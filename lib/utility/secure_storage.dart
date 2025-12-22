import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neeknots_admin/models/user_model.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );
  static Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    // Save full user json
    await _storage.write(key: "user", value: userJson);
    // Save token separately
    await _storage.write(key: "token", value: user.token);
  }

  static Future<UserModel?> getUser() async {
    final jsonStr = await _storage.read(key: "user");
    if (jsonStr == null) return null;
    return UserModel.fromLocalJson(jsonDecode(jsonStr));
  }

  // Get only token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Delete
  static Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
