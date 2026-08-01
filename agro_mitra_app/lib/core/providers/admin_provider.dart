import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/admin_model.dart';

enum AdminStatus { loading, loaded, error }

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  AdminStatus _status = AdminStatus.loading;
  AdminDashboardSummary? _summary;
  String? _errorMessage;

  AdminStatus get status => _status;
  AdminDashboardSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _status = AdminStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _service.getAdminDashboard();
      _status = AdminStatus.loaded;
    } catch (e) {
      _status = AdminStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
