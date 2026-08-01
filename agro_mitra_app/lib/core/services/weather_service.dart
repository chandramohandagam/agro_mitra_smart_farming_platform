import '../api/api_client.dart';
import '../models/weather_model.dart';

class WeatherService {
  final ApiClient _apiClient = ApiClient();

  Future<WeatherData> getWeatherForecast(double lat, double lon) async {
    final response = await _apiClient.get('/api/v1/weather/forecast', queryParameters: {
      'lat': lat,
      'lon': lon,
    });
    return WeatherData.fromJson(response.data);
  }
}
