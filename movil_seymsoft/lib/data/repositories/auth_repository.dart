import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../models/auth_models.dart';

class AuthRepository {
  const AuthRepository({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<AuthProfile> login({
    required String email,
    required String password,
    required bool rememberSession,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const AuthException('Respuesta inválida del servidor');
      }

      final profile = AuthProfile.fromJson(data);
      if (!profile.role.isAdministrator) {
        throw const AuthException('Acceso exclusivo para administradores');
      }

      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken == null || refreshToken == null) {
        throw const AuthException('La sesión no contiene tokens válidos');
      }

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        persist: rememberSession,
      );

      return profile;
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    }
  }

  Future<AuthProfile?> restoreSession() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      return await getProfile();
    } on AuthException {
      await _tokenStorage.clear();
      return null;
    }
  }

  Future<AuthProfile> getProfile() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/auth/me',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const AuthException('No fue posible obtener el perfil');
      }

      final profile = AuthProfile.fromJson(data);
      if (!profile.role.isAdministrator) {
        await _tokenStorage.clear();
        throw const AuthException('Acceso exclusivo para administradores');
      }
      return profile;
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _apiClient.dio.post<Map<String, dynamic>>(
          '/auth/logout',
          data: {'refresh_token': refreshToken},
        );
      }
    } finally {
      await _tokenStorage.clear();
    }
  }

  static Future<bool> refreshSession(TokenStorage tokenStorage, {Dio? client}) async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final dio = client ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      final accessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      if (accessToken == null || newRefreshToken == null) {
        return false;
      }

      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
        persist: true,
      );
      return true;
    } on DioException {
      return false;
    }
  }

  String _messageFromDio(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardó demasiado en responder';
      case DioExceptionType.connectionError:
        return 'No fue posible conectar con el servidor';
      default:
        return 'Ocurrió un error al comunicarse con el servidor';
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
