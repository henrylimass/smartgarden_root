// lib/notification_item.dart
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool read;
  final String? plantId;
  final String? avatarUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.plantId,
    this.avatarUrl,
  });
}
