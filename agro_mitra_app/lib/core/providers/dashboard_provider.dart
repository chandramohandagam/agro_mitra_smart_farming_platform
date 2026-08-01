import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';

enum DashboardStatus { loading, loaded, error, empty }

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  DashboardStatus _status = DashboardStatus.loading;
  DashboardSummary? _summary;
  String? _errorMessage;

  DashboardStatus get status => _status;
  DashboardSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _status = DashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _dashboardService.getFarmerDashboard();
      if (_summary!.activeCrops.isEmpty && _summary!.upcomingTask == null) {
        _status = DashboardStatus.empty;
      } else {
        _status = DashboardStatus.loaded;
      }
    } catch (e) {
      _status = DashboardStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
