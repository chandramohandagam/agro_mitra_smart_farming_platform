import '../api/api_client.dart';
import '../models/dealer_model.dart';

class DealerService {
  final ApiClient _apiClient = ApiClient();

  Future<DealerDashboardSummary> getDealerDashboard() async {
    final response = await _apiClient.get('/api/v1/dealer/dashboard');
    return DealerDashboardSummary.fromJson(response.data);
  }
}
