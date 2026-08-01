import '../api/api_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<AppNotification>> getNotifications() async {
    final response = await _apiClient.get('/api/v1/notifications');
    return (response.data as List).map((e) => AppNotification.fromJson(e)).toList();
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.post('/api/v1/notifications/$id/read');
  }
}
