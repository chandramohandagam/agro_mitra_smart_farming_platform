import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/recommendation_service.dart';
import '../models/recommendation_model.dart';

enum RecommendationStatus { idle, loading, loaded, error }

class RecommendationProvider extends ChangeNotifier {
  final RecommendationService _service = RecommendationService();

  RecommendationStatus _status = RecommendationStatus.idle;
  CropRecommendationResponse? _data;
  String? _errorMessage;

  RecommendationStatus get status => _status;
  CropRecommendationResponse? get data => _data;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendations({
    required String texture,
    required double ph,
    required int moisture,
  }) async {
    _status = RecommendationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      _data = await _service.getCropRecommendations(
        texture: texture,
        ph: ph,
        moisture: moisture,
        lat: pos.latitude,
        lon: pos.longitude
      );
      _status = RecommendationStatus.loaded;
    } catch (e) {
      _status = RecommendationStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
