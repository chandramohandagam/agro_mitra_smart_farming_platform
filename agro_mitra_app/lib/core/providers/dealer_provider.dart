import 'package:flutter/material.dart';
import '../services/dealer_service.dart';
import '../models/dealer_model.dart';

enum DealerStatus { loading, loaded, error }

class DealerProvider extends ChangeNotifier {
  final DealerService _service = DealerService();

  DealerStatus _status = DealerStatus.loading;
  DealerDashboardSummary? _summary;
  String? _errorMessage;

  DealerStatus get status => _status;
  DealerDashboardSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _status = DealerStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _service.getDealerDashboard();
      _status = DealerStatus.loaded;
    } catch (e) {
      _status = DealerStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
