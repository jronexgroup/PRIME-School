import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyModeAuthService {
  static const _passwordHashKey = 'study_mode_password_hash';
  static const _saltKey = 'study_mode_salt';

  Future<bool> isPasswordSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_passwordHashKey);
  }

  Future<void> setPassword(String password) async {
    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters');
    }
    final prefs = await SharedPreferences.getInstance();
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);
    await prefs.setString(_saltKey, salt);
    await prefs.setString(_passwordHashKey, hash);
  }

  Future<bool> verifyPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString(_passwordHashKey);
    final salt = prefs.getString(_saltKey);
    if (storedHash == null || salt == null) return false;
    return storedHash == _hashPassword(password, salt);
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  String _hashPassword(String password, String salt) {
    final key = utf8.encode(password);
    final salted = utf8.encode(salt);
    final bytes = sha256.convert([...salted, ...key]).bytes;
    return base64Encode(bytes);
  }
}
