import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  String? _sessionAccessToken;
  void Function()? _onClearCallback;
  bool _persistTokens = true;

  /// Registra un callback que será invocado cuando `clear()` sea llamado.
  void registerOnClear(void Function()? callback) {
    _onClearCallback = callback;
  }

  Future<String?> getAccessToken() async {
    if (_sessionAccessToken != null) return _sessionAccessToken;
    final token = await _secureStorage.read(key: _accessTokenKey);
    _sessionAccessToken = token;
    return token;
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required bool persist,
  }) async {
    _sessionAccessToken = accessToken;
    _persistTokens = persist;

    if (persist) {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _deletePersistedTokens();
    }
  }

  Future<void> saveAccessToken(String accessToken) async {
    _sessionAccessToken = accessToken;
    if (_persistTokens) {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    }
  }

  Future<void> clear() async {
    _sessionAccessToken = null;
    _persistTokens = true;
    await _deletePersistedTokens();
    try {
      _onClearCallback?.call();
    } catch (_) {
      // ignore callback errors
    }
  }

  Future<void> _deletePersistedTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }
}
