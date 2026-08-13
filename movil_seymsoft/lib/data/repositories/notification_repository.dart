import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/notification_models.dart';
import 'auth_repository.dart';

class NotificationRepository {
  const NotificationRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AppNotification>> getNotifications({int limit = 30}) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/notifications',
        queryParameters: {'page': 1, 'limit': limit},
      );
      final data = response.data?['data'] as List<dynamic>? ?? const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList(growable: false);
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/notifications/unread-count',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      return (data?['unreadCount'] as num?)?.toInt() ?? 0;
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _apiClient.dio.patch<void>('/notifications/$id/read');
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.dio.patch<void>('/notifications/read-all');
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _apiClient.dio.delete<void>('/notifications/$id');
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      await _apiClient.dio.delete<void>('/notifications/all');
    } on DioException catch (error) {
      throw AuthException(_message(error));
    }
  }

  String _message(DioException error) {
    final body = error.response?.data;
    if (body is Map<String, dynamic> && body['message'] is String) {
      return body['message'] as String;
    }
    return 'No fue posible cargar las notificaciones';
  }
}
