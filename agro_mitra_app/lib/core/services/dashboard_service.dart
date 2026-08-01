import '../api/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  Future<DashboardSummary> getFarmerDashboard() async {
    final response = await _apiClient.get('/api/v1/farmer/dashboard');
    return DashboardSummary.fromJson(response.data);
  }
}
