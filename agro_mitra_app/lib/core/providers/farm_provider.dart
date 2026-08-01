import 'package:flutter/material.dart';
import '../services/farm_service.dart';
import '../models/farm_model.dart';

enum FarmStatus { loading, loaded, error, empty }

class FarmProvider extends ChangeNotifier {
  final FarmService _farmService = FarmService();

  FarmStatus _status = FarmStatus.loading;
  List<Farm> _farms = [];
  String? _errorMessage;

  FarmStatus get status => _status;
  List<Farm> get farms => _farms;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFarms() async {
    _status = FarmStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _farms = await _farmService.getFarms();
      _status = _farms.isEmpty ? FarmStatus.empty : FarmStatus.loaded;
    } catch (e) {
      _status = FarmStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
