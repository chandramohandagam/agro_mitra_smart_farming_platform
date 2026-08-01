import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

enum WeatherStatus { loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherStatus _status = WeatherStatus.loading;
  WeatherData? _weatherData;
  String? _errorMessage;

  WeatherStatus get status => _status;
  WeatherData? get weatherData => _weatherData;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather() async {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low
      );
      _weatherData = await _weatherService.getWeatherForecast(
        position.latitude,
        position.longitude
      );
      _status = WeatherStatus.loaded;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
