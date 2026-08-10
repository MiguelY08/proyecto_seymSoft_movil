import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/notification_models.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Notificaciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) => TextButton(
                      onPressed: state.unreadCount == 0
                          ? null
                          : () => context
                                .read<NotificationsCubit>()
                                .markAllAsRead(),
                      child: const Text('Marcar todas'),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state.status == NotificationsStatus.loading &&
                      state.notifications.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == NotificationsStatus.failure &&
                      state.notifications.isEmpty) {
                    return _Message(
                      text:
                          state.errorMessage ??
                          'No fue posible cargar las notificaciones',
                      onRetry: () => context.read<NotificationsCubit>().load(),
                    );
                  }
                  if (state.notifications.isEmpty) {
                    return const _Message(text: 'No tienes notificaciones');
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<NotificationsCubit>().load(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.notifications.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return _NotificationTile(notification: notification);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead ? Colors.white : const Color(0xFFEAF2FB),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: _color.withValues(alpha: 0.14),
          child: Icon(_icon, color: _color, size: 21),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${notification.message}\n${_relativeTime(notification.createdAt)}',
          ),
        ),
        isThreeLine: true,
        trailing: notification.isRead
            ? null
            : const Icon(Icons.circle, size: 9, color: Color(0xFF1565C0)),
        onTap: () async {
          try {
            await context.read<NotificationsCubit>().markAsRead(notification);
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No fue posible marcar la notificación'),
                ),
              );
            }
          }
        },
      ),
    );
  }

  IconData get _icon {
    switch (notification.type) {
      case 'sale':
      case 'order':
        return Icons.point_of_sale_rounded;
      case 'purchase':
        return Icons.shopping_bag_rounded;
      case 'stock':
        return Icons.inventory_2_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get _color {
    switch (notification.type) {
      case 'sale':
      case 'order':
        return const Color(0xFF1565C0);
      case 'purchase':
        return const Color(0xFF2E7D32);
      case 'warning':
      case 'stock':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF455A64);
    }
  }

  String _relativeTime(DateTime date) {
    final difference = DateTime.now().difference(date.toLocal());
    if (difference.inMinutes < 1) return 'Ahora';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'Hace ${difference.inHours} h';
    if (difference.inDays < 7) return 'Hace ${difference.inDays} d';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.notifications_none, size: 54, color: Colors.grey),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ],
    ),
  );
}
