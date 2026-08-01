import '../api/api_client.dart';
import '../models/farm_model.dart';

class FarmService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Farm>> getFarms() async {
    final response = await _apiClient.get('/api/v1/farms');
    return (response.data as List).map((e) => Farm.fromJson(e)).toList();
  }
}
