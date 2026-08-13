import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/notification_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/notification_repository.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final int unreadCount;
  final String? errorMessage;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationRepository _repository;
  Timer? _timer;

  void startPolling() {
    _timer?.cancel();
    load();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => refreshCount());
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> load() async {
    if (state.notifications.isEmpty) {
      emit(
        state.copyWith(status: NotificationsStatus.loading, clearError: true),
      );
    }
    try {
      final results = await Future.wait<dynamic>([
        _repository.getNotifications(),
        _repository.getUnreadCount(),
      ]);
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: results[0] as List<AppNotification>,
          unreadCount: results[1] as int,
          clearError: true,
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          errorMessage: error.message,
        ),
      );
    }
  }

  Future<void> refreshCount() async {
    try {
      final count = await _repository.getUnreadCount();
      if (count != state.unreadCount) await load();
    } on AuthException {
      // El sondeo silencioso se reintentará en el siguiente intervalo.
    }
  }

  Future<void> markAsRead(AppNotification notification) async {
    if (notification.isRead) return;
    await _repository.markAsRead(notification.id);
    final updated = state.notifications
        .map(
          (item) =>
              item.id == notification.id ? item.copyWith(isRead: true) : item,
        )
        .toList(growable: false);
    emit(
      state.copyWith(
        notifications: updated,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      ),
    );
  }

  Future<void> markAllAsRead() async {
    if (state.unreadCount == 0) return;
    await _repository.markAllAsRead();
    emit(
      state.copyWith(
        notifications: state.notifications
            .map((item) => item.copyWith(isRead: true))
            .toList(growable: false),
        unreadCount: 0,
      ),
    );
  }

  Future<void> deleteNotification(AppNotification notification) async {
    await _repository.deleteNotification(notification.id);
    emit(
      state.copyWith(
        notifications: state.notifications
            .where((item) => item.id != notification.id)
            .toList(growable: false),
        unreadCount: !notification.isRead && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      ),
    );
  }

  Future<void> deleteAllNotifications() async {
    if (state.notifications.isEmpty) return;
    await _repository.deleteAllNotifications();
    emit(
      state.copyWith(notifications: const [], unreadCount: 0, clearError: true),
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
