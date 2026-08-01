import 'package:flutter/material.dart';
import '../services/scheme_service.dart';
import '../models/scheme_model.dart';

enum SchemeStatus { loading, loaded, error }

class SchemeProvider extends ChangeNotifier {
  final SchemeService _service = SchemeService();

  SchemeStatus _status = SchemeStatus.loading;
  List<GovScheme> _schemes = [];
  List<SchemeApplication> _applications = [];
  String? _errorMessage;

  SchemeStatus get status => _status;
  List<GovScheme> get schemes => _schemes;
  List<SchemeApplication> get applications => _applications;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSchemesAndApplications() async {
    _status = SchemeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getAvailableSchemes(),
        _service.getMyApplications(),
      ]);
      _schemes = results[0] as List<GovScheme>;
      _applications = results[1] as List<SchemeApplication>;
      _status = SchemeStatus.loaded;
    } catch (e) {
      _status = SchemeStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
