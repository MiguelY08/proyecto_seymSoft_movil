import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
<<<<<<< HEAD
import '../../core/config/api_config.dart';

class AuthRepository {
  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
      : this._(tokenStorage ?? TokenStorage(), apiClient);

  AuthRepository._(TokenStorage tokenStorage, ApiClient? apiClient)
      : _tokenStorage = tokenStorage,
        _apiClient = apiClient ?? ApiClient(tokenStorage);
=======
import '../models/auth_models.dart';

class AuthRepository {
  const AuthRepository({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

<<<<<<< HEAD
  Future<void> login({
=======
  Future<AuthProfile> login({
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
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
<<<<<<< HEAD
      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) {
        throw const AuthException('Respuesta inválida del servidor');
      }
      final role = data['role'];
      final roleName = role is Map<String, dynamic>
          ? role['nameRole'] ?? role['name_role']
          : null;
      if (roleName is! String || roleName.toLowerCase() != 'administrator') {
        await _tokenStorage.clear();
        throw const AuthException('Acceso exclusivo para administradores');
      }
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      if (accessToken is! String || refreshToken is! String) {
        throw const AuthException('El servidor no devolvió una sesión válida');
      }
=======
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

>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        persist: rememberSession,
      );
<<<<<<< HEAD
    } on DioException catch (error) {
      final body = error.response?.data;
      if (body is Map<String, dynamic> && body['message'] is String) {
        throw AuthException(body['message'] as String);
      }

      String detailed;
      if (error.type == DioExceptionType.connectionError) {
        detailed = 'No fue posible conectar con el servidor.';
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        detailed = 'El servidor tardó demasiado en responder.';
      } else {
        detailed = 'Error de red: ${error.message ?? 'Sin detalle'}';
      }

      // En web, muchos errores de CORS aparecen como errores de red sin response.
      // Añadimos una pista útil para el desarrollador/usuario.
      try {
        // evitar importar foundation en este archivo, usar kIsWeb vía conditional
        // pero podemos detectar por la ausencia de response en muchos casos
        if (error.response == null) {
          detailed = '$detailed\nNota: en web esto puede deberse a CORS. Verifica que el backend permita el origen de la app.';
        }
      } catch (_) {}

      throw AuthException(detailed);
    }
  }

  /// Intenta refrescar la sesión usando el [tokenStorage] provisto.
  /// Devuelve `true` si se obtuvieron y guardaron nuevos tokens.
  static Future<bool> refreshSession(TokenStorage tokenStorage, {Dio? client}) async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final dio = client ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final resp = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = resp.data?['data'];
      if (data is Map<String, dynamic>) {
        final accessToken = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;
        if (accessToken != null && newRefresh != null) {
          await tokenStorage.saveTokens(accessToken: accessToken, refreshToken: newRefresh, persist: true);
          return true;
        }
      }
    } on DioException {
      // fallthrough
    } catch (_) {
      // fallthrough
    }
    return false;
=======
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
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
<<<<<<< HEAD
=======

  @override
  String toString() => message;
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
}
