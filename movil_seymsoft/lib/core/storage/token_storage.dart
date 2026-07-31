<<<<<<< HEAD
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
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;
  bool _persistTokens = true;

  Future<String?> getAccessToken() async {
    return _accessToken ?? await _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken ?? await _secureStorage.read(key: _refreshTokenKey);
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required bool persist,
  }) async {
<<<<<<< HEAD
    final preferences = await SharedPreferences.getInstance();
    _sessionAccessToken = accessToken;
    if (persist) {
      await preferences.setString(_accessTokenKey, accessToken);
      await preferences.setString(_refreshTokenKey, refreshToken);
    } else {
      await preferences.remove(_accessTokenKey);
      await preferences.remove(_refreshTokenKey);
=======
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _persistTokens = persist;

    if (persist) {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _deletePersistedTokens();
    }
  }

  Future<void> saveAccessToken(String accessToken) async {
    _accessToken = accessToken;
    if (_persistTokens) {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
    }
  }

  Future<void> clear() async {
<<<<<<< HEAD
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
=======
    _accessToken = null;
    _refreshToken = null;
    _persistTokens = true;
    await _deletePersistedTokens();
  }

  Future<void> _deletePersistedTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
  }
}
