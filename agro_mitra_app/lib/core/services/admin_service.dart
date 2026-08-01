import '../api/api_client.dart';
import '../models/admin_model.dart';

class AdminService {
  final ApiClient _apiClient = ApiClient();

  Future<AdminDashboardSummary> getAdminDashboard() async {
    final response = await _apiClient.get('/api/v1/admin/dashboard');
    return AdminDashboardSummary.fromJson(response.data);
  }
}
