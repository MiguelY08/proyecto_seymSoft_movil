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
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required bool persist,
  }) async {
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
    }
  }

  Future<void> clear() async {
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
  }
}
