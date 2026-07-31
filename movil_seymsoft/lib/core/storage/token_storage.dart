import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static String? _sessionAccessToken;
  static void Function()? _onClearCallback;

  /// Registra un callback que será invocado cuando `clear()` sea llamado.
  static void registerOnClear(void Function()? callback) {
    _onClearCallback = callback;
  }

  Future<String?> getAccessToken() async {
    if (_sessionAccessToken != null) return _sessionAccessToken;
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_accessTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required bool persist,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    _sessionAccessToken = accessToken;
    if (persist) {
      await preferences.setString(_accessTokenKey, accessToken);
      await preferences.setString(_refreshTokenKey, refreshToken);
    } else {
      await preferences.remove(_accessTokenKey);
      await preferences.remove(_refreshTokenKey);
    }
  }

  Future<void> clear() async {
    _sessionAccessToken = null;
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_accessTokenKey);
    await preferences.remove(_refreshTokenKey);
    try {
      _onClearCallback?.call();
    } catch (_) {
      // ignore callback errors
    }
  }

  Future<String?> getRefreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_refreshTokenKey);
  }
}
