import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';

class ApiClient {
  ApiClient(this._tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: const {'Accept': 'application/json'},
          ),
        ) {
    dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: (options, handler) async {
        if (options.extra['skipAuth'] != true) {
          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      }),
      InterceptorsWrapper(onError: (error, handler) async {
        final response = error.response;
        final requestOptions = error.requestOptions;

        // Only attempt refresh for 401 responses and when not explicitly skipped
        final extra = requestOptions.extra ?? <String, dynamic>{};
        if (response?.statusCode == 401 && extra['skipAuth'] != true && extra['retry'] != true) {
          try {
            final refreshToken = await _tokenStorage.getRefreshToken();
            if (refreshToken == null || refreshToken.isEmpty) {
              return handler.next(error);
            }

            // Delegate refresh to AuthRepository helper to avoid ApiClient/AuthRepository
            // construction cycles. If refresh succeeds, retry; otherwise clear tokens.
            final refreshed = await AuthRepository.refreshSession(_tokenStorage);
            if (!refreshed) {
              await _tokenStorage.clear();
              return handler.next(error);
            }

            final newAccess = await _tokenStorage.getAccessToken();
            if (newAccess == null || newAccess.isEmpty) {
              await _tokenStorage.clear();
              return handler.next(error);
            }

            requestOptions.headers['Authorization'] = 'Bearer $newAccess';
            requestOptions.extra = {...extra, 'retry': true};
            final retryResponse = await dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            // ignore and continue to forward original error
          }
        }

        handler.next(error);
      }),
    ]);
    // Add verbose logging in debug/profile (prints to browser console on web)
    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
    }
  }

  final TokenStorage _tokenStorage;
  final Dio dio;
}
