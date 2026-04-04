import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _phoneKey = 'rider_phone';
  static const _openQuoteAfterSignupKey = 'open_quote_after_signup';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> savePhone(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
  }

  static Future<String?> getPhone() async {
    return await _storage.read(key: _phoneKey);
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<void> markOpenQuoteAfterSignup() async {
    await _storage.write(key: _openQuoteAfterSignupKey, value: 'true');
  }

  static Future<bool> consumeOpenQuoteAfterSignup() async {
    final value = await _storage.read(key: _openQuoteAfterSignupKey);
    if (value == 'true') {
      await _storage.delete(key: _openQuoteAfterSignupKey);
      return true;
    }
    return false;
  }
}
