import '../api/api_client.dart';
import '../models/recommendation_model.dart';

class RecommendationService {
  final ApiClient _apiClient = ApiClient();

  Future<CropRecommendationResponse> getCropRecommendations({
    required String texture,
    required double ph,
    required int moisture,
    required double lat,
    required double lon,
  }) async {
    final response = await _apiClient.post('/api/v1/recommendations/crop', data: {
      'soil_texture': texture,
      'ph_level': ph,
      'moisture_percentage': moisture,
      'lat': lat,
      'lon': lon,
    });
    return CropRecommendationResponse.fromJson(response.data);
  }
}
