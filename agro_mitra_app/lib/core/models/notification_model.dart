enum NotificationType { weather, market, system, alert }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: _parseType(json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
    );
  }

  static NotificationType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'weather': return NotificationType.weather;
      case 'market': return NotificationType.market;
      case 'alert': return NotificationType.alert;
      default: return NotificationType.system;
    }
  }
}
