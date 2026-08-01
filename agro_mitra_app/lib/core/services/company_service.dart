import '../api/api_client.dart';
import '../models/company_model.dart';

class CompanyService {
  final ApiClient _apiClient = ApiClient();

  Future<CompanyDashboardSummary> getCompanyDashboard() async {
    final response = await _apiClient.get('/api/v1/company/dashboard');
    return CompanyDashboardSummary.fromJson(response.data);
  }
}
