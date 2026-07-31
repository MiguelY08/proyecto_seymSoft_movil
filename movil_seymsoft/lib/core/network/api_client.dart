import 'dart:async';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient(this._tokenStorage)
    : dio = Dio(_baseOptions()),
      _refreshDio = Dio(_baseOptions()) {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  final TokenStorage _tokenStorage;
  final Dio dio;
  final Dio _refreshDio;
  Completer<bool>? _refreshCompleter;

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] != true) {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final isUnauthorized = error.response?.statusCode == 401;
    final canRetry = request.extra['retried'] != true;
    final isAuthRequest =
        request.path.contains('/auth/login') ||
        request.path.contains('/auth/refresh');

    if (!isUnauthorized || !canRetry || isAuthRequest) {
      handler.next(error);
      return;
    }

    final refreshed = await _refreshAccessToken();
    if (!refreshed) {
      handler.next(error);
      return;
    }

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.extra['retried'] = true;
      final response = await dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _tokenStorage.clear();
        completer.complete(false);
      } else {
        final response = await _refreshDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );
        final data = response.data?['data'] as Map<String, dynamic>?;
        final accessToken = data?['accessToken'] as String?;

        if (accessToken == null || accessToken.isEmpty) {
          await _tokenStorage.clear();
          completer.complete(false);
        } else {
          await _tokenStorage.saveAccessToken(accessToken);
          completer.complete(true);
        }
      }
    } catch (_) {
      await _tokenStorage.clear();
      completer.complete(false);
    } finally {
      _refreshCompleter = null;
    }

    return completer.future;
  }
}
