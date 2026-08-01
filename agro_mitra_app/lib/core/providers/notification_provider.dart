import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

enum NotificationStatus { loading, loaded, error }

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  NotificationStatus _status = NotificationStatus.loading;
  List<AppNotification> _notifications = [];
  String? _errorMessage;

  NotificationStatus get status => _status;
  List<AppNotification> get notifications => _notifications;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _service.getNotifications();
      _status = NotificationStatus.loaded;
    } catch (e) {
      _status = NotificationStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> markRead(String id) async {
    try {
      await _service.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          title: _notifications[index].title,
          body: _notifications[index].body,
          type: _notifications[index].type,
          timestamp: _notifications[index].timestamp,
          isRead: true,
        );
        notifyListeners();
      }
    } catch (_) {}
  }
}
