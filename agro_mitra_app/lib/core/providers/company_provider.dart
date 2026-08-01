import 'package:flutter/material.dart';
import '../services/company_service.dart';
import '../models/company_model.dart';

enum CompanyStatus { loading, loaded, error }

class CompanyProvider extends ChangeNotifier {
  final CompanyService _service = CompanyService();

  CompanyStatus _status = CompanyStatus.loading;
  CompanyDashboardSummary? _summary;
  String? _errorMessage;

  CompanyStatus get status => _status;
  CompanyDashboardSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _status = CompanyStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _service.getCompanyDashboard();
      _status = CompanyStatus.loaded;
    } catch (e) {
      _status = CompanyStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
