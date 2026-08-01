import '../api/api_client.dart';
import '../models/scheme_model.dart';

class SchemeService {
  final ApiClient _apiClient = ApiClient();

  Future<List<GovScheme>> getAvailableSchemes() async {
    final response = await _apiClient.get('/api/v1/schemes');
    return (response.data as List).map((e) => GovScheme.fromJson(e)).toList();
  }

  Future<List<SchemeApplication>> getMyApplications() async {
    final response = await _apiClient.get('/api/v1/schemes/applications');
    return (response.data as List).map((e) => SchemeApplication.fromJson(e)).toList();
  }
}
